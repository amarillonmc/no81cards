--SINISTER-PORO
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16101183,"PORO")
function cm.initial_effect(c)
	--change race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetRange(0x7f)
	e1:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e1) 
end
