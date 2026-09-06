--剑域修武士 落银
function c9911705.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9911705)
	e1:SetCost(c9911705.spcost)
	e1:SetTarget(c9911705.sptg)
	e1:SetOperation(c9911705.spop)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c9911705.atktg)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e3)
	--redirect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(c9911705.recon)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
	if not c9911705.global_check then
		c9911705.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BECOME_TARGET)
		ge1:SetOperation(c9911705.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(c9911705.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9911705.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911705,RESET_EVENT+0x1fc0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911705,3))
		end
	end
end
function c9911705.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c9911705.ctgfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911705,RESET_EVENT+0x1fc0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911705,3))
		end
	end
end
function c9911705.ctgfilter(c)
	return c:GetOwnerTargetCount()>0 and c:GetFlagEffect(9911705)==0
end
function c9911705.costfilter(c)
	return c:IsSetCard(0x9957) and c:IsDiscardable()
end
function c9911705.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911705.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c9911705.costfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c9911705.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911705.spfilter(c,e,tp)
	return c:IsCode(9911705) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911705.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	Duel.AdjustAll()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911705.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,POS_FACEDOWN)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(9911705,0),1},
		{b2,aux.Stringid(9911705,1),2},
		{true,aux.Stringid(9911705,2),3})
	if op==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c9911705.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=sg:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_TUNER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	elseif op==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,POS_FACEDOWN)
		if tg:GetCount()>0 then
			Duel.HintSelection(tg)
			Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c9911705.atktg(e,c)
	return c:GetFlagEffect(9911705)~=0
end
function c9911705.recon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and not c:IsReason(REASON_RELEASE)
end
