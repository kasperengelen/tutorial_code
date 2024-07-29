
import numpy as np


def print_determinant_test_cases(size):
    """
        Print some matrices and their determinants.
    """
    mat_rand = np.random.random((size, size))

    # scale the matrix to get more interesting results
    mat_rand_scale = np.array([
        [(elem*50)-25 for elem in row]
        for row in mat_rand
    ])

    print("Matrix:", [list(row) for row in mat_rand_scale])
    
    print("Det:", np.linalg.det(mat_rand_scale))


def print_cramer_test_cases(size):
    """
        Print some examples of systems of linear equations and their solutions.
    """

    # create matrix and make it orthogonal
    X = np.random.random((size, size))
    Q, _ = np.linalg.qr(X)

    # print matrix
    print("Matrix:")
    print([ list(row) for row in Q])

    # generate vector b
    b = np.random.random((size, 1))
    print("Vector b:")
    print([ row[0] for row in b])

    # obtain the actual solution
    x = np.linalg.solve(Q, b)
    print("Solution x:")
    print([ row[0] for row in x])
    
    # https://numpy.org/doc/stable/reference/generated/numpy.linalg.solve.html
    is_close = np.allclose(np.dot(Q, x), b)
    print("Solution correct:", is_close)


def main():
    size = 3

    print_cramer_test_cases(size=size)
    print("=========")
    print_determinant_test_cases(size=size)


if __name__ == "__main__":
    main()
