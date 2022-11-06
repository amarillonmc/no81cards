function c10105580.initial_effect(c)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105580,0))	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10105580)
	e1:SetCost(c10105580.spcost)
	e1:SetTarget(c10105580.sptg)
	e1:SetOperation(c10105580.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c10105580.spreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105580,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_PHASE+PHASE_DRAW)
	e3:SetCountLimit(1,10105580)
	e3:SetCondition(c10105580.spcon)
	e3:SetTarget(c10105580.sptg2)
	e3:SetOperation(c10105580.spop2)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10105580,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c10105580.tg)
	e4:SetOperation(c10105580.op)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c10105580.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(10) and c:IsAbleToRemoveAsCost()
end
function c10105580.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10105580.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,c) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c10105580.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10105580.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10105580.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c10105580.spreg(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(Duel.GetTurnCount())
	e:GetHandler():RegisterFlagEffect(10105580,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
end
function c10105580.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and c:GetFlagEffect(10105580)>0
end
function c10105580.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:ResetFlagEffect(10105580)
end
function c10105580.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c10105580.filter(c)
	return c:IsSetCard(0x7cca) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10105580.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105580.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105580.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c10105580.filter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end