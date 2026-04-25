import numpy as np
import matplotlib.pyplot as plt

wn = 1.0   
zeta = 0.4 

sigma = np.linspace(-2.5, 0.5, 200)
omega = np.linspace(-3, 3, 200)
Sigma, Omega = np.meshgrid(sigma, omega)
S = Sigma + 1j * Omega

Hs = wn**2 / (S**2 + 2*zeta*wn*S + wn**2)

Z_dB = 20 * np.log10(np.abs(Hs))

z_min, z_max = -40, 20
Z_dB = np.clip(Z_dB, z_min, z_max)

fig = plt.figure(figsize=(12, 8))
ax = fig.add_subplot(projection='3d')

surf = ax.plot_surface(Sigma, Omega, Z_dB, cmap='coolwarm', edgecolor='none', 
                       alpha=0.6, zorder=1)

omega_1d = np.linspace(-3, 3, 500)
s_jw = 0 + 1j * omega_1d
H_jw = wn**2 / (s_jw**2 + 2*zeta*wn*s_jw + wn**2)
Z_jw_dB = np.clip(20 * np.log10(np.abs(H_jw)), z_min, z_max)

ax.plot(np.zeros_like(omega_1d), omega_1d, Z_jw_dB, color='black', linewidth=2, zorder=5,
        label=r'$|H(j\omega)| \text{ Slice at } \sigma=0$')



ax.set_xlim(np.min(sigma), np.max(sigma))
ax.set_ylim(np.min(omega), np.max(omega))
ax.set_zlim(z_min, z_max)

ax.set_xlabel(r'Real Part ($\sigma$)')
ax.set_ylabel(r'Imaginary Part ($j\omega$)')
ax.set_zlabel(r'Magnitude $|H(s)|$ (dB)')

# Set the title with the LaTeX rendered function
ax.set_title(r'3D Laplace Domain of 2nd Order Lowpass: $H(s) = \frac{\omega_n^2}{s^2 + 2\zeta\omega_n s + \omega_n^2}$', 
             fontsize=14, pad=20)

# Add the legend with LaTeX rendered math
# 'plot_surface' doesn't easily support legends, but our 1D lines do!
ax.legend(loc='upper left', fontsize=12)

# Adjust viewing angle for best visibility of the projection
ax.view_init(elev=25, azim=-45)

plt.show()
