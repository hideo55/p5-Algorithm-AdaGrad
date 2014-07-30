#define PERL_NO_GET_CONTEXT
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

typedef std::unordered_map<std::string, double> features_type;

typedef struct AdaGradS {
    std::unordered_map<std::string, AdaGrad*> classifers;
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
    if(!sv_derived_from(object,"Algorithm::HyperLogLog")) {
        croak("%s is not a Algorithm::HyperLogLog", context);
    }
    address = SvIV(sv);
    if (!address)
    croak("Algorithm::AdaGrad object %s has a NULL pointer", context);
    return INT2PTR(AdaGradPtr, address);
}

MODULE = Algorithm::AdaGrad PACKAGE = Algorithm::AdaGrad

PROTOTYPES: DISABLE

AdaGradPtr
new(const char *klass, double eta)
CODE:
{
    AdaGradPtr obj = NULL;
    New(__LINE__, obj, 1, struct AdaGradS);
    obj->eta = eta;
    RETVAL = obj;
}
OUTPUT:
    RETVAL

int
update(AdaGradPtr self, SV* data)
CODE:
{
    RETVAL = 0;
}
OUTPUT:
    RETVAL

int
classify(AdaGradPtr self, SV* data)
CODE:
{
    RETVAL = 0;
}
OUTPUT:
    RETVAL

void
DESTROY(AdaGradPtr self)
CODE:
{
    std::unordered_map<std::string, AdaGrad*>& classifers = self->classifers;
    std::unordered_map<std::string, AdaGrad*>::iterator iter = classifers.begin();
    std::unordered_map<std::string, AdaGrad*>::iterator iter_end = classifers.end();   
    for(;iter != iter_end; ++iter){
        Safefree(iter->second);
    }
    Safefree (self);
}

