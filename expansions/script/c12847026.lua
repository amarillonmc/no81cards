--沉默之星
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e4:SetTargetRange(1,1)
	e4:SetTarget(s.costtg)
	e4:SetCost(s.costchk)
	e4:SetOperation(s.costop)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function s.handcon(e)
	return Duel.GetCurrentPhase()==PHASE_STANDBY
end
function s.costtg(e,te,tp)
	e:SetLabelObject(te:GetHandler())
	return true
end
function s.costchk(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	local typ=tc:GetType()&0x7
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,tc,typ)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local ctype=0
	local tc=e:GetLabelObject()
	local typ=tc:GetType()&0x7
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,tc,typ)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
end