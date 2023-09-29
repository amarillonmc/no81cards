local m=53735003
local cm=_G["c"..m]
cm.name=""
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.GCSpiritN(c)
end
