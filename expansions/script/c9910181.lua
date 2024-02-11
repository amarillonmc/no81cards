--追缉队特别任务
function c9910181.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_TOHAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9910181)
	e2:SetCost(c9910181.cost)
	e2:SetTarget(c9910181.target)
	e2:SetOperation(c9910181.operation)
	c:RegisterEffect(e2)
end
function c9910181.cfilter(c)
	return c:IsSetCard(0x3954) and c:IsRace(RACE_WARRIOR)
end
function c9910181.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c9910181.cfilter,1,REASON_COST,true,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c9910181.cfilter,1,1,REASON_COST,true,nil)
	Duel.Release(g,REASON_COST)
end
function c9910181.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local chain=Duel.GetCurrentChain()
	local ct=0
	for i=1,chain do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if tc:IsSetCard(0x3954) then ct=ct+1 end
	end
	local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsPlayerCanDraw(1-tp,1)
	local b2=ct>0 and Duel.IsPlayerCanDraw(tp,ct)
	if chk==0 then return b1 or b2 end
	e:SetLabel(ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c9910181.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local res=true
	local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsPlayerCanDraw(1-tp,1)
	local b2=ct>0 and Duel.IsPlayerCanDraw(tp,ct) and c:IsRelateToEffect(e)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(9910181,0))) then
		res=false
		local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		else
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
	if b2 and c:IsRelateToEffect(e) and (res or Duel.SelectYesNo(tp,aux.Stringid(9910181,1)))
		and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Draw(tp,ct,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c9910181.distg1)
		e1:SetLabel(ac)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c9910181.discon)
		e2:SetOperation(c9910181.disop)
		e2:SetLabel(ac)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(c9910181.distg2)
		e3:SetLabel(ac)
		e3:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e3,tp)
	end
end
function c9910181.distg1(e,c)
	local ac=e:GetLabel()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(ac)
	else
		return c:IsOriginalCodeRule(ac) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function c9910181.distg2(e,c)
	local ac=e:GetLabel()
	return c:IsOriginalCodeRule(ac)
end
function c9910181.discon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return re:GetHandler():IsOriginalCodeRule(ac)
end
function c9910181.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
