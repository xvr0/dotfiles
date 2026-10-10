local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node


ls.config.set_config({
    enable_autosnippets = true,
})


-- math detection (vimtex)
local function M() return vim.fn["vimtex#syntax#in_mathzone"]() == 1 end


local symbols = {
  -- Greek lowercase
  { trig = "@a",       tex = "\\alpha" },
  { trig = "alpha",    tex = "\\alpha" },
  { trig = "@b",       tex = "\\beta" },
  { trig = "beta",     tex = "\\beta" },
  { trig = "@g",       tex = "\\gamma" },
  { trig = "gamma",    tex = "\\gamma" },
  { trig = "@d",       tex = "\\delta" },
  { trig = "delta",    tex = "\\delta" },
  { trig = "@e",       tex = "\\epsilon" },
  { trig = "epsilon",  tex = "\\epsilon" },
  { trig = "@z",       tex = "\\zeta" },
  { trig = "zeta",     tex = "\\zeta" },
  { trig = "@q",       tex = "\\theta" },
  { trig = "theta",    tex = "\\theta" },
  { trig = "@k",       tex = "\\kappa" },
  { trig = "kappa",    tex = "\\kappa" },
  { trig = "@l",       tex = "\\lambda" },
  { trig = "lambda",   tex = "\\lambda" },
  { trig = "@m",       tex = "\\mu" },
  { trig = "mu",       tex = "\\mu" },
  { trig = "@nu",      tex = "\\nu" },
  { trig = "nu",       tex = "\\nu" },
  { trig = "@na",      tex = "\\nabla" },
  { trig = "nabla",    tex = "\\nabla" },
  { trig = "@p",       tex = "\\pi" },
  { trig = "pi",       tex = "\\pi" },
  { trig = "@r",       tex = "\\rho" },
  { trig = "rho",      tex = "\\rho" },
  { trig = "@s",       tex = "\\sigma" },
  { trig = "sigma",    tex = "\\sigma" },
  { trig = "@t",       tex = "\\tau" },
  { trig = "tau",      tex = "\\tau" },
  { trig = "@f",       tex = "\\phi" },
  { trig = "phi",      tex = "\\phi" },
  { trig = "@w",       tex = "\\omega" },
  { trig = "omega",    tex = "\\omega" },

  -- Greek uppercase
  { trig = "@G",     tex = "\\Gamma" },
  { trig = "@D",     tex = "\\Delta" },
  { trig = "@T",     tex = "\\Theta" },
  { trig = "@L",     tex = "\\Lambda" },
  { trig = "@P",     tex = "\\Pi" },
  { trig = "@S",     tex = "\\Sigma" },
  { trig = "@PH",    tex = "\\Phi" },
  { trig = "@W",     tex = "\\Omega" },

  -- MATH SYMBOLS
  { trig = "*",      tex = "\\times" },
  -- { trig = ".",      tex = "\\cdot" },

  -- ARROWS
  { trig = "->",     tex = "\\rightarrow" },
  { trig = "<-",     tex = "\\leftarrow" },
  { trig = "<->",    tex = "\\leftrightarrow" },
  { trig = "=>",     tex = "\\Rightarrow" },
  { trig = "<=",     tex = "\\Leftarrow" },
  { trig = ">=",     tex = "\\Rightarrow" },
  { trig = "maps",   tex = "\\mapsto" },

  -- RELATIONS
  { trig = "~=",     tex = "\\approx" },
  { trig = "==",     tex = "\\equiv" },
  { trig = "!=",     tex = "\\neq" },
  { trig = "<=",     tex = "\\leq" },
  { trig = ">=",     tex = "\\geq" },
  { trig = "::",     tex = "\\propto" },
  { trig = "~~",     tex = "\\sim" },

  -- SETS
  { trig = "RR",     tex = "\\mathbb{R}" },
  { trig = "NN",     tex = "\\mathbb{N}" },
  { trig = "ZZ",     tex = "\\mathbb{Z}" },
  { trig = "QQ",     tex = "\\mathbb{Q}" },
  { trig = "CC",     tex = "\\mathbb{C}" },

  -- CALCULUS
  { trig = "pp",     tex = "\\partial" },
  { trig = "oo",     tex = "\\infty" },
  { trig = "SS",     tex = "\\int" },
  { trig = "iSS",    tex = "\\iint" },
  { trig = "oSS",    tex = "\\oint" },
  { trig = "empty",  tex = "\\emptyset" },
}
local snippets = {}
for _, entry in ipairs(symbols) do
  table.insert(snippets, s(
    { trig = entry.trig, snippetType = "autosnippet" }, -- Trigger anywhere!
    f(function()
      if M() then
        -- Inside math zone: just output the character
        return entry.tex
      else
        -- Outside math zone: wrap it in inline math
        return "$" .. entry.tex .. "$"
      end
    end)
  ))
