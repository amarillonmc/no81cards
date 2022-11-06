function c10105583.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105583,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10105583)
	e1:SetCost(c10105583.spcost)
	e1:SetTarget(c10105583.sptg)
	e1:SetOperation(c10105583.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c10105583.spreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105583,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetCountLimit(1,10105583)
	e3:SetCondition(c10105583.spcon)
	e3:SetTarget(c10105583.sptg2)
	e3:SetOperation(c10105583.spop2)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c10105583.rmtg)
	e4:SetOperation(c10105583.rmop)
	c:RegisterEffect(e4)
end
function c10105583.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(10) and c:IsAbleToRemoveAsCost()
end
function c10105583.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10105583.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,c) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c10105583.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10105583.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10105583.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c10105583.spreg(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(Duel.GetTurnCount())
	e:GetHandler():RegisterFlagEffect(10105583,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
end
function c10105583.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and c:GetFlagEffect(10105583)>0
end
function c10105583.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:ResetFlagEffect(10105583)
end
function c10105583.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c10105583.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,2,2,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
end
function c10105583.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end