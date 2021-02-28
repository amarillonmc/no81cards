--PLUCKY-PORO
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16101181,"PORO")
function cm.initial_effect(c)
   --imm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.imtg)
	e1:SetValue(cm.imval)
	c:RegisterEffect(e1)
end
function cm.imtg(e,c)
	return rk.check(c,"PORO") and c:IsFaceup()
end
function cm.imval(e,re)
	return re:IsActiveType(TYPE_SPELL)
end