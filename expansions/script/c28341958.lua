--羁绊的一等星 完美三角形
function c28341958.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,28341958+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c28341958.target)
	e1:SetOperation(c28341958.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c28341958.reptg)
	e2:SetValue(c28341958.repval)
	c:RegisterEffect(e2)
	--illumination SetCode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetValue(0x283)
	c:RegisterEffect(e3)
end
function c28341958.tfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x284) and c:IsLevelAbove(1)
		and Duel.IsExistingMatchingCard(c28341958.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c28341958.spfilter(c,e,tp,tc)
	return not c:IsAttribute(tc:GetAttribute()) and c:GetOriginalLevel()==tc:GetOriginalLevel()
		and c:IsSetCard(0x284) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28341958.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c28341958.tfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c28341958.tfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c28341958.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c28341958.cfilter(c,attr)
	return c:IsLevelAbove(1) and c:IsFaceup() and c:IsAttribute(attr)
end
function c28341958.tgfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToGrave()
end
function c28341958.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() and Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c28341958.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
	if sg:GetCount()==0 or Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.IsExistingMatchingCard(c28341958.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(c28341958.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(c28341958.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_FIRE) and Duel.IsExistingMatchingCard(c28341958.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28341958,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c28341958.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c28341958.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x284) and eg:IsContains(c) and (c:IsAbleToHand() or (re:GetHandler():IsFaceupEx() and (re:GetHandler():IsLevelAbove(1) or re:GetHandler():IsRankAbove(1)))) end
	if c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(28341958,0)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_DECK_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_HAND)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		--c:RegisterFlagEffect(28341958,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_TO_HAND)
		e2:SetCountLimit(1)
		e2:SetOperation(c28341958.chkop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOHAND+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		return true
	else
		local rc=re:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		rc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RANK)
		rc:RegisterEffect(e2)
	return false end
end
function c28341958.repval(e,c)
	return false
end
function c28341958.chkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.ShuffleHand(tp)
end
