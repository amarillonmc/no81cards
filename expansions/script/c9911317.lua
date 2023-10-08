--胧之渺翳 库柏勒魔
function c9911317.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911317)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c9911317.sptg)
	e1:SetOperation(c9911317.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9911318)
	e2:SetCondition(c9911317.setcon)
	e2:SetTarget(c9911317.settg)
	e2:SetOperation(c9911317.setop)
	c:RegisterEffect(e2)
end
function c9911317.spfilter(c,e,tp)
	local b1=c:IsLocation(LOCATION_HAND)
	local b2=c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER>0 and c:GetSequence()<5
	return (b1 or b2) and c:IsSetCard(0xa958) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911317.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911317.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_SZONE)
end
function c9911317.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911317.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9911317.setcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9911317.setfilter(c)
	return c:IsSetCard(0xa958) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9911317.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsReleasableByEffect()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911317.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and (b1 or b2) end
end
function c9911317.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911317.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g==0 or Duel.SSet(tp,g:GetFirst())==0 then return end
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
			e1:SetValue(c9911317.eqlimit)
			e1:SetLabelObject(tc)
			c:RegisterEffect(e1)
			--atk&def down
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(-1000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e3)
		end
	end
end
function c9911317.eqlimit(e,c)
	return c==e:GetLabelObject()
end
