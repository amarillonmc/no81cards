--pvz bt z 狂暴橄榄球巨尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,17,2,s.ovfilter,aux.Stringid(id,0),3,nil)
	c:EnableReviveLimit()
	Zombie_Characteristics_X(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(57300443) and c:IsDefenseBelow(1450)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
	end
end