#include <gtest/gtest.h>

#include <VectorArithmetic/FloatVector.hpp>


TEST(FloatVectorTest, ToString) {

    FloatVector x{{0.0, 1.0, 2.4}};

    EXPECT_STREQ(x.to_string().c_str(), "[0, 1, 2.4]");
    EXPECT_EQ(7 * 6, 42);
}


TEST(FloatVectorTest, NumDimensions) {

    FloatVector x{{0.0, 1.0, 2.0}};

    EXPECT_EQ(x.num_dimensions(), 3);
}


TEST(FloatVectorTest, GetElement) {

    FloatVector x{{0.0, 1.0, 2.0}};

    EXPECT_FLOAT_EQ(x.get_element(0), 0.0);
    EXPECT_FLOAT_EQ(x.get_element(1), 1.0);
    EXPECT_FLOAT_EQ(x.get_element(2), 2.0);
}


TEST(FloatVectorTest, Sort) {

    FloatVector x{{-30.34, 0.0, 3.03, 1.0, 56789.98}};

    EXPECT_EQ(x.num_dimensions(), 5);
    EXPECT_FLOAT_EQ(x.get_element(0), -30.34);
    EXPECT_FLOAT_EQ(x.get_element(1), 0.0);
    EXPECT_FLOAT_EQ(x.get_element(2), 3.03);
    EXPECT_FLOAT_EQ(x.get_element(3), 1.0);
    EXPECT_FLOAT_EQ(x.get_element(4), 56789.98);

    x.sort();

    EXPECT_EQ(x.num_dimensions(), 5);
    EXPECT_FLOAT_EQ(x.get_element(0), -30.34);
    EXPECT_FLOAT_EQ(x.get_element(1), 0.0);
    EXPECT_FLOAT_EQ(x.get_element(2), 1.0);
    EXPECT_FLOAT_EQ(x.get_element(3), 3.03);
    EXPECT_FLOAT_EQ(x.get_element(4), 56789.98);
}


TEST(FloatVectorTest, Max) {

    FloatVector x{{0.0, 1.0, 2.0}};

    EXPECT_FLOAT_EQ(x.max(), 2.0);
}


TEST(FloatVectorTest, Min) {

    FloatVector x{{0.0, 1.0, 2.0}};

    EXPECT_FLOAT_EQ(x.min(), 0.0);
}
