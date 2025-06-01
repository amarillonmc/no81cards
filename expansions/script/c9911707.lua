--剑域修武士 红莲
function c9911707.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,9911707)
	e1:SetCondition(c9911707.spcon)
	e1:SetCost(c9911707.spcost)
	e1:SetTarget(c9911707.sptg)
	e1:SetOperation(c9911707.spop)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9911708)
	e2:SetCost(c9911707.hdcost)
	e2:SetTarget(c9911707.hdtg)
	e2:SetOperation(c9911707.hdop)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c9911707.recon)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function c9911707.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9911707.spfilter(c,e,tp)
	return c:IsSetCard(0x9957) and not c:IsPublic() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911707.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9911707.spfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sc=Duel.SelectMatchingCard(tp,c9911707.spfilter,tp,LOCATION_HAND,0,1,1,c,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,sc)
	Duel.ShuffleHand(tp)
	sc:CreateEffectRelation(e)
	e:SetLabelObject(sc)
end
function c9911707.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not e:GetHandler():IsPublic() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c9911707.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	local g=Group.FromCards(c,sc)
	local fg=g:Filter(Card.IsRelateToChain,nil)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or not sc:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if fg:GetCount()~=2 then return end
	Duel.SpecialSummon(fg,0,tp,tp,false,false,POS_FACEUP)
end
function c9911707.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9911707.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c9911707.costfilter(c,tp)
	return c:IsSetCard(0x9957) and Duel.IsExistingTarget(c9911707.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c9911707.hdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9911707.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911707.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return false end
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c9911707.costfilter,1,nil,tp)
		else
			return Duel.IsExistingTarget(c9911707.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroup(tp,c9911707.costfilter,1,1,nil,tp)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9911707.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9911707.hdfilter(c,atk)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()<atk
end
function c9911707.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local atk=tc:GetAttack()
			local tg=g:Filter(c9911707.hdfilter,nil,atk)
			if tg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sc=tg:Select(tp,1,1,nil):GetFirst()
				local dam=atk-sc:GetAttack()
				Duel.Destroy(sc,REASON_EFFECT)
				Duel.Damage(1-tp,dam,REASON_EFFECT)
			end
		end
		Duel.ShuffleHand(1-tp)
	end
end
function c9911707.recon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and not c:IsReason(REASON_RELEASE)
end
