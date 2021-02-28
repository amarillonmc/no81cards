--JUBILANT-PORO
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16101178,"PORO")
function cm.initial_effect(c)
	--changecode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con)
	e1:SetValue(m+1)
	c:RegisterEffect(e1) 
end
function cm.filter(c)
	return rk.check(c,"PORO") and c:IsFaceup()
end
function cm.con(e,tp)
	return not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end