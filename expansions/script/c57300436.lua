--pvz bt z 狂暴军团僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,6,2,s.ovfilter,aux.Stringid(id,0),3,nil)
	c:EnableReviveLimit()
	Zombie_Characteristics(c,500)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(57300433) and c:IsDefenseBelow(1000)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	end
end