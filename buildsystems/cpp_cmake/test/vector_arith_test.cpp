#include <gtest/gtest.h>

#include <VectorArithmetic/FloatVector.hpp>
#include <VectorArithmetic/vector_arith.hpp>


TEST(VectorArithmeticTest, TestAddition) {
    FloatVector x{{1.0, 2.4, -3.0}};
    FloatVector y{{-3.2, 4.0, 5.5}};

    auto sum = add_vectors(x, y);

    EXPECT_FLOAT_EQ(sum.get_element(0), 1.0 + (-3.2));
    EXPECT_FLOAT_EQ(sum.get_element(1), 2.4 + 4.0);
    EXPECT_FLOAT_EQ(sum.get_element(2), -3.0 + 5.5);
}


TEST(VectorArithmeticTest, TestDotProduct) {
    FloatVector x{{1.0, 2.4, -3.0}};
    FloatVector y{{-3.2, 4.0, 5.5}};

    const float dot = dot_product(x, y);

    EXPECT_FLOAT_EQ(dot, 1.0 * -3.2 + 2.4 * 4.0 + (-3.0) * 5.5);
}
