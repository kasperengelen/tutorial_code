import numpy as np
from fxpmath import Fxp


def get_angles_fxp(num_iters: int) -> list[Fxp]:
    """
        Retrieve the angles used in each iteration of the algorithm.
    """
    return [
        Fxp(np.arctan(2**(-i)), True, NUM_BITS_WORD, NUM_BITS_FRAC)
        for i in range(num_iters)
    ]


NUM_BITS_WORD = 32
NUM_BITS_FRAC = 30


def cordic_circ_rot_fixed_point(
        angle: float, num_iters: int,
        arctan_values: list[Fxp],
) -> (Fxp, Fxp, Fxp):
    """
        Implementation of CORDIC in "circular rotation mode",
        making use of fixed-point arithmetic.
    """

    # convert to fixed point
    x = Fxp(val=get_k_n(n=num_iters), signed=True, n_word=NUM_BITS_WORD, n_frac=NUM_BITS_FRAC)
    y = Fxp(val=0.0, signed=True, n_word=NUM_BITS_WORD, n_frac=NUM_BITS_FRAC)
    theta = Fxp(val=angle, signed=True, n_word=NUM_BITS_WORD, n_frac=NUM_BITS_FRAC)

    for i in range(num_iters):
        x_old = x.copy()
        y_old = y.copy()
        theta_old = theta.copy()

        # We apply the matrix
        #   /-                     -\
        #   | 1           -+ 2^{-i} |
        #   | +- 2^{-i}   1         |
        #   \-                     -/
        if theta_old >= 0:
            # NOTE: we use set_val, since the computed value might have
            # different precision, and we wish to keep the current precision
            x.set_val(x_old - (y_old >> i))
            y.set_val(y_old + (x_old >> i))
            theta.set_val(theta_old - arctan_values[i])
        else:
            x.set_val(x_old + (y_old >> i))
            y.set_val(y_old - (x_old >> i))
            theta.set_val(theta_old + arctan_values[i])

    # convert back to float
    return x, y, theta


def get_k_n(n: int) -> float:
    """
        Retrieve the total correction factor for n iterations.
    """
    prod = 1
    for i in range(0, n):
        prod *= 1/np.sqrt(1 + (2 ** (-2*i)))

    return prod


def run_fixed_point():
    n = 24  # number of iterations
    angle = 0.945  # input angle

    angles = get_angles_fxp(num_iters=n)
    theta_max = sum(angles)

    # call to CORDIC routine
    x_n, y_n, theta_n = cordic_circ_rot_fixed_point(angle=angle, num_iters=n, arctan_values=angles)

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
    run_fixed_point()
