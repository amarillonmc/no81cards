--欲望硬币核心体·鹰眼
function c9980801.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabc1),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980801,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9980801)
	e2:SetCondition(c9980801.spcon)
	e2:SetTarget(c9980801.sptg)
	e2:SetOperation(c9980801.spop)
	c:RegisterEffect(e2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980801,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99808011)
	e1:SetCondition(c9980801.spcon2)
	e1:SetCost(c9980801.spcost)
	e1:SetTarget(c9980801.sptg2)
	e1:SetOperation(c9980801.spop2)
	c:RegisterEffect(e1)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980801,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCountLimit(1,99808010)
	e4:SetCondition(c9980801.thcon)
	e4:SetTarget(c9980801.thtg)
	e4:SetOperation(c9980801.thop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980801.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980801.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980801,2))
end
function c9980801.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xabc1) and c:IsType(TYPE_FUSION)
end
function c9980801.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9980801.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9980801.spfilter(c,e,tp)
	return c:IsCode(9980777) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980801.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c9980801.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9980801.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9980801.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9980801.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9980801.filter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c9980801.spcon2(e,c)
	return not Duel.IsExistingMatchingCard(c9980801.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler())
end
function c9980801.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9980801.spfilter2(c,e,tp)
	return c:IsCode(9980790) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9980801.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c9980801.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9980801.spop2(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.IsExistingMatchingCard(c9980801.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9980801.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9980801.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9980801.splimit(e,c)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function c9980801.thcon(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and rc:IsSetCard(0xabc1)  and r&REASON_FUSION+REASON_LINK~=0
end
function c9980801.thfilter(c,tp)
	return c:IsCode(9980775) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c9980801.tgfilter,tp,LOCATION_DECK,0,1,c)
end
function c9980801.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xbca)and c:IsAbleToGrave()
end
function c9980801.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980801.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9980801.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,c9980801.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if hg:GetCount()>0 and Duel.SendtoHand(hg,tp,REASON_EFFECT)>0
		and hg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9980801.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
