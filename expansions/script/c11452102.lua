--小丑与游园地
local s,id=GetID()
function s.initial_effect(c)
	--Trap activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
function s.handfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.handcon(e)
	return Duel.GetMatchingGroupCount(s.handfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)==0
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(s.thcon)
	e1:SetOperation(s.thop)
	Duel.RegisterEffect(e1,tp)
end
function s.cfilter(c)
	return not c:IsReason(REASON_DRAW)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.pfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function s.ffilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.sfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local b1 = Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_HAND,0,1,nil,tp)
	local b2 = Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_HAND,0,1,nil,tp)
	local b3 = Duel.GetFlagEffect(tp,id+2)==0 and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_HAND,0,1,nil)
	if not (b1 or b2 or b3) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,4)) then return end
	Duel.Hint(HINT_CARD,0,id)
	local ops={}
	local opval={}
	if b1 then
		table.insert(ops,aux.Stringid(id,0))
		table.insert(opval,1)
	end
	if b2 then
		table.insert(ops,aux.Stringid(id,1))
		table.insert(opval,2)
	end
	if b3 then
		table.insert(ops,aux.Stringid(id,2))
		table.insert(opval,3)
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	local res=false
	if sel==1 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
		if tc then
			res = Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	elseif sel==2 then
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,s.ffilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			res = Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	elseif sel==3 then
		Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		if tc then
			res = (Duel.SSet(tp,tc,tp,false) > 0)
		end
	end
	if res then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end