
#include <VectorArithmetic/vector_arith.hpp>


FloatVector add_vectors(FloatVector x, FloatVector y) {
    std::vector<float> result(x.num_dimensions());

    for(size_t i = 0; i < x.num_dimensions(); i++) {
        result.at(i) = x.get_element(i) + y.get_element(i);
    }

    return FloatVector{result};
}

float dot_product(FloatVector x, FloatVector y) {
    float result = 0.0;

    for(size_t i = 0; i < x.num_dimensions(); i++) {
        result += x.get_element(i) * y.get_element(i);
    }

    return result;
}
