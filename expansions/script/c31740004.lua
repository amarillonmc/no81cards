--神子 九郎
local s,id,o = GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,31740001)
	local e2 = Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK + CATEGORY_SPECIAL_SUMMON + CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetCondition(s.thcon)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(s.spcon)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetCondition(s.lfcon)
		e1:SetOperation(s.lfop2)
		Duel.RegisterEffect(e1,0)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	 
	return Duel.GetFlagEffect(tp,id+o)==0
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	 
	return Duel.GetFlagEffect(tp,id+o)~=0
end
function s.lfcon(e,tp,eg,ep,ev,re,r,rp)
	 
	return re and re:GetHandler():IsCode(31740001)
end
function s.lfop2(e,tp,eg,ep,ev,re,r,rp)
		local g = Group.Clone(eg)
		for tc in aux.Next(g) do
			Duel.RegisterFlagEffect(1-tc:GetOwner(),id,0,0,0)
		end
		
			
	
	
end
function s.thcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return not c:IsPublic()
	end
	local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetDescription(66)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				c:RegisterEffect(e1)
end
-- 效果②目标：设置操作信息
function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, nil, tp, LOCATION_GRAVE)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
	
end

-- 效果②操作：返回卡组，检索/特召
function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local ct = Duel.GetMatchingGroupCount(s.skrfilter,tp,LOCATION_MZONE,0,nil)+Duel.GetFlagEffect(tp,id)
	if ct==0  then --特招
		local tc = Duel.SelectMatchingCard(tp,s.spskrfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if tc then 
			Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) 
		end
		
	end
	if ct>=1 then 
		Duel.RegisterFlagEffect(tp,id+o,0,0,0)
	end
	if ct>=2 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
		local g = Duel.SelectMatchingCard(tp, s.penfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if #g > 0 and (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)) then
			Duel.MoveToField(g:GetFirst(), tp, tp, LOCATION_PZONE, POS_FACEUP, true)
		end	
	end
	if ct>=3 then 
		local sct = Duel.GetFlagEffect(tp,id)
		local tg = Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil)
		if sct>0 and tg then 
			local tdg = tg:Select(tp,0,sct,nil)
			local tdc = Duel.SendtoDeck(tdg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(s.atktg)
			e1:SetValue(tdc*500)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(s.atktg)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(tdc-1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
		end
		
	end
end
function s.atktg(e,c)
	return c:IsCode(31740001)
end

function s.tdfilter(c)
	return c:IsAbleToDeck() and (aux.IsCodeListed(c,31740001) or c:IsCode(31740001))
end
function s.penfilter(c)
	return c:IsType(TYPE_PENDULUM) and aux.IsCodeListed(c,31740001)  -- 假设0xfe是只狼系列的系列代码
end
function s.skrfilter(c)
	return c:IsCode(31740001) and c:IsFaceup()
end
function s.spskrfilter(c,e,tp)
	return c:IsCode(31740001) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
-- 检索过滤器：只狼或有只狼卡名记述的楔丸攻击/防御以外的怪兽
function s.filter(c)
	return c:IsCode(31740001) or 
		   aux.IsCodeListed(31740001) and  c:IsType(TYPE_MONSTER) and not c:IsCode(31740005, 31740006) and not c:IsPublic()
		   
end