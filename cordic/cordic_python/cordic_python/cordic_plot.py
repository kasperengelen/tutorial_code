from collections import namedtuple
from datetime import datetime
from pathlib import Path
from typing import Optional

import numpy as np
from matplotlib import pyplot as plt, patches
from matplotlib.animation import FuncAnimation, PillowWriter
from matplotlib.axes import Axes


CordicPoint = namedtuple('CordicPoint', ['x', 'y', 'theta'])


class CordicStep:
    """
        Represents a single iteration in the CORDIC algorithm:
            - old values (x_i,y_i,theta_i)
            - new values (x_i+1,y_i+1,theta_i+1)
    """
    def __init__(self, before: CordicPoint, after: CordicPoint):
        self.before = before
        self.after = after

    def get_before(self) -> CordicPoint:
        """
            Retrieve the value of the variables at the beginning
            of the iteration.
        """
        return self.before

    def get_after(self) -> CordicPoint:
        """
            Retrieve the value of the variables at the end
            of the iteration.
        """
        return self.after


def get_timestamp() -> str:
    return datetime.now().strftime("%y%m%d-%H%M%S")


def plot_steps_circ_animated(steps: list[CordicStep], target: CordicPoint, num_initial_frames=4):
    """
        Plot the steps of the CORDIC algorithm on a unit circle and animate them as a GIF. Only works for
        the circular rotation mode.

        The specified target-vector will also be drawn.
    """
    plots_dir = Path(f"./plots_{get_timestamp()}/")
    plots_dir.mkdir(exist_ok=False, parents=True)

    # fig, ax = plt.subplots()
    fig = plt.figure(figsize=(7, 7))
    ax = fig.add_subplot(1, 1, 1)

    num_frames = (len(steps) * 2) + num_initial_frames

    def animate(frame_nr):

        # clear the drawing
        ax.clear()

        # first four frames
        frame_nr = frame_nr - num_initial_frames

        if frame_nr < 0:
            # one of the "initial" frames.
            iter_nr = 0
            step = steps[iter_nr]

            # only plot the "before" vector as the current vector.
            after = step.get_before()

            # no gray vector needed
            before = None
        else:
            # normal frame:
            iter_nr = frame_nr // 2
            step = steps[iter_nr]
            after = step.get_after()

            if frame_nr % 2 == 0:
                # the "before" frame where both the old and new vectors are displayed
                before = step.get_before()
            else:
                # only display the result after the rotation
                before = None

        plot_cordic_step_circ(iter_nr=iter_nr, ax=ax, before=before, after=after, target=target)

    fig.tight_layout()
    ani = FuncAnimation(fig, animate, frames=num_frames)
    ani.save(plots_dir / "test.gif", dpi=150, writer=PillowWriter(fps=2))


def plot_steps_circ(steps: list[CordicStep], target: CordicPoint):
    """
        Plot the specified steps of the CORDIC algorithm, with the specified target vector.

        The figures will be saved as PNG files.
    """
    plots_dir = Path(f"./plots_{get_timestamp()}/")
    plots_dir.mkdir(exist_ok=False, parents=True)

    fig = plt.figure(figsize=(7, 7))
    ax = fig.add_subplot(1, 1, 1)
    plot_cordic_step_circ(ax=ax, iter_nr=0, before=None, after=steps[0].get_before(), target=target)
    fig_path = plots_dir / f"init.png"
    fig.tight_layout()
    fig.savefig(fig_path)
    plt.close(fig)

    for i, step in enumerate(steps):

        # we plot every step
        fig = plt.figure(figsize=(7, 7))
        ax = fig.add_subplot(1, 1, 1)
        plot_cordic_step_circ(ax=ax, iter_nr=i, before=step.get_before(), after=step.get_after(), target=target)
        fig_path = plots_dir / f"step_{i}_a.png"
        fig.tight_layout()
        fig.savefig(fig_path)
        plt.close(fig)

        fig = plt.figure(figsize=(7, 7))
        ax = fig.add_subplot(1, 1, 1)
        plot_cordic_step_circ(ax=ax, iter_nr=i, before=None, after=step.get_after(), target=target)
        fig_path = plots_dir / f"step_{i}_b.png"
        fig.tight_layout()
        fig.savefig(fig_path)
        plt.close(fig)


def plot_cordic_step_circ(ax: Axes, iter_nr: int, before: Optional[CordicPoint], after: CordicPoint,
                          target: CordicPoint):
    """
        Plot a single step of the CORDIC algorithm on the specified plot.

        The old vector will be displayed in gray. The new vector will be displayed in black. The target
        vector will be displayed in green.
    """

    # plot x and y axis
    ax.axhline(y=0, color='k')
    ax.axvline(x=0, color='k')

    # set dimensions
    ax.set_xlim([-1.2, 1.2])
    ax.set_ylim([-1.2, 1.2])

    # plot unit circle
    #   - create a set of points 0, ..., 2*pi
    #   - draw points (cos(t), sin(t)) for all these points
    t = np.linspace(0, np.pi * 2, 100)
    ax.plot(np.cos(t), np.sin(t), linewidth=1)

    ax.arrow(0, 0, target.x, target.y, color="green", head_width=0.04, length_includes_head=True)

    ax.arrow(0, 0, after.x, after.y, color="black", head_width=0.04, length_includes_head=True)

    if before is not None:
        ax.arrow(0, 0, before.x, before.y, color="gray", head_width=0.04, length_includes_head=True)

    if before is not None and abs(before.theta - after.theta) >= 0.04:
        draw_rotation(before, after)

    text = ""
    text += f"E. angle: {abs(after.theta - target.theta):.2f}\n"
    text += f"E. cosine: {abs(after.x - target.x):.2f}\n"
    text += f"E. sine: {abs(after.y - target.y):.2f}\n"
    text += f"Iteration: {iter_nr}"

    ax.text(0.65, 0.87, text, fontsize=12, bbox={"facecolor": 'red', "alpha": 0.5})


def draw_rotation(before: CordicPoint, after: CordicPoint):
    """
        Draw a bent red arrow between the specified points. The arrow is bent away from the origin.
    """
    # we bend away from the origin.
    if before.theta > after.theta:
        bend = 0.2
    else:
        bend = -0.2

    # render and add arrow
    patch = patches.FancyArrowPatch(
        posA=(before.x, before.y), posB=(after.x, after.y),
        connectionstyle=f"arc3,rad={bend}",
        arrowstyle="Simple, head_width=5, head_length=10",
        color="red")
    plt.gca().add_patch(patch)
