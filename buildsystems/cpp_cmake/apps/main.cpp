

#include <iostream>
#include <ranges>
#include <getopt.h>
#include <VectorArithmetic/FloatVector.hpp>
#include <VectorArithmetic/vector_arith.hpp>

/**
 * Given a string of the format "a,b,c" this will return
 * a vector [a, b, c] of floats.
 */
std::vector<float> parse_vector(const std::string& s) {
    std::vector<float> result;

    for (auto part : s | std::views::split(',')) {
        std::string token(part.begin(), part.end());
        result.push_back(std::stof(token));
    }

    return result;
}

void print_help(const char* prog) {
    std::cout << "Usage:\n"
              << "  " << prog << " -a \"<vec1>\" -b \"<vec2>\"\n\n"
              << "Options:\n"
              << "  -a <vec>    First vector (comma separated)\n"
              << "  -b <vec>    Second vector (comma separated)\n"
              << "  -h          Show this help menu\n"
              << "  -v          Show version\n" << std::endl;
}

int parse_argument(int argc, char** argv, std::string &a_str, std::string &b_str) {
    int opt;
    while ((opt = getopt(argc, argv, "a:b:hv")) != -1) {
        switch (opt) {
            case 'a':
                a_str = optarg;
                break;

            case 'b':
                b_str = optarg;
                break;

            case 'h':
                print_help(argv[0]);
                return 0;

            case 'v':
                std::cout << "Vector arithmetic calculator version 1.0" << std::endl;
                return 0;

            default:
                print_help(argv[0]);
                return 1;
        }
    }

    return 0;
}

int main(int argc, char** argv) {
    
    // parse arguments
    std::string a_str, b_str;
    int parse_result = parse_argument(argc, argv, a_str, b_str);
    if(parse_result != 0) {
        return 1;
    }

    if(a_str.empty() or b_str.empty()) {
        std::cout << "Error: a and b must be non-empty vectors!" << std::endl;
        return 1;
    }

    try {
        FloatVector a{parse_vector(a_str)};
        FloatVector b{parse_vector(b_str)};

        if(a.num_dimensions() != b.num_dimensions()) {
            std::cout << "Error: a and b must have the same number of dimensions!" << std::endl;
            return 1;
        }

        FloatVector sum = add_vectors(a, b);

        std::cout << "a: " << a.to_string() << "\n";
        std::cout << "b: " << b.to_string() << "\n";
        std::cout << "sum: " << sum.to_string() << "\n";
    } 
    catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << "\n";
        return 1;
    }

    return 0;
}
