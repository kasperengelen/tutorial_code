import numpy as np


def get_angles_floating_point(num_iters: int) -> list[float]:
    """
        Retrieve the angles used in each iteration of the algorithm.
    """
    return [np.arctan(2**(-i)) for i in range(num_iters)]


def cordic_circ_rot_floating_point(
        angle: float, num_iters: int,
        arctan_values: list[float]) -> (float, float, float):
    """
        Implementation of CORDIC in "circular rotation mode",
        making use of floating-point multiplication.
    """
    x = get_k_n(n=num_iters)
    y = 0
    theta = angle

    for i in range(num_iters):
        # store old values
        x_old = x
        y_old = y
        theta_old = theta

        # We apply the matrix
        #   /-                      -\
        #   | 1           -+ 2^{-i}  |
        #   | +- 2^{-i}   1          |
        #   \-                      -/
        if theta_old >= 0:
            x = x_old - (y_old * (2 ** (-i)))
            y = y_old + (x_old * (2 ** (-i)))
            theta = theta_old - arctan_values[i]
        else:
            x = x_old + (y_old * (2 ** (-i)))
            y = y_old - (x_old * (2 ** (-i)))
            theta = theta_old + arctan_values[i]

    return x, y, theta


def get_k_n(n: int) -> float:
    """
        Retrieve the total correction factor for n iterations.
    """
    prod = 1
    for i in range(0, n):
        prod *= 1/np.sqrt(1 + (2 ** (-2*i)))

    return prod


def run_floating_point():
    n = 24  # number of iterations
    angle = 0.945  # input angle

    angles = get_angles_floating_point(num_iters=n)
    theta_max = sum(angles)

    # call to CORDIC routine
    x_n, y_n, theta_n = cordic_circ_rot_floating_point(angle=angle, num_iters=n,
                                                       arctan_values=angles)

    # compare the computed values, and the reference values using NumPy
    print("x_n    =", x_n)
    print("np.cos =", np.cos(angle))

    print("y_n    =", y_n)
    print("np.sin =", np.sin(angle))
    print("")

    # print some diagnostic information
    print("theta_n                ", theta_n)
    print("gamma_{n-1}            ", angles[-1])
    print("theta_n <= gamma_{n-1}?", abs(theta_n) <= angles[-1])
    print("theta_max              ", theta_max)


if __name__ == '__main__':
    run_floating_point()
