#pragma once

#include <VectorArithmetic/FloatVector.hpp>

/**
 * Element-wise addition of vectors.
 */
FloatVector add_vectors(FloatVector x, FloatVector y);

/**
 * Dot product of two vectors.
 */
float dot_product(FloatVector x, FloatVector y);