end

local expr={
-- COMMON FUNCTIONS
  {trig="sin", snip={ t("\\sin("), i(1), t(")") }},
  {trig="cos", snip={ t("\\cos("), i(1), t(")") }},
  {trig="tan", snip={ t("\\tan("), i(1), t(")") }},
  {trig="cot", snip={ t("\\cot("), i(1), t(")") }},
  {trig="csc", snip={ t("\\csc("), i(1), t(")") }},
  {trig="sec", snip={ t("\\sec("), i(1), t(")") }},
  {trig="exp", snip={ t("\\exp("), i(1), t(")") }},
  {trig="log", snip={ t("\\log("), i(1), t(")") }},
  {trig="ln",  snip={ t("\\ln("), i(1), t(")") }},
  {trig="min", snip={ t("\\min("), i(1), t(")") }},
  {trig="max", snip={ t("\\max("), i(1), t(")") }},
  {trig="sin", snip={ t("\\sin("), i(1), t(")") }},

-- INTEGRALS WITH LIMITS
  {trig = "int",   snip={ t("int_{"), i(1), t("}^{"), i(2), t("} "), i(3) }},
  {trig = "iint",  snip={ t("\\iint_{"), i(1), t("}^{"), i(2), t("} "), i(3) }},
  {trig = "iiint", snip={ t("\\iiint_{"), i(1), t("}^{"), i(2), t("} "), i(3) }},
  {trig = "oint",  snip={ t("\\oint_{"), i(1), t("}^{"), i(2), t("} "), i(3) }},
  
  {trig="rot",snip={ t("\\nabla \\times \\vec{"), i(1), t("}") }},
  {trig="div",snip={ t("\\nabla \\cdot \\vec{"), i(1), t("}") }},
  {trig="grad",snip={ t("\\nabla "), i(1) }},

  {trig="bar",snip={ t("\\bar{"), i(1), t("}") }},
  -- HAT
  {trig="hat",snip={ t("\\hat{"), i(1), t("}") }},

-- TILDE
  {trig="til",snip={ t("\\tilde{"), i(1), t("}") }},

-- VECTOR
  {trig="vec",snip={ t("\\vec{"), i(1), t("}") }},

-- MATRIX
  {trig="((",snip={ t("\\left("), i(1), t("\\right)") }},


  {trig="[[",snip={ t("\\left["), i(1), t("\\right]") }},
  {trig="{{",snip={ t("\\left\\{"), i(1), t("\\right\\}") }},
  {trig="@(",snip={ t({"\\left(","\\begin{matrix}",""}), i(1), t({"","\\end{matrix}","\\right)"}) }},
  {trig="@[",snip={ t({"\\left[","\\begin{matrix}",""}), i(1), t({"","\\end{matrix}","\\right]"}) }},
  {trig="@{",snip={ t({"\\left\\{","\\begin{matrix}",""}), i(1), t({"","\\end{matrix}","\\right\\}"}) }},
  {trig="_",snip={ t("_{"), i(1), t("}") }},
  {trig="^",snip={ t("^{"), i(1), t("}") }},
  {trig = "bf",snip={ t("\\mathbf{"), i(1), t("}") }},
  {trig = "tt",snip={ t("\\text{"), i(1), t("}") }},
  {trig = "sqrt",snip={ t("\\sqrt{"), i(1), t("}") }},
  {trig = "fr",snip={ t("\\frac{"), i(1), t("}{"),i(2), t("}") }},
  {trig = "sum",snip={ t("\\sum_{"), i(1), t("}^{"),i(2), t("}") }},
  {trig = "prod",snip={ t("\\prod_{"), i(1), t("}^{"),i(2), t("}") }},
}

