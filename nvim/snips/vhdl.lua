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
--  TYPES, DECLARATIONS & CONVERSIONS
-------------------------------
local quick_expr = {
    -- Types
    { trig = "sul",  snip = { t("std_ulogic") } },
    { trig = "std_ulogicv", snip = { t("std_ulogic_vector("), i(1), t(" downto "), i(2, "0"), t(")") } },
    { trig = "uns",  snip = { t("unsigned("), i(1), t(" downto "), i(2, "0"), t(")") } },
    { trig = "sig",  snip = { t("signal "), i(1, "name"), t(" : "), i(2, "std_ulogic"), t(";") } },
    { trig = "var",  snip = { t("variable "), i(1, "name"), t(" : "), i(2, "type"), t(" := "), i(3, "init"), t(";") } },
    { trig = "con",  snip = { t("constant "), i(1, "name"), t(" : "), i(2, "type"), t(" := "), i(3, "init"), t(";") } },
    
    -- Conversions (numeric_std & std_logic)
    { trig = "toi",  snip = { t("to_integer(unsigned("), i(1, "sig"), t("))") } },
    { trig = "tou",  snip = { t("to_unsigned("), i(1, "val"), t(", "), i(2, "len"), t(")") } },
    { trig = "tos",  snip = { t("to_signed("), i(1, "val"), t(", "), i(2, "len"), t(")") } },
    { trig = "2slv", snip = { t("std_logic_vector("), i(1, "sig"), t(")") } },
    { trig = "2sulv",snip = { t("std_ulogic_vector("), i(1, "sig"), t(")") } },

    -- Common keywords / shorthands
    { trig = "dt",   snip = { t("downto ") } },
    { trig = "oth",  snip = { t("(others => '"), i(1, "0"), t("')") } },
    { trig = "rie",   snip = { t("rising_edge("), i(1, "clk"), t(")") } },
    { trig = "fae",   snip = { t("falling_edge("), i(1, "clk"), t(")") } },
}

for _, entry in ipairs(quick_expr) do
    table.insert(snippets, s(
        { trig = entry.trig, snippetType = "autosnippet", wordTrig = true },
        entry.snip
    ))
end

-------------------------------
--  STRUCTURAL & GENERATOR BLOCKS
-------------------------------
local blocks = {

    -- Entity Declaration
    s("ent", fmt([[
        entity {} is
            port (
                {}
            );
        end entity {};
    ]], {
        i(1, "entity_name"),
        i(2, "clk : in std_ulogic;"),
        rep(1)
    })),

    -- Architecture Declaration
    s("arch", fmt([[
        architecture {} of {} is
            {}
        begin
            {}
        end architecture {};
    ]], {
        i(1, "rtl"),
        i(2, "entity_name"),
        i(3, "-- Declarations"),
        i(4, "-- Logic"),
        rep(1)
    })),

    -- Component Declaration
    s("comp", fmt([[
        component {} is
            port (
                {}
            );
        end component {};
    ]], {
        i(1, "component_name"),
        i(2, "clk : in std_ulogic;"),
        rep(1)
    })),

    -- Instantiation / Port Map
    s("inst", fmt([[
        {} : entity work.{}
            port map (
                {}
            );
    ]], {
        i(1, "inst_name"),
        i(2, "entity_name"),
        i(3, "clk => clk,")
    })),

-------------------------------
--  GENERATORS
-------------------------------

    -- For Generate
    s("forgen", fmt([[
        {} : for {} in {} to {} generate
            {}
        end generate {};
    ]], {
        i(1, "gen_label"),
        i(2, "i"),
        i(3, "0"),
        i(4, "N-1"),
        i(5, "-- generation logic"),
        rep(1)
    })),

    -- If Generate
    s("ifgen", fmt([[
        {} : if {} generate
            {}
        end generate {};
    ]], {
        i(1, "gen_label"),
        i(2, "condition"),
        i(3, "-- generation logic"),
        rep(1)
    })),


-------------------------------
--  PROCESSES & CONTROL FLOW
-------------------------------

    -- Synchronous Process (Clocked with Async Reset)
    s("procsync", fmt([[
        {} : process({}, {})
        begin
            if {} = '{}' then
                {}
            elsif rising_edge({}) then
                {}
            end if;
        end process {};
    ]], {
        i(1, "reg_proc"),          -- Label
        i(2, "clock"),             -- Clock signal
        i(3, "reset"),             -- Reset signal
        rep(3),                    -- Repeats reset signal for the 'if' condition
        i(4, "1"),                 -- Reset active level (1 or 0)
        i(5, "-- Reset logic"),
        rep(2),                    -- Repeats clock signal for the rising_edge check
        i(6, "-- Synchronous logic"),
        rep(1)                     -- Automatically repeats the label here!
    })),

    -- Combinatorial Process
    s("proccomb", fmt([[
        {} : process({})
        begin
            {}
        end process {};
    ]], {
        i(1, "comb_proc"),         -- Label
        i(2, "all"),               -- Sensitivity list
        i(3, "-- Combinatorial logic"),
        rep(1)                     -- Automatically repeats the label here!
    })),

    -- If / Else
    s("if", fmt([[
        if {} then
            {}
        end if;
    ]], {
        i(1, "condition"),
        i(2, "-- logic")
    })),

    s("ife", fmt([[
        if {} then
            {}
        else
            {}
        end if;
    ]], {
        i(1, "condition"),
        i(2, "-- logic"),
        i(3, "-- logic")
    })),

    -- Case Statement
    s("case", fmt([[
        case {} is
            when {} =>
                {}
            when others =>
                {}
        end case;
    ]], {
        i(1, "signal_name"),
        i(2, "state_1"),
        i(3, "-- logic"),
        i(4, "-- default logic")
    })),

-- IEEE Library Boilerplate (fmt version)
    s("ieee", fmt([[
        library IEEE;
        use IEEE.std_logic_1164.all;
        use IEEE.numeric_std.all;
        use work.all;
    ]], {})),

-------------------------------
--  GENERICS & PORTS
-------------------------------
    -- Generic Block
    s("gen", fmt([[
        generic (
            {}
        );
    ]], { 
        i(1, "-- generics") 
    })),

    -- Port Block
    s("port", fmt([[
        port (
            {}
        );
    ]], { 
        i(1, "-- ports") 
    })),

-------------------------------
--  PORT DECLARATIONS
-------------------------------
    -- In Vector (inv)
    s("inv", fmt("{} : in std_ulogic_vector({} downto {}){}", {
        i(1, "name"),
        i(2, "MSB"),
        i(3, "0"),
        c(4, { t(";"), t("") }) -- Choice node: semicolon or empty (for last item)
    })),

    -- Out Vector (outv)
    s("outv", fmt("{} : out std_ulogic_vector({} downto {}){}", {
        i(1, "name"),
        i(2, "MSB"),
        i(3, "0"),
        c(4, { t(";"), t("") })
    })),

    -- In Scalar (ins)
    s("ins", fmt("{} : in std_ulogic{}", {
        i(1, "name"),
        c(2, { t(";"), t("") })
    })),

    -- Out Scalar (outs)
    s("outs", fmt("{} : out std_ulogic{}", {
        i(1, "name"),
        c(2, { t(";"), t("") })
    })),
}

for _, element in ipairs(blocks) do
    table.insert(snippets, element)
end

return snippets
