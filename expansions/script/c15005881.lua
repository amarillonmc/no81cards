local m=15005881
local cm=_G["c"..m]
cm.name="狂音主的魔杖·因波斯"
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.sp2con)
	e2:SetTarget(cm.sp2tg)
	e2:SetOperation(cm.sp2op)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,e,tp,b1,b2)
	return c:IsSetCard(0x6f43) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
		and (b1 and c:IsAbleToGrave() or b2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsAbleToGrave()
	if chk==0 then
		if c:IsPublic() then return false end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if not b1 and not b2 then return false end
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,c,e,tp,b1,b2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,c,e,tp,b1,b2)
	local tc=g:GetFirst()
	Duel.SetTargetCard(tc)
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function cm.checkfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local mg=Group.FromCards(c,tc)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=mg:FilterSelect(tp,cm.checkfilter,1,1,nil,e,tp)
		if #sg==0 then return end
		mg:RemoveCard(sg:GetFirst())
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		Duel.SendtoGrave(mg,REASON_EFFECT)
	end
end
function cm.disfilter(c)
	return c:IsFaceup() and c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function cm.sp2con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local p=Duel.GetTurnPlayer()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and p==1-tp
		and Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end