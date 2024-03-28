--超能力传音
local s,id,o=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.prop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.prop2)
	c:RegisterEffect(e2)
end

function s.filter0(c)
	return c:IsSetCard(0x603) and c:IsAbleToRemove()
end
function s.filter01(c)
	return c:IsSetCard(0x603) and c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
			and Duel.GetMatchingGroupCount(s.filter01,tp,LOCATION_REMOVED,0,nil)>=3
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
		Duel.SendtoGrave(g2,REASON_EFFECT+REASON_RETURN)
	end
end

function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x603) and re:GetHandler():IsType(TYPE_MONSTER) and bit.band(r,REASON_EFFECT)>0
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,6))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	else
		e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	end
	Duel.RegisterEffect(e2,tp)
end
function s.filter22(c)
	return c:IsSetCard(0x603) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(s.filter22,tp,LOCATION_DECK,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local result = Duel.SelectYesNo(tp,aux.Stringid(id,5))
	if not result then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,s.filter22,tp,LOCATION_DECK,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoGrave(g2,REASON_EFFECT)
	end
end