for _, entry in ipairs(expr) do
  table.insert(snippets, s(
    { trig = entry.trig, snippetType = "autosnippet", condition = M },
    entry.snip
  ))
end


local function dynamic_table(R, C)
  local nodes = {}
  local current_index = 1

  for r = 1, R do
      for c = 1, C do
          table.insert(nodes, ls.insert_node(current_index))
          current_index = current_index + 1

          if c < C then
              table.insert(nodes, t(" & "))
          end
      end

      if r < R then
          table.insert(nodes, t( {"\\\\",""}))
      end
  end
    return nodes
end

for R = 1, 10 do
    for C = 1, 10 do
        local trigger = R .. "x" .. C

        local new_snippet = s({trig = trigger,snippetType="autosnippet", condition=M, wordTrig=false, dscr = string.format("LaTeX %dx%d Table Body", R, C)},
            dynamic_table(R, C)
        )

        table.insert(snippets, new_snippet)
    end
end





local others ={

-------------------------------
--  FRACTION SMART SNIPPET
-------------------------------
-- expands "{x}/" → \frac{x}{•}
s(
  {
    trig = "(%b{})/",
    regTrig = true,
    wordTrig = false,
    snippetType = "autosnippet",
    condition = M,
  },

  {
    f(function(_, snip)
      local content = snip.captures[1]             -- "{expr}"
      local inner = content:sub(2, -2)             -- → expr
      return "\\frac{" .. inner .. "}{"
    end),
    i(1),
    t("}")
  }
),

-------------------------------
--  SINGLE LETTER VECTOR (Postfix)
-------------------------------
-- expands "Ev" → \vec{E} (cursor goes after '}')
s(
  {
    trig = "(%a)v",
    regTrig = true,
    wordTrig = false,
    snippetType = "autosnippet",
    condition = M,
  },
  f(function(_, snip)
    -- snip.captures[1] grabs the letter matched by (%a)
    return "\\vec{" .. snip.captures[1] .. "}"
  end)
),

-------------------------------
--  EXPRESSION VECTOR (Postfix)
-------------------------------
-- expands "{EX}v" → \vec{EX} (cursor goes after '}')
s(
  {
    trig = "(%b{})v",
    regTrig = true,
    wordTrig = false,
    snippetType = "autosnippet",
    condition = M,
  },
  f(function(_, snip)
    -- snip.captures[1] grabs the entirely matched bracket group, e.g., "{EX}"
    -- So we just prepend "\vec" to it.
    return "\\vec" .. snip.captures[1]
  end)
),

-------------------------------
--  DERIVATIVES (Postfix)
-------------------------------
-- 1. First Partial (Single Letter): "Ep" → \frac{\partial E}{\partial _}
s(
  { trig = "(%a)1p", regTrig = true, wordTrig = false, snippetType = "autosnippet", condition = M },
  {
    t("\\frac{\\partial "),
    f(function(_, snip) return snip.captures[1] end),
    t("}{\\partial "),
    i(1),
    t("}")
  }
),

-- 2. First Total (Single Letter): "Ed" → \frac{d E}{d _}
s(
  { trig = "(%a)1d", regTrig = true, wordTrig = false, snippetType = "autosnippet", condition = M },
  {
    t("\\frac{d "),
    f(function(_, snip) return snip.captures[1] end),
    t("}{d "),
    i(1),
    t("}")
  }
),

-- 3. Second Partial (Single Letter): "Ep2" → \frac{\partial^2 E}{\partial _^2}
s(
  { trig = "(%a)p2", regTrig = true, wordTrig = false, snippetType = "autosnippet", condition = M },
  {
    t("\\frac{\\partial^2 "),
    f(function(_, snip) return snip.captures[1] end),
    t("}{\\partial "),
    i(1),
    t("^2}")
  }
),

-- 4. Second Total (Single Letter): "Ed2" → \frac{d^2 E}{d _^2}
s(
  { trig = "(%a)d2", regTrig = true, wordTrig = false, snippetType = "autosnippet", condition = M },
  {
    t("\\frac{d^2 "),
    f(function(_, snip) return snip.captures[1] end),
    t("}{d "),
    i(1),
    t("^2}")
  }
),
-- 5. First Partial (Expression): "{EX}p" → \frac{\partial EX}{\partial _}
-------------------------------
--  COMMAND EXPRESSION DERIVATIVES (Postfix)
-------------------------------
-------------------------------
-------------------------------
--  EXPRESSION DERIVATIVES (Plain Brackets) - Priority 1000
-------------------------------
-- {F_x}1p → \frac{\partial F_x}{\partial _}
s(
  { trig = "(%b{})1p", priority = 1000, regTrig = true, wordTrig = false, snippetType = "autosnippet", condition = M },
  {
    t("\\frac{\\partial "),
    f(function(_, snip) return snip.captures[1]:sub(2, -2) end),
    t("}{\\partial "),
    i(1),
    t("}")
  }
),

-- {F_x}1d → \frac{d F_x}{d _}
s(
  { trig = "(%b{})1d", priority = 1000, regTrig = true, wordTrig = false, snippetType = "autosnippet", condition = M },
  {
    t("\\frac{d "),
    f(function(_, snip) return snip.captures[1]:sub(2, -2) end), 
    t("}{d "),
    i(1),
    t("}")
  }
),

-------------------------------
--  COMMAND DERIVATIVES (Backslash + Brackets) - Priority 2000
-------------------------------
-- \vec{B}1p → \frac{\partial \vec{B}}{\partial _}
s(
  { trig = "(\\%a+%b{})1p", priority = 2000, regTrig = true, wordTrig = false, snippetType = "autosnippet", condition = M },
  {
    t("\\frac{\\partial "),
    f(function(_, snip) return snip.captures[1] end),
    t("}{\\partial "),
    i(1),
    t("}")
  }
),

-- \mathbf{E}1d → \frac{d \mathbf{E}}{d _}
s(
  { trig = "(\\%a+%b{})1d", priority = 2000, regTrig = true, wordTrig = false, snippetType = "autosnippet", condition = M },
  {
    t("\\frac{d "),
    f(function(_, snip) return snip.captures[1] end),
    t("}{d "),
    i(1),
    t("}")
  }
),
-- BAR
--
--
-------------------------------
--  1D PGFPLOT (Trigger: plot)
-------------------------------
-- Generates a simple 1D axis environment taking a CSV file.
s(
  { trig = "plot", wordTrig = true },
  {
    t({
      "\\begin{tikzpicture}",
      "    \\begin{axis}[",
      "        title={",
    }),
    i(1, "Plot Title"),
    t({
      "},",
      "        xlabel={$x$},",
      "        ylabel={$y$},",
      "        grid=major,",
      "        width=10cm,",
      "        height=7cm,",
      "    ]",
      "        \\addplot[",
      "            color=blue,",
      "            mark=*,",
      "            thick",
      "        ] table [",
      "            col sep=comma,",
      "            x index=0, % First column (independent)",
      "            y index=1, % Second column (dependent)",
      "        ] {",
    }),
    i(2, "filename.csv"),
    t({
      "};",
      "    \\end{axis}",
      "\\end{tikzpicture}"
    })
  }
),

-------------------------------
--  2D HEATMAP (Solid Colormap)
-------------------------------
s(
  { trig = "heatmap", wordTrig = true },
  {
    t({
      "\\begin{tikzpicture}",
      "    \\begin{axis}[",
      "        title={",
    }),
    i(1, "Heatmap Title"),
    t({
      "},",
      "        view={0}{90},",
      "        colorbar,",
      "        xlabel={$x$},",
      "        ylabel={$y$},",
      "        enlargelimits=false,",
      "        axis on top, % CRITICAL: Keeps axis borders/ticks visible above the colors",
      "    ]",
      "        \\addplot3[",
      "            surf,",
      "            draw=none,   % CRITICAL: Removes the wireframe lines",
      "            shader=flat, % Use 'flat' for clear pixels, or 'interp' for smooth gradients",
      "        ] table [",
      "            col sep=comma,",
      "            x index=0,",
      "            y index=1,",
      "            z index=2,",
      "        ] {",
    }),
    i(2, "sinc_mesh.csv"),
    t({
      "};",
      "    \\end{axis}",
      "\\end{tikzpicture}"
    })
  }
),


-------------------------------
--  1D STEM PLOT
-------------------------------
s(
  { trig = "stem", wordTrig = true },
  {
    t({
      "\\begin{tikzpicture}",
      "    \\begin{axis}[",
      "        title={",
    }),
    i(1, "Stem Plot Title"),
    t({
      "},",
      "        xlabel={$x$},",
      "        ylabel={$y$},",
      "        grid=major,",
      "        width=10cm,",
      "        height=7cm,",
      "    ]",
      "        \\addplot[",
      "            ycomb, % This creates the stems",
      "            color=blue,",
      "            mark=*,",
      "            thick",
      "        ] table [",
      "            col sep=comma,",
      "            x index=0,",
      "            y index=1,",
      "        ] {",
    }),
    i(2, "filename.csv"),
    t({
      "};",
      "    \\end{axis}",
      "\\end{tikzpicture}"
    })
  }
),

-------------------------------
--  2D CONTOUR PLOT
-------------------------------
-- Note: Requires compiling with `lualatex --shell-escape` if using gnuplot.
s(
  { trig = "contour", wordTrig = true },
  {
    t({
      "\\begin{tikzpicture}",
      "    \\begin{axis}[",
      "        title={",
    }),
    i(1, "Contour Plot Title"),
    t({
      "},",
      "        view={0}{90},",
      "        xlabel={$x$},",
      "        ylabel={$y$},",
      "        colorbar,",
      "    ]",
      "        \\addplot3[",
      "            contour gnuplot={levels=10, labels=false},",
      "        ] table [",
      "            col sep=comma,",
      "            x index=0,",
      "            y index=1,",
      "            z index=2,",
      "        ] {",
    }),
    i(2, "filename.csv"),
    t({
      "};",
      "    \\end{axis}",
      "\\end{tikzpicture}"
    })
  }
),

-------------------------------
--  3D MESH PLOT
-------------------------------
s(
  { trig = "mesh3d", wordTrig = true },
  {
    t({
      "\\begin{tikzpicture}",
      "    \\begin{axis}[",
      "        title={",
    }),
    i(1, "3D Mesh Title"),
    t({
      "},",
      "        view={45}{45}, % Adjust viewing angle {azimuth}{elevation}",
      "        xlabel={$x$},",
      "        ylabel={$y$},",
      "        zlabel={$z$},",
      "        grid=major,",
      "    ]",
      "        \\addplot3[",
      "            mesh,",
      "            draw=blue,",
      "        ] table [",
      "            col sep=comma,",
      "            x index=0,",
      "            y index=1,",
      "            z index=2,",
      "        ] {",
    }),
    i(2, "filename.csv"),
    t({
      "};",
      "    \\end{axis}",
      "\\end{tikzpicture}"
    })
  }
),
}

for _,element in ipairs(others) do
  table.insert(snippets,element)
end

return snippets
