local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and not Duel.CheckPhaseActivity()
end
function s.filter(c)
	return c:GetType()&0x20002==0x20002 and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,g) end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTarget(s.splimit)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.con)
	e3:SetOperation(s.op)
	e3:SetLabelObject(e2)
	Duel.RegisterEffect(e3,tp)
	if not c:IsRelateToEffect(e) or not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	c:CancelToGrave()
	if c:IsAbleToDeck() and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then Duel.SendtoDeck(c,nil,2,REASON_EFFECT) else c:CancelToGrave(false) end
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_FUSION)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():GetLabelObject():Reset()
	e:GetLabelObject():Reset()
	e:Reset()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rs=1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(Duel.GetTurnCount())
		rs=2
	else e1:SetLabel(0) end
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,rs)
	Duel.RegisterEffect(e1,tp)
	if not c:IsRelateToEffect(e) then return end
	Duel.BreakEffect()
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
end
function s.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
