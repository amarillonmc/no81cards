-- 雷姆
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSynchroMixProcedure(c,aux.Tuner(Card.IsCode,17337409),nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x3f50),1,99)
	c:EnableReviveLimit()
	aux.AddCodeList(c,17337400,17337409,17337435) 

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER) 
	e3:SetValue(s.atkct)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetValue(s.pierceval)
	c:RegisterEffect(e4)
end

function s.knfilter(c)
	return c:IsCode(17337400) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.atkval(e,c)
	local ct=Duel.GetMatchingGroupCount(s.knfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return ct*300
end
function s.atkct(e,c)
	local ct=Duel.GetMatchingGroupCount(s.knfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return math.max(0,ct-1)
end
function s.pierceval(e,c)
	local tp=e:GetHandlerPlayer()
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,17337435) then
		return DOUBLE_DAMAGE
	else
		return 0
	end
end