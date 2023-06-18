--伐楼利拿·希望概像
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40010240,"Vairina")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(cm.spcost)
	c:RegisterEffect(e0)
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
function cm.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsLevel(12)
end
function cm.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_RITUAL)~=SUMMON_TYPE_RITUAL then return true end
	return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.rsfwh_ex_ritual(c)
	return c:CheckSetCard("Vairina","BlazeMaiden") and c:GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF 
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
