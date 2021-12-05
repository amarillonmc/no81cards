--惧 轮  冰 点 雷 霆
function c53701004.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53701004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c53701004.condition)
	e1:SetTarget(c53701004.target)
	e1:SetOperation(c53701004.operation)
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c53701004.value)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c53701004.descon)
	e4:SetOperation(c53701004.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CUSTOM+53701033)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c53701004.desop)
	c:RegisterEffect(e6)
	--count
	if not c53701004.global_check then
		c53701004.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c53701004.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c53701004.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not tc:IsSetCard(0x3530) then return end
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),53701004,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c53701004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,53701004)>=5
end
function c53701004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c53701004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c53701004.filter(c,e,tp)
	return c:IsSetCard(0x3530) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c53701004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c53701004.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c53701004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c53701004.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c53701004.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*300
end
function c53701004.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3530) and c:IsControler(tp) and c:IsAttackPos()
end
function c53701004.descon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c53701004.cfilter,1,nil,tp)
end
function c53701004.desfilter1(c,mc)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsCode(53701009) and c:GetLinkedGroup():IsContains(mc)
end
function c53701004.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(1-tp,1) then return end
	local g=Duel.GetDecktopGroup(1-tp,1)
	Duel.DisableShuffleCheck()
	Duel.Destroy(g,REASON_EFFECT)
	local trg=e:GetHandler():GetFlagEffect(53701000)
	e:GetHandler():RegisterFlagEffect(53701000,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53701000,trg))
	local nm=3
	if e:GetHandler():IsHasEffect(53701009) then nm=2 end
	local hg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if (trg+1)%nm==0 then
		e:GetHandler():ResetFlagEffect(53701000)
		if #hg>0 then
			Duel.Hint(HINT_CARD,0,53701004)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local tg=hg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			Duel.Destroy(tg,REASON_EFFECT)
		end
	end
end
