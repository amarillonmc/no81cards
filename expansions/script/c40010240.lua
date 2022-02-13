--伐楼利拿·希望概像
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40010240)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1 = rsef.SV_Card(c,"atkex",cm.val,"sr",LOCATION_MZONE)





   --cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(cm.accon)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)



end
function cm.rsfwh_ex_ritual(c)
	return ((c:IsSetCard(0x6f1b) or c:IsSetCard(0xcf1b)) and c:GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF )
end
function cm.val(e,c)
	return c:GetOverlayCount()
end 
function cm.accon(e,tp)
	return e:GetHandler():GetFlagEffect(m) > 0
end
function cm.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return not loc==LOCATION_ONFIELD 
end
