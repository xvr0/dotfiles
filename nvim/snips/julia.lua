local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

ls.config.set_config({
    enable_autosnippets = true,
})

local autosnippets = {}

-- ==========================================
-- GREEK LETTERS
-- ==========================================
local greek_chars = {
    a = "α", b = "β", g = "γ", d = "δ", e = "ε", z = "ζ", h = "η", q = "θ",
    i = "ι", k = "κ", l = "λ", m = "μ", n = "ν", x = "ξ", p = "π", r = "ρ",
    s = "σ", t = "τ", u = "υ", f = "φ", c = "χ", y = "ψ", w = "ω",
    A = "Α", B = "Β", G = "Γ", D = "Δ", E = "Ε", Z = "Ζ", H = "Η", Q = "Θ",
    I = "Ι", K = "Κ", L = "Λ", M = "Μ", N = "Ν", X = "Ξ", P = "Π", R = "Ρ",
    S = "Σ", T = "Τ", U = "Υ", F = "Φ", C = "Χ", Y = "Ψ", W = "Ω"
}

for trig_char, greek_letter in pairs(greek_chars) do
    table.insert(autosnippets, s({
        trig = "@" .. trig_char .. " ",
        snippetType = "autosnippet",
        wordTrig = false -- Allows triggering even if attached to other characters
    }, {
        t(greek_letter)
    }))
end

-- ==========================================
-- DIACRITICS (Combining Unicode Marks)
-- ==========================================
-- ==========================================
-- DIACRITICS (Combining Unicode Marks)
-- ==========================================
-- local diacritics = {
--     ["d"]   = vim.fn.nr2char(0x0307), -- dot above
--     ["dd"]  = vim.fn.nr2char(0x0308), -- double dot above
--     ["ddd"] = vim.fn.nr2char(0x20DB), -- triple dot above
--     ["h"]   = vim.fn.nr2char(0x0302), -- circumflex (hat)
--     ["l"]   = vim.fn.nr2char(0x0304), -- macron (overline)
-- }
--
-- for trig_suffix, mark in pairs(diacritics) do
--     table.insert(autosnippets, s({
--         -- Regex: Captures any non-whitespace character before '@', followed by the suffix and a space
--         trig = "([^%s])@" .. trig_suffix .. " ",
--         regTrig = true,
--         wordTrig = false,
--         snippetType = "autosnippet"
--     }, {
--         f(function(_, snip)
--             -- snip.captures[1] contains the character typed right before the '@'
--             return snip.captures[1] .. mark
--         end)
--     }))
-- end

-- Load the snippets globally (or change "all" to "julia", "python", etc.)
ls.add_snippets("all", autosnippets)
