import matplotlib.pyplot as plt
import numpy as np


def plot(data, bin_size, chart_name):
    # Calculate the bin edges
    data = np.array(data)
    bin_edges = np.arange(data.min(), data.max() + bin_size, bin_size)

    # Create a histogram of the data
    hist, bin_edges = np.histogram(data, bins=bin_edges)

    # Calculate the bar positions and widths
    bar_positions = (bin_edges[:-1] + bin_edges[1:]) / 2
    bar_widths = bin_size * 0.9

    # Create a bar chart
    fig, ax = plt.subplots()
    ax.bar(bar_positions, hist, width=bar_widths, align="center")

    # Set the chart title and axis labels
    ax.set_title(f"{chart_name} Distribution")
    ax.set_xlabel(f"{chart_name}")
    ax.set_ylabel("Frequency")

    # Set the x-axis tick values and labels
    x_ticks = np.arange(int(data.min()), int(data.max()) + 1, bin_size)
    ax.set_xticks(x_ticks)
    ax.set_xticklabels(x_ticks.astype(int))

    # Set the y-axis tick values and labels
    y_ticks = np.arange(0, max(hist) * 1.3, max(hist) // 5 + 1)
    ax.set_yticks(y_ticks)
    ax.set_yticklabels(y_ticks.astype(int))

    # Add labels for the bar frequencies
    for x, y in zip(bar_positions, hist):
        label = "{:.0f}".format(y)
        ax.annotate(
            label,
            xy=(x, y),
            xytext=(0, 5),
            textcoords="offset points",
            ha="center",
            va="bottom",
        )

    # Show the chart
    plt.show()


# data = np.array(
#     [
#         1990,
#         1992,
#         1993,
#         1996,
#         1999,
#         2000,
#         2000,
#         2001,
#         2002,
#         2002,
#         2003,
#         2003,
#         2003,
#         2004,
#         2004,
#         2005,
#         2006,
#         2007,
#         2008,
#         2010,
#         2010,
#         2011,
#         2012,
#         2012,
#         2012,
#         2013,
#         2013,
#         2013,
#         2014,
#         2014,
#         2015,
#         2016,
#         2017,
#         2017,
#         2018,
#         2019,
#         2019,
#         2020,
#         2021,
#     ]
# )


# plot(data, 10, "year")
