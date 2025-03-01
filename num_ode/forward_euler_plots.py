
import numpy as np
import matplotlib.pyplot as plt


def func_example_3(t):
    """
        The exact solution for example 3. Initial value y(0) = -7.
    """
    return -((t - 3) ** 2) + 2


def deriv_example_3(t):
    """
        The ODE of example 3.
    """
    return 6 - 2*t


def get_euler_steps(step_size, num_steps, init_t, init_y):
    cur_t = init_t
    cur_y = init_y
    euler_T = [cur_t]  # time values
    euler_Y = [cur_y]  # solution values

    step = step_size
    for i in range(num_steps):

        cur_y = cur_y + step * deriv_example_3(cur_t)
        cur_t += step

        euler_T.append(cur_t)
        euler_Y.append(cur_y)

        print(f"y_{i+1} &= y_{i} + hf(t_{i}, y_{i}) = {int(euler_Y[-2])} + {step} \\cdot (6 - 2 \\cdot {int(euler_T[-2])}) = {int(euler_Y[-1])} \\\\")

    return euler_T, euler_Y


def steps():
    """
        Create a plot with the different steps of the forward Euler method, for different time steps. 
        This also provides support for plotting the tangents of the solution of an ODE.
    """

    # prepare figure and plot exact solution
    a = 0
    b = 5
    n = 500
    times = np.linspace(a,b,n)
    exact = func_example_3(times)
    plt.figure(figsize=(5,5))
    plt.subplot(1, 1, 1)
    plt.plot(times, exact, 'g', label="Exact")

    # initial value
    cur_t = 0.0
    cur_y = func_example_3(cur_t)

    print(f"y(0) = {cur_y}")

    # step size h=1
    euler_T, euler_Y = get_euler_steps(step_size=1, num_steps=5, init_t=0.0, init_y=func_example_3(0.0))
    plt.plot(euler_T, euler_Y, "-o", label="h=1")

    # step size h=0.1
    # euler_T, euler_Y = get_euler_steps(step_size=0.1, num_steps=50, init_t=0.0, init_y=func_example_3(0.0))
    # plt.plot(euler_T, euler_Y, label="h=0.1")

    # plot tangents
    for t in range(0, 5):
        time_begin = t
        time_end = t+1
        exact_y_begin = func_example_3(time_begin)
        tangent = deriv_example_3(time_begin)

        if t == 0:
            label = "Tangent"
        else:
            label = None

        plt.plot([time_begin, time_end], [exact_y_begin, exact_y_begin + tangent], 'ro-', label=label)


    plt.xlabel('t', fontdict={'fontsize': 15, 'fontweight': '500'})
    plt.ylabel('y(t)', fontdict={'fontsize': 15, 'fontweight': '500', 'rotation': 0}) 
    plt.xticks(fontsize=12, rotation=0)
    plt.yticks(fontsize=12, rotation=0)

    plt.legend(prop={'size':12})
    plt.show()


if __name__ == "__main__":
    steps()
