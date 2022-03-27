--音速的水将 尼克塔里奥
function c33200728.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c33200728.lcheck)
	c:EnableReviveLimit()
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200728,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,33200728)
	e1:SetTarget(c33200728.sptg)
	e1:SetOperation(c33200728.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200728,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,33200729)
	e2:SetTarget(c33200728.rmtg)
	e2:SetOperation(c33200728.rmop)
	c:RegisterEffect(e2)
end
function c33200728.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xc32a)
end

--e1
function c33200728.spfilter(c,e,tp)
	return c:IsSetCard(0xc32a) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33200728.rmfilter(c)
	return c:IsSetCard(0xc32a) and c:IsAbleToRemove()
end
function c33200728.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c33200728.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33200728.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33200728.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33200728.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c33200728.rmfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33200728,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=Duel.SelectMatchingCard(tp,c33200728.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			local rmtc=sg:GetFirst()
			Duel.Remove(rmtc,POS_FACEUP,REASON_EFFECT)
		end
	end
end

--e2
function c33200728.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x32a,2)
end
function c33200728.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c33200728.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200728.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,c33200728.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x32a)
end
function c33200728.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x32a,2)
	end
end