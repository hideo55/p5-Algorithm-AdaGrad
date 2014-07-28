#if !defined(ADAGRAD_HPP_)
#define ADAGRAD_HPP_

#include <cmath>

class AdaGrad {
public:
    AdaGrad() alpha_(0.5), sumOfGrandient_(0.0), numOfGradient_(0), current_(0.0) {

    }

    virtual ~AdaGrad() {
    }

    void update(double gradient) {
        ++numOfGradient_;
        sumOfGradient_ += gradient * gradient;
        current_ = current_ - (alpha_ / sqrt(sumOfGradient_) * gradient);
    }

    void setAlpha(double alpha) {
        alpha_ = alpha;
    }

    double getAlpha() const {
        return alpha_;
    }

    double getNumOfGradient() const {
        return numOfGradient_;
    }

    double getValue() const {
        return current_;
    }

private:
    double alpha_;
    double sumOfGradient_;
    size_t numOfGradient_;
    double current_;

};

#endif /* !defined(ADAGRAD_HPP_) */
