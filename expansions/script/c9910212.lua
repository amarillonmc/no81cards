--天空漫步者-拦截
function c9910212.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c9910212.condition)
	e1:SetTarget(c9910212.target)
	e1:SetOperation(c9910212.activate)
	c:RegisterEffect(e1)
	if not c9910212.global_check then
		c9910212.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BECOME_TARGET)
		ge1:SetOperation(c9910212.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(c9910212.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9910212.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9910212,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910212,0))
		end
	end
end
function c9910212.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c9910212.ctgfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9910212,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910212,0))
		end
	end
end
function c9910212.ctgfilter(c)
	return c:GetOwnerTargetCount()>0 and c:GetFlagEffect(9910212)==0
end
function c9910212.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsRace(RACE_PSYCHO))
end
function c9910212.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910212.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910212.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x955)
end
function c9910212.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910212.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910212.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910212,1))
	Duel.SelectTarget(tp,c9910212.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9910212.desfilter1(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function c9910212.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp)
		or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	local tg=tc:GetColumnGroup():Filter(c9910212.desfilter1,nil,tp)
	local off=1
	local ops={}
	local opval={}
	if tg:GetCount()>0 then
		ops[off]=aux.Stringid(9910212,1)
		opval[off-1]=1
		off=off+1
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>2 and Duel.GetFlagEffect(tp,9910229)==0 then
		ops[off]=aux.Stringid(9910212,2)
		opval[off-1]=2
		off=off+1
	end
	ops[off]=aux.Stringid(9910212,3)
	opval[off-1]=3
	off=off+1
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=tg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	elseif opval[op]==2 then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCondition(c9910212.descon)
		e1:SetOperation(c9910212.desop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(9910212,4))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterFlagEffect(tp,9910229,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9910212.cfilter2(c,tp)
	return c:GetFlagEffect(9910212)~=0 and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c9910212.desfilter2(c,tp)
	return c:GetColumnGroup():IsExists(c9910212.cfilter2,1,nil,tp)
end
function c9910212.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910212.desfilter2,tp,0,LOCATION_ONFIELD,1,nil,tp)
end
function c9910212.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910212.desfilter2,tp,0,LOCATION_ONFIELD,nil,tp)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
