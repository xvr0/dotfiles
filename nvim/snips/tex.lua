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
  { trig = "@a",      tex = "\\alpha " },
  { trig = "alpha",      tex = "\\alpha " },
  { trig = "@b",       tex = "\\beta " },
  { trig = "beta",       tex = "\\beta " },
  { trig = "@g",      tex = "\\gamma " },
  { trig = "gamma",      tex = "\\gamma " },
  { trig = "@d",      tex = "\\delta " },
  { trig = "delta",      tex = "\\delta " },
  { trig = "@e",    tex = "\\epsilon " },
  { trig = "epsilon",    tex = "\\epsilon " },
  { trig = "@ve", tex = "\\varepsilon " },
  { trig = "varepsilon", tex = "\\varepsilon " },
  { trig = "@z",       tex = "\\zeta " },
  { trig = "zeta",       tex = "\\zeta " },
--  { trig = "@e",        tex = "\\eta " },
  { trig = "@q",      tex = "\\theta " },
  { trig = "theta",      tex = "\\theta " },
  { trig = "@vte",   tex = "\\vartheta " },
  { trig = "vartheta",   tex = "\\vartheta " },
  { trig = "@i",       tex = "\\iota " },
  { trig = "iota",       tex = "\\iota " },
  { trig = "@k",      tex = "\\kappa " },
  { trig = "kappa",      tex = "\\kappa " },
  { trig = "@vk",   tex = "\\varkappa " },
  { trig = "varkappa",   tex = "\\varkappa " },
  { trig = "@l",     tex = "\\lambda " },
  { trig = "lambda",     tex = "\\lambda " },
  { trig = "@m",         tex = "\\mu " },
  { trig = "mu",         tex = "\\mu " },
  { trig = "@nu",         tex = "\\nu " },
  { trig = "nu",         tex = "\\nu " },
  { trig = "@na",         tex = "\\nabla " },
  { trig = "nabla",         tex = "\\nabla " },
  { trig = "@x",         tex = "\\xi " },
  { trig = "xi",         tex = "\\xi " },
  { trig = "@p",         tex = "\\pi " },
  { trig = "pi",         tex = "\\pi " },
  { trig = "@vp",      tex = "\\varpi " },
  { trig = "varpi",      tex = "\\varpi " },
  { trig = "@r",        tex = "\\rho " },
  { trig = "rho",        tex = "\\rho " },
  { trig = "@vr",     tex = "\\varrho " },
  { trig = "varrho",     tex = "\\varrho " },
  { trig = "@s",      tex = "\\sigma " },
  { trig = "sigma",      tex = "\\sigma " },
  { trig = "@vs",   tex = "\\varsigma " },
  { trig = "varsigma",   tex = "\\varsigma " },
  { trig = "@t",        tex = "\\tau " },
  { trig = "tau",        tex = "\\tau " },
  { trig = "@u",    tex = "\\upsilon " },
  { trig = "upsilon",    tex = "\\upsilon " },
  { trig = "@f",        tex = "\\phi " },
  { trig = "phi",        tex = "\\phi " },
  { trig = "@vf",     tex = "\\varphi " },
  { trig = "varphi",     tex = "\\varphi " },
  { trig = "@c",        tex = "\\chi " },
  { trig = "chi",        tex = "\\chi " },
  { trig = "@ps",        tex = "\\psi " },
  { trig = "psi",        tex = "\\psi " },
  { trig = "@w",      tex = "\\omega " },
  { trig = "omega",      tex = "\\omega " },

  -- Greek uppercase (all plain roman)
  { trig = "@G",    tex = "\\Gamma " },
  { trig = "Gamma",    tex = "\\Gamma " },
  { trig = "@D",    tex = "\\Delta " },
  { trig = "Delta",    tex = "\\Delta " },
  { trig = "@T",    tex = "\\Theta " },
  { trig = "Theta",    tex = "\\Theta " },
  { trig = "@L",   tex = "\\Lambda " },
  { trig = "Lambda",   tex = "\\Lambda " },
  { trig = "@X",       tex = "\\Xi " },
  { trig = "Xi",       tex = "\\Xi " },
  { trig = "@P",       tex = "\\Pi " },
  { trig = "Pi",       tex = "\\Pi " },
  { trig = "@S",    tex = "\\Sigma " },
  { trig = "Sigma",    tex = "\\Sigma " },
  { trig = "@U",  tex = "\\Upsilon " },
  { trig = "Upsilon",  tex = "\\Upsilon " },
  { trig = "@PH",      tex = "\\Phi " },
  { trig = "Phi",      tex = "\\Phi " },
  { trig = "@PS",      tex = "\\Psi " },
  { trig = "Psi",      tex = "\\Psi " },
  { trig = "@W",    tex = "\\Omega " },
  { trig = "Omega",    tex = "\\Omega " },

  
  {trig = "*",tex="\\times "},
  {trig = ".",tex="\\cdot "},
