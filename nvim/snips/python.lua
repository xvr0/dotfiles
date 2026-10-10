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

  s({trig="ifsave", dscr="plot for tex"},{t({"SAVE = False",

"if SAVE:",
"    mpl.use(\"pgf\")",
"    mpl.rcParams.update(",
"        {",
"            \"pgf.texsystem\": \"pdflatex\",",
"            \"text.usetex\": True,",
"            \"font.family\": \"serif\",",
"            \"font.size\": 10,",
"            \"axes.labelsize\": 10,",
"            \"axes.titlesize\": 10,",
"            \"legend.fontsize\": 8,",
"            \"xtick.labelsize\": 8,",
"            \"ytick.labelsize\": 8,",
"        }",
"    )",
"else:",
"    mpl.rcParams.update(",
"        {",
"            \"font.family\": \"serif\",",
"            \"font.size\": 10,",
"        }",
"    )",
})})
}

return snippets
