
import numpy as np
from fxpmath import Fxp

from cordic_python.cordic_plot import plot_steps_circ, plot_steps_circ_animated, CordicStep, CordicPoint


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


def cordic_circular_rotation_fixed_point_animated(
        angle: Fxp,
        num_iters: int,
        arctan_values: list[Fxp]
) -> list[CordicStep]:
    """
        Implementation of CORDIC in "circular rotation mode",
        making use of fixed-point arithmetic.
    """
    # we track every step of the algorithm, such that we can plot it later
    steps = []

    x = Fxp(get_k_n(n=num_iters), signed=True, n_word=NUM_BITS_WORD, n_frac=NUM_BITS_FRAC)
    y = Fxp(0.0, signed=True, n_word=NUM_BITS_WORD, n_frac=NUM_BITS_FRAC)
    theta = angle

    for i in range(num_iters):
        x_old = x.copy()
        y_old = y.copy()
        theta_old = theta.copy()

        # We apply the matrix
        #   /-                                -\
        #   | 1                -delta * 2^{-i} |
        #   | delta * 2^{-i}   1               |
        #   \-                                -/
        if theta_old < 0:
            # NOTE: we use set_val, since the computed value might have
            # different precision, and we wish to keep the current precision
            x.set_val(x_old + (y_old >> i))
            y.set_val(-(x_old >> i) + y_old)
            theta.set_val(theta_old + arctan_values[i])
        else:
            x.set_val(x_old - (y_old >> i))
            y.set_val((x_old >> i) + y_old)
            theta.set_val(theta_old - arctan_values[i])

        steps.append(CordicStep(
            before=CordicPoint(float(x_old), float(y_old), float(theta_old)),
            after=CordicPoint(float(x), float(y), float(theta))
        ))

    return steps


def get_k_n(n: int) -> float:
    """
        Retrieve the total correction factor for n iterations.
    """
    prod = 1
    for i in range(0, n):
        prod *= 1/np.sqrt(1 + (2 ** (-2*i)))

    return prod


def run_fixed_point_animated():
    n = 10  # number of iterations
    angle = 0.945  # input angle
    angle = Fxp(angle, signed=True, n_word=NUM_BITS_WORD, n_frac=NUM_BITS_FRAC)

    angles = get_angles_fxp(num_iters=n)
    theta_max = sum(angles)

    steps = cordic_circular_rotation_fixed_point_animated(angle=angle.copy(), arctan_values=angles, num_iters=n)

    last_step = steps[-1]
    x_n = last_step.after[0]
    y_n = last_step.after[1]
    theta_n = last_step.after[2]

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

    target_vec = CordicPoint(np.cos(float(angle)), np.sin(float(angle)), 0)
    plot_steps_circ(steps=steps, target=target_vec)
    # plot_steps_circ_animated(steps=steps, target=target_vec)


if __name__ == '__main__':
    run_fixed_point_animated()
