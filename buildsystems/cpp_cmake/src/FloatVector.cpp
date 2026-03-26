

#include <algorithm>
#include <fmt/format.h>
#include <fmt/ranges.h>

#include <VectorArithmetic/FloatVector.hpp>


size_t FloatVector::num_dimensions() {
    return this->elements_.size();
}

float FloatVector::get_element(size_t idx) {
    return this->elements_.at(idx);
}

void FloatVector::sort()
{
    std::sort(this->elements_.begin(), this->elements_.end());
}

float FloatVector::max()
{
    auto it = std::max_element(this->elements_.begin(), this->elements_.end());
    return *it;
}

float FloatVector::min()
{
    auto it = std::min_element(this->elements_.begin(), this->elements_.end());
    return *it;
}

std::string FloatVector::to_string()
{
    return fmt::format("[{}]", fmt::join(this->elements_, ", "));
}