-------------------------------
--  BASIC ARROWS
-------------------------------
  {trig = "->",tex="\\rightarrow "},
  {trig = "<-",tex="\\leftarrow "},
  {trig = "<->",tex="\\Leftrightarrow "},
  {trig = "=>",tex="\\implies "},
  {trig = "<=",tex="\\Leftarrow "},
  {trig = ">=",tex="\\Rightarrow "},
  {trig = "iff",tex="\\iff "},
  {trig = "maps",tex="\\mapsto "},

-------------------------------
--  RELATIONAL OPERATORS
-------------------------------
  {trig="~=",tex="\\approx "},
  {trig="approx",tex="\\approx "},
  {trig="==",tex="\\equiv "},
  {trig="equiv",tex="\\equiv "},
  {trig="!=",tex="\\neq "},
  {trig="neq",tex="\\neq "},
  {trig="<=",tex="\\leq "},
  {trig="leq",tex="\\leq "},
  {trig=">=",tex="\\geq "},
  {trig="geq",tex="\\geq "},
  {trig="::",tex="\\propto "},
  {trig="propto",tex="\\propto "},
  {trig="~~",tex="\\sim "},
  {trig="sim",tex="\\sim "},
  {trig=":=",tex="\\coloneqq "},
  {trig="coloneqq",tex="\\coloneqq "},
  {trig="=:",tex="\\eqqcolon "},
  {trig="eqqcolon",tex="\\eqqcolon "},

-------------------------------
--  SETS
-------------------------------
  {trig="RR",tex="\\mathbb{R} "},
  {trig="NN",tex="\\mathbb{N} "},
  {trig="ZZ",tex="\\mathbb{Z} "},
  {trig="QQ",tex="\\mathbb{Q} "},
  {trig="CC",tex="\\mathbb{C} "},
  {trig="PP",tex="\\mathbb{P} "},
  {trig="EE",tex="\\mathbb{E} "},
  {trig="VV",tex="\\mathbb{V} "},



  {trig="Re",tex="\\Re "},
  {trig="Im",tex="\\Im "},
  {trig="inf",tex="infty "},
-------------------------------
--  LOGICAL SYMBOLS
-------------------------------
  {trig="tf",tex="\\therefore "},
  {trig="bc",tex="\\because "},
  {trig="and",tex="\\land "},
  {trig="or",tex="\\lor "},
  {trig="!>",tex="\\not\\Rightarrow "},
  {trig="neg",tex="\\neg "},

-------------------------------
--  SPACING
-------------------------------
  {trig="  ",tex="\\quad "},
  {trig="\\quad  ",tex="\\qquad "},
  {trig=";",tex="\\; "},
  {trig=",",tex="\\, "},
  {trig="..",tex="\\dots "},
-------------------------------
--  CALCULUS
-------------------------------
  {trig="dd",tex="\\,d "},
  {trig="pp",tex="\\partial "},
  {trig="oo",tex="\\infty "},
  {trig="SS",tex="\\int "},
  {trig="iSS",tex="\\iint "},
  {trig="iiSS",tex="\\iiint "},
  {trig="oSS",tex="\\oint "},

-------------------------------
--  OPERATORS
-------------------------------
  {trig="lim",tex="\\lim "},
  {trig="argmax",tex="\\argmax "},
  {trig="argmin",tex="\\argmin "},
  {trig="sup",tex="\\sup "},
  {trig="inf",tex="\\inf "},
  {trig="ker",tex="\\ker "},
  {trig="span",tex="\\operatorname{span} "},
  {trig="rank",tex="\\operatorname{rank} "},

-------------------------------
--  SET/LOGIC RELATIONS
-------------------------------
  {trig="sub",tex="\\subseteq "},
  {trig="sump",tex="\\supseteq "},
  {trig="in",tex="\\in"},
  {trig="nin",tex="\\notin "},
  {trig="empty",tex="\\emptyset "},

}
local snippets = {}
for _, entry in ipairs(symbols) do
  table.insert(snippets, s(
    { trig = entry.trig, snippetType = "autosnippet", condition = M },
    t(entry.tex)
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
}

for _,element in ipairs(others) do
  table.insert(snippets,element)
end

return snippets
