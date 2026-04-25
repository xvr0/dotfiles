local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Optional: You can restrict these to only expand at the beginning of a line
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local snippets = {

  -------------------------------
  -- COMMON IMPORTS
  -------------------------------
  s({ trig = "implt", dscr = "Import Matplotlib" }, {
    t("import matplotlib.pyplot as plt"),
  }),

  s({ trig = "impnp", dscr = "Import NumPy" }, {
    t("import numpy as np"),
  }),

  s({ trig = "imppd", dscr = "Import Pandas" }, {
    t("import pandas as pd"),
  }),

  -- A combo snippet that drops all three standard data science imports at once
  s({ trig = "impds", dscr = "Standard Data Science Imports" }, {
    t({"import numpy as np", "import pandas as pd", "import matplotlib.pyplot as plt", ""})
  }),


  -------------------------------
  -- MATPLOTLIB BASICS
  -------------------------------
  
  -- Basic plot with X, Y, and a jump node for the label
  s({ trig = "pltp", dscr = "plt.plot()" }, {
    t("plt.plot("), i(1, "x"), t(", "), i(2, "y"), t(", label='"), i(3, "label"), t("')")
  }),

  -- Scatter plot
  s({ trig = "plts", dscr = "plt.scatter()" }, {
    t("plt.scatter("), i(1, "x"), t(", "), i(2, "y"), t(", label='"), i(3, "label"), t("')")
  }),

  -- Setup a figure with specific size (very common boilerplate)
  s({ trig = "pltfig", dscr = "plt.figure(figsize)" }, {
    t("plt.figure(figsize=("), i(1, "10"), t(", "), i(2, "6"), t("))")
  }),

  -- The object-oriented approach (subplots)
  s({ trig = "pltax", dscr = "fig, ax = plt.subplots()" }, {
    t("fig, ax = plt.subplots(figsize=("), i(1, "10"), t(", "), i(2, "6"), t("))")
  }),

  -- Formatting the plot (labels, title, legend)
  s({ trig = "pltformat", dscr = "Add title, labels, and legend" }, {
    t("plt.title('"), i(1, "Title"), t("')"), t({"", "plt.xlabel('"}), i(2, "X-axis"), t("')"), t({"", "plt.ylabel('"}), i(3, "Y-axis"), t("')"), t({"", "plt.legend()"})
  }),

  -- plt.show() - simple but you type it a lot!
  s({ trig = "pltsw", dscr = "plt.show()" }, {
    t("plt.show()")
  }),


  -------------------------------
  -- HELPER / UTILITY
  -------------------------------
  
  -- Quick print debugging
  s({ trig = "pr", dscr = "print()" }, {
    t("print("), i(1), t(")")
  }),
  
  -- f-string print (highly useful for debugging variables)
  s({ trig = "prf", dscr = "print(f'')" }, {
    t("print(f\""), i(1), t("\")")
  }),



-------------------------------
  -- 1. MATPLOTLIB 2D LINE PLOTS
  -------------------------------
  -- The outer boilerplate (Figure, labels, legend, show)
  s({ trig = "fig", dscr = "Standard Figure Boilerplate" }, {
    t("fig, ax = plt.subplots(figsize=("), i(1, "6"), t(", "), i(2, "6"), t("))"),
    t({"", "", ""}), 
    i(0), -- Your cursor will end up here so you can drop your 'ax' plots
    t({"", "", "ax.set_title('"}), i(3, "Title"), t("')"),
    t({"", "ax.set_xlabel('"}), i(4, "X-axis"), t("')"),
    t({"", "ax.set_ylabel('"}), i(5, "Y-axis"), t("')"),
    t({"", "ax.legend()", "plt.show()"})
  }),

  -- The inner plot command
  s({ trig = "ax", dscr = "ax.plot()" }, {
    t("ax.plot("), i(1, "x"), t(", "), i(2, "y"), t(", label='"), i(3, "Label"), t("')")
  }),


  -------------------------------
  -- 2. MATPLOTLIB 3D MESHGRID
  -------------------------------
  -- Full boilerplate for a 3D surface plot using a meshgrid
  s({ trig = "mesh", dscr = "3D Meshgrid Surface Plot" }, {
    t("fig, ax = plt.subplots(subplot_kw={'projection': '3d'}, figsize=("), i(1, "8"), t(", "), i(2, "6"), t("))"),
    t({"", "", "x = np.linspace("}), i(3, "-5"), t(", "), i(4, "5"), t(", 100)"),
    t({"", "y = np.linspace("}), i(5, "-5"), t(", "), i(6, "5"), t(", 100)"),
    t({"", "X, Y = np.meshgrid(x, y)"}),
    t({"", "R = np.sqrt(X**2 + Y**2) + 1e-10  # Added epsilon to avoid division by zero"}),
    t({"", "Z = "}), i(7, "np.sin(R) / R"),
    t({"", "", "surf = ax.plot_surface(X, Y, Z, cmap='"}), i(8, "viridis"), t("')"),
    t({"", "fig.colorbar(surf, shrink=0.5, aspect=5)"}),
    t({"", "", "ax.set_title('"}), i(9, "3D Surface Plot"), t("')"),
    t({"", "plt.show()"})
  }),
}
return snippets
