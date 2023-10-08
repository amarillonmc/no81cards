--胧之渺翳 匈牙利魔
function c9911314.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,9911314)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c9911314.thtg)
	e1:SetOperation(c9911314.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9911315)
	e3:SetCondition(c9911314.spcon)
	e3:SetTarget(c9911314.sptg)
	e3:SetOperation(c9911314.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(9911314,ACTIVITY_CHAIN,c9911314.chainfilter)
end
function c9911314.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_GRAVE)
end
function c9911314.thfilter(c)
	return c:IsSetCard(0xa958) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9911314.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911314.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911314.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911314.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g~=0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9911314.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(9911314,tp,ACTIVITY_CHAIN)>0 or Duel.GetCustomActivityCount(9911314,1-tp,ACTIVITY_CHAIN)>0
end
function c9911314.spfilter(c,e,tp)
	return c:IsSetCard(0xa958) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9911314.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local b1=c:IsReleasableByEffect()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9911314.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9911314.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and (b1 or b2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9911314.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9911314.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)==0 then return end
	if not c:IsRelateToEffect(e) then return end
	local b1=c:IsReleasableByEffect()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup()
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
	if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(9911301,2),aux.Stringid(9911301,3))==0) then
		Duel.BreakEffect()
		Duel.Release(c,REASON_EFFECT)
	elseif b2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
		local tc=sg:GetFirst()
		if tc and Duel.Equip(tp,c,tc) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c9911314.eqlimit)
			e1:SetLabelObject(tc)
			c:RegisterEffect(e1)
			--defup
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(1500)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	end
end
function c9911314.eqlimit(e,c)
	return c==e:GetLabelObject()
end
