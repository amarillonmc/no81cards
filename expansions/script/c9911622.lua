--缚面屠夫
function c9911622.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9911622)
	e1:SetTarget(c9911622.sptg)
	e1:SetOperation(c9911622.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911622,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9911623)
	e2:SetCondition(c9911622.descon)
	e2:SetTarget(c9911622.destg)
	e2:SetOperation(c9911622.desop)
	c:RegisterEffect(e2)
	--gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c9911622.mtcon)
	e3:SetOperation(c9911622.mtop)
	c:RegisterEffect(e3)
	if not c9911622.global_flag then
		c9911622.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(c9911622.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911622.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsControler,1,nil,0) and Duel.GetFlagEffect(0,9911622)==0 then
		Duel.RegisterFlagEffect(0,9911622,RESET_PHASE+PHASE_END,0,1)
	end
	if eg:IsExists(Card.IsControler,1,nil,1) and Duel.GetFlagEffect(1,9911622)==0 then
		Duel.RegisterFlagEffect(1,9911622,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9911622.filter1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:GetOriginalLevel()>0
		and Duel.IsExistingMatchingCard(c9911622.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetOriginalLevel())
end
function c9911622.filter2(c,lv)
	return c:IsFaceup() and c:GetLevel()>0 and not c:IsLevel(lv)
end
function c9911622.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9911622.filter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9911622.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9911622.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c9911622.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=tc:GetOriginalLevel()
		local g=Duel.GetMatchingGroup(c9911622.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,lv)
		if g:GetCount()>0 then
			for lc in aux.Next(g) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(lv)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				lc:RegisterEffect(e1)
			end
			if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9911622.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911622)>0
end
function c9911622.lvfilter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c9911622.rkfilter(c)
	return c:IsFaceup() and c:GetRank()>0
end
function c9911622.lkfilter(c)
	return c:IsFaceup() and c:GetLink()>0
end
function c9911622.fselect(g,lv,rk,lk)
	local lv1,rk1,lk1=lv,rk,lk
	for tc in aux.Next(g) do
		if lv1>0 and tc:IsLevel(lv1) then lv1=0
		elseif rk1>0 and tc:IsRank(rk1) then rk1=0
		elseif lk1>0 and tc:IsLink(lk1) then lk1=0
		else return false end
	end
	return true
end
function c9911622.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g1=Duel.GetMatchingGroup(c9911622.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c9911622.rkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g3=Duel.GetMatchingGroup(c9911622.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=Group.CreateGroup()
	local lv=0
	local rk=0
	local lk=0
	if #g1>0 then
		local tg1,ct1=g1:GetMinGroup(Card.GetLevel)
		tg:Merge(tg1)
		lv=ct1
	end
	if #g2>0 then
		local tg2,ct2=g2:GetMinGroup(Card.GetRank)
		tg:Merge(tg2)
		rk=ct2
	end
	if #g3>0 then
		local tg3,ct3=g3:GetMinGroup(Card.GetLink)
		tg:Merge(tg3)
		lk=ct3
	end
	if chk==0 then return tg:IsExists(Card.IsCanBeEffectTarget,1,nil,e) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	tg=tg:Filter(Card.IsCanBeEffectTarget,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=tg:SelectSubGroup(tp,c9911622.fselect,false,1,3,lv,rk,lk)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function c9911622.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c9911622.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c9911622.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911622,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9911623)
	e2:SetCondition(c9911622.descon)
	e2:SetTarget(c9911622.destg)
	e2:SetOperation(c9911622.desop)
	rc:RegisterEffect(e2,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e3,true)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911622,1))
end
