local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

ls.config.set_config({
    enable_autosnippets = true,
})

local snippets = {}

-------------------------------
--  COMMON SETTINGS & LABELS
-------------------------------
local quick_cmd = {
    -- Labels (Autosnippets)
    { trig = "sx",  snip = { t("set xlabel '"), i(1, "x"), t("'") } },
    { trig = "sy",  snip = { t("set ylabel '"), i(1, "y"), t("'") } },
    { trig = "sz",  snip = { t("set zlabel '"), i(1, "z"), t("'") } },
    { trig = "st",  snip = { t("set title '"), i(1, "Title"), t("'") } },
    
    -- Ranges & Grid
    { trig = "srx", snip = { t("set xrange ["), i(1, "*"), t(":"), i(2, "*"), t("]") } },
    { trig = "sry", snip = { t("set yrange ["), i(1, "*"), t(":"), i(2, "*"), t("]") } },
    { trig = "srz", snip = { t("set zrange ["), i(1, "*"), t(":"), i(2, "*"), t("]") } },
    { trig = "sgrid", snip = { t("set grid") } },
    
    -- Legend/Key
    { trig = "skey", snip = { t("set key "), c(1, { t("outside"), t("top right"), t("bottom left") }) } },
    { trig = "ukey", snip = { t("unset key") } },
}

for _, entry in ipairs(quick_cmd) do
    table.insert(snippets, s(
        { trig = entry.trig, snippetType = "autosnippet", wordTrig = true },
        entry.snip
    ))
end

-------------------------------
--  TERMINALS & PLOTTING BLOCKS
-------------------------------
local blocks = {

    -- CairoLaTeX Standalone Terminal Setup
    s("termcairo", fmt([[
        set terminal cairolatex pdf standalone color size 6in, 4in
        set output '{}.tex'

        {}

        unset output
    ]], {
        i(1, "filename"),
        i(2, "# plot commands")
    })),

    -- Standard PDF Terminal
    s("termpdf", fmt([[
        set terminal pdfcairo enhanced color size 6in, 4in
        set output '{}.pdf'

        {}

        unset output
    ]], {
        i(1, "filename"),
        i(2, "# plot commands")
    })),

    -- Basic Function Plot
    s("plotf", fmt([[
        plot {} title '{}' with {}
    ]], {
        i(1, "sin(x)"),
        i(2, "Legend"),
        c(3, { t("lines"), t("linespoints"), t("points") })
    })),

    -- Plot from Datafile
    s("plotd", fmt([[
        plot '{}' using {}:{} title '{}' with {}
    ]], {
        i(1, "data.csv"),
        i(2, "1"),
        i(3, "2"),
        i(4, "Legend"),
        c(5, { t("lines"), t("linespoints"), t("points") })
    })),

    -- 3D Surface Plot from Datafile
    s("splotd", fmt([[
        splot '{}' using {}:{}:{} title '{}' with {}
    ]], {
        i(1, "data.csv"),
        i(2, "1"),
        i(3, "2"),
        i(4, "3"),
        i(5, "Legend"),
        c(6, { t("lines"), t("pm3d") })
    })),
    
    -- Multiplot Environment
    s("multi", fmt([[
        set multiplot layout {}, {} title '{}'
        
        {}
        
        unset multiplot
    ]], {
        i(1, "2"),
        i(2, "1"),
        i(3, "Multiplot Title"),
        i(4, "# add plots here")
    })),
}

for _, element in ipairs(blocks) do
    table.insert(snippets, element)
end

return snippets
