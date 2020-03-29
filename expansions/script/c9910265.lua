--幽鬼派对
function c9910265.initial_effect(c)
	c:EnableCounterPermit(0x953)
	c:SetCounterLimit(0x953,6)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910265+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9910265.activate)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9910265.sumlimit)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910265.spcon)
	e3:SetCost(c9910265.spcost)
	e3:SetTarget(c9910265.sptg)
	e3:SetOperation(c9910265.spop)
	c:RegisterEffect(e3)
end
function c9910265.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x953)
end
function c9910265.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c9910265.cfilter,tp,LOCATION_GRAVE,0,nil)
	if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(9910265,0)) then
		e:GetHandler():AddCounter(0x953,ct,true)
	end
end
function c9910265.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end
function c9910265.cfilter2(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetPreviousControler()==tp and c:IsSetCard(0x953)
end
function c9910265.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910265.cfilter2,1,nil,tp)
end
function c9910265.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x953,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x953,2,REASON_COST)
end
function c9910265.spfilter(c,e,tp)
	return c:IsSetCard(0x953) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910265.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910265.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9910265.tgfilter(c)
	return c:IsSetCard(0x953) and c:IsAbleToGrave()
end
function c9910265.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910265.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.IsExistingMatchingCard(c9910265.tgfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9910265,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=Duel.SelectMatchingCard(tp,c9910265.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if tg:GetCount()>0 then
				Duel.SendtoGrave(tg,REASON_EFFECT)
			end
		end
	end
end
