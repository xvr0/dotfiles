import matplotlib.pyplot as plt
import numpy as np
import tikzplotlib # It will automatically use the patched version

x = np.linspace(0, 10, 100)
plt.plot(x, np.sin(x), label="Sine Wave")

# Save directly to editable TikZ/PGFPlots format
tikzplotlib.save("example.tex")
