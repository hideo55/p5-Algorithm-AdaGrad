#define PERL_NO_GET_CONTEXT

#pragma GCC diagnostic ignored "-Wreserved-user-defined-literal"

extern "C" {
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
}
#include "AdaGrad.hpp"
#include <string>

#if __cplusplus < 201103L
#include <tr1/unordered_map>
namespace std {
    using namespace std::tr1;
}
#else
#include <unordered_map>
#endif

#define MAGIC 1

enum {
    POSITIVE_LABEL = 1,
    NEGATIVE_LABEL = -1,
};

typedef std::unordered_map<std::string, AdaGrad*> classifers_type;

typedef struct AdaGradS {
    classifers_type* classifers;
    double eta;
}* AdaGradPtr;

#define GET_ADAGRAD_PTR(x) get_adagrad(aTHX_ x, "$self")

static AdaGradPtr get_adagrad(pTHX_ SV* object, const char* context) {
    SV *sv;
    IV address;

    if (MAGIC) SvGETMAGIC(object);
    if (!SvROK(object)) {
        if (SvOK(object)) croak("%s is not a reference", context);
        croak("%s is undefined", context);
    }
    sv = SvRV(object);
    if (!SvOBJECT(sv)) croak("%s is not an object reference", context);
    if(!sv_derived_from(object,"Algorithm::AdaGrad")) {
        croak("%s is not a Algorithm::AdaGrad", context);
    }
    address = SvIV(sv);
    if (!address)
    croak("Algorithm::AdaGrad object %s has a NULL pointer", context);
    return INT2PTR(AdaGradPtr, address);
}

static void handleUpdate(pTHX_ AdaGradPtr self, SV* sv) {
    SvGETMAGIC (sv);
    
    if(!SvROK(sv) || SvTYPE(SvRV(sv)) != SVt_PVHV) {
        croak("Invalid parameter: parameter must be HASH-reference");
    }

    HV* hv = (HV*)SvRV(sv);
    STRLEN len;

    SV** tmpSV = hv_fetchs(hv, "label", 0);
    if(tmpSV == NULL) {
        croak("Invalid parameter: \"label\" does not exist.");
    } else if(SvTYPE(*tmpSV) != SVt_IV){
        croak("Invalid parameter: \"label\" must be 1 or -1.");
    }
    IV label = SvIV(*tmpSV);
    if(label != POSITIVE_LABEL && label != NEGATIVE_LABEL){
        croak("Invalid parameter: \"label\" must be 1 or -1.");
    }
    
    tmpSV = hv_fetchs(hv, "data", 0);
    if(tmpSV == NULL) {
        croak("Invalid parameter: \"data\" does not exist.");
    } else if(SvROK(*tmpSV) && SvTYPE(SvRV(*tmpSV)) != SVt_PVHV) {
        croak("Invalid parameter: \"data\" must be HASH-reference.");
    }
    HV* features = (HV*)SvRV(*tmpSV);

    hv_iterinit(features);
    HE* he = NULL;
    std::unordered_map<std::string, AdaGrad*>& classifers = *(self->classifers);
    while ((he = hv_iternext(features))){
        char* key = HePV(he, len);
        std::string featStr = std::string(key, len);
        SV* val = HeVAL(he);
        if(SvTYPE(val) != SVt_NV){
            croak("Invalid parameter: type of internal \"data\" must be number.");
        }
        NV nv = SvNV(val);
        double gradient = -1.0 * nv * label;
        if(classifers.find(featStr) == classifers.end()){
            classifers.insert(std::make_pair(featStr, new AdaGrad(self->eta)));
        }
        AdaGrad* ag = classifers[featStr];
        ag->update(gradient);
    }
}

MODULE = Algorithm::AdaGrad PACKAGE = Algorithm::AdaGrad

PROTOTYPES: DISABLE

AdaGradPtr
new(const char *klass, ...)
PREINIT:
    double eta = 0.0;
CODE:
{
    if(items > 1){
        if(SvTYPE(ST(1)) != SVt_NV){
            croak("Parameter must be a number.");
        }
        eta = SvNV(ST(1));
    }
    AdaGradPtr obj = NULL;
    New(__LINE__, obj, 1, struct AdaGradS);
    obj->classifers = new classifers_type();
    obj->eta = eta;
    RETVAL = obj;
}
OUTPUT:
    RETVAL

int
update(AdaGradPtr self, SV* sv)
CODE:
{   
    SvGETMAGIC (sv);
    if(!SvROK(sv) || SvTYPE(SvRV(sv)) !=  SVt_PVAV) {
        croak("Parameter must be ARRAY-reference");
    }

    AV* av = (AV*)SvRV(sv);
    size_t arraySize = av_len(av);
    for(size_t i = 0; i <= arraySize; ++i){
        SV** elm = av_fetch(av, i, 0);
        if(elm != NULL){
            handleUpdate(self, *elm);       
        }
    }
    RETVAL = 0;
}
OUTPUT:
    RETVAL

int
classify(AdaGradPtr self, SV* sv)
CODE:
{
    if(!SvROK(sv) || SvTYPE(SvRV(sv)) != SVt_PVHV) {
        croak("Parameter must be HASH-reference");
    }
    
    HV* features = (HV*)SvRV(sv);

    hv_iterinit(features);
    HE* he = NULL;
    STRLEN len;
    std::unordered_map<std::string, AdaGrad*>& classifers = *(self->classifers);
    double margin = 0.0;
    while ((he = hv_iternext(features))){
        char* key = HePV(he, len);
        std::string featStr = std::string(key, len);
        classifers_type::const_iterator iter = classifers.find(featStr);
        if(iter == classifers.end()){
            continue;
        }
        AdaGrad* ag = iter->second;
        
        SV* val = HeVAL(he);
        if(SvTYPE(val) != SVt_NV){
            croak("Invalid parameter: type of internal \"data\" must be number.");
        }
        NV nv = SvNV(val);
        margin += ag->classify(nv);
    }

    RETVAL = margin >= 0 ? POSITIVE_LABEL : NEGATIVE_LABEL;
}
OUTPUT:
    RETVAL

void
DESTROY(AdaGradPtr self)
CODE:
{
    std::unordered_map<std::string, AdaGrad*>& classifers = *(self->classifers);
    std::unordered_map<std::string, AdaGrad*>::iterator iter = classifers.begin();
    std::unordered_map<std::string, AdaGrad*>::iterator iter_end = classifers.end();   
    for(;iter != iter_end; ++iter){
        Safefree(iter->second);
    }
    Safefree (self->classifers);
    Safefree (self);
}

