from math import inf, atan, degrees
import matplotlib.pyplot as plt
def plot_helical(d):
    '''Plot 0-slip angle curves at stations along prop
    radius for several p/D values.
    '''
    # fractions of propeller radius
    x = [i/10. for i in range(1,11)]
    x = [.01] + x; # Move hub over a bit to make math nice

    # Plot curves for several p/D values
    plt.figure(figsize=(6,10))
    plt.grid()
    for P_D in [.4, .6, .8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.4]:
        y = [degrees(atan(P_D / (d * xi))) for xi in x]
        if P_D == 1.0:
            print(y)
            print(len(y))
        plt.plot(x, y);
        plt.text(x[-1], y[-1], ' {0} '.format(P_D))
    plt.show()

if __name__ == "__main__":
    # Plot curves for a 6" dia. prop
    plot_helical(3)

