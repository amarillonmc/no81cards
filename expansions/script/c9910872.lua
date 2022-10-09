--械心魔导王 恩底弥翁
function c9910872.initial_effect(c)
	aux.AddCodeList(c,9910871)
	c:EnableCounterPermit(0x1)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c9910872.cttg)
	e1:SetOperation(c9910872.ctop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910872.discon1)
	e2:SetCost(c9910872.discost)
	e2:SetTarget(c9910872.distg)
	e2:SetOperation(c9910872.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c9910872.discon2)
	c:RegisterEffect(e3)
end
function c9910872.actfilter(c,tp)
	local b1=c:GetType()==0x20002 and c:GetActivateEffect():IsActivatable(tp)
	local b2=c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
	return aux.IsCodeListed(c,9910871) and (b1 or b2)
end
function c9910872.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910872.actfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp)
		and Duel.IsCanAddCounter(tp,0x1,2,e:GetHandler()) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function c9910872.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910872,0))
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,9910872,RESET_CHAIN,0,1) end
	local tc=Duel.SelectMatchingCard(tp,c9910872.actfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	Duel.ResetFlagEffect(tp,9910872)
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if tc:IsType(TYPE_FIELD) and fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		local res=false
		if tc:IsType(TYPE_FIELD) then
			res=Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			res=Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		local te=tc:GetActivateEffect()
		if tc:IsType(TYPE_FIELD) then te:UseCountLimit(tp,1,true) end
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		if tc:IsType(TYPE_FIELD) then Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain()) end
		if res then
			Duel.BreakEffect()
			e:GetHandler():AddCounter(0x1,2)
		end
	end
end
function c9910872.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c9910872.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910872.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910872.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910872.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910872.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,2,REASON_COST)
end
function c9910872.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c9910872.disfilter(c,e)
	return c:IsRelateToEffect(e) and aux.NegateAnyFilter(c)
end
function c9910872.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9910872.disfilter,nil,e)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
