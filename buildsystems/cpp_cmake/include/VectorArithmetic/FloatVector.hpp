#pragma once

#include <vector>

/**
 * That that represents a vector of floating point numbers.
 */
class FloatVector {
private:
    std::vector<float> elements_;

public:
    /**
     * Constructor.
     */
    FloatVector(std::vector<float> elements)
        : elements_{elements}
    {}

    /**
     * The number of dimensions of the vector.
     */
    size_t num_dimensions();

    /**
     * Retrieve an element of the vector.
     */
    float get_element(size_t idx);

    /**
     * Sort the elements from low to high.
     */
    void sort();

    /**
     * Retrieve the maximum element.
     */
    float max();

    /**
     * Retrieve the minimum element.
     */
    float min();

    /**
     * Returns a string representation of the vector.
     */
    std::string to_string();
};

