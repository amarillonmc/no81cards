--“由一瞬所积聚的一生”
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetOperation(function() Debug.Message(string.dump(loadfile("expansions/script/c11451909.lua"))) end)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		for i=0,6 do
			cm[1<<i]=0
		end
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_LEAVE_DECK)
		ge0:SetOperation(cm.regop)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.clear)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.filter(c)
	local re=c:GetReasonEffect()
	if not (c:IsType(TYPE_MONSTER) and not c:IsStatus(STATUS_TO_HAND_WITHOUT_CONFIRM) and re) then return false end
	local rc=re:GetOwner()
	return rc:IsOriginalSetCard(0xc976) and rc:GetOriginalType()&0x1>0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter,nil)
	if not Duel.GetFlagEffectLabel(0,m) then Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1) end
	for tc in aux.Next(g) do
		Duel.SetFlagEffectLabel(0,m,Duel.GetFlagEffectLabel(0,m)|tc:GetAttribute())
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	for i=0,6 do
		cm[1<<i]=0
	end
end
function cm.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x44f)
end
function cm.afilter(c,e,tp,attr)
	return c:GetAttribute()~=attr and cm[c:GetAttribute()]<=0 and c:IsSetCard(0xc976) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsActiveType(TYPE_MONSTER) then return end
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local _,ct=mg:GetMaxGroup(Card.GetTurnCounter)
	local ct=0 --ct or 0
	local rc=re:GetHandler()
	local attr=rc:GetAttribute()
	local b2=false
	for i=0,6 do
		--if attr&(1<<i)>0 and cm[1<<i]>ct then return end
		if attr&(1<<i)>0 and Duel.GetFlagEffectLabel(0,m) and Duel.GetFlagEffectLabel(0,m)&(1<<i)>0 then b2=Duel.IsChainDisablable(ev) and cm[1<<i]<=ct end
	end
	local g=Duel.GetMatchingGroup(cm.afilter,tp,LOCATION_DECK,0,nil,e,tp,attr)
	if #g==0 and not b2 then return end
	local off=1
	local ops={}
	local opval={}
	if #g>0 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	ops[off]=aux.Stringid(m,2)
	opval[off-1]=3
	Duel.HintSelection(Group.FromCards(c))
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,1,1,nil)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			attr=g:GetFirst():GetAttribute()
			for i=0,6 do
				if attr&(1<<i)>0 then
					cm[1<<i]=cm[1<<i]+1
					c:RegisterFlagEffect(0,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,i+3))
				end
			end
			g:GetFirst():RegisterFlagEffect(m,RESET_CHAIN,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCondition(function() return ev==Duel.GetCurrentChain() end)
			e1:SetValue(function(e,te) return te:GetCode()==EVENT_CHAINING and te:IsHasType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F) end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			--g:GetFirst():RegisterEffect(e1)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e6:SetCode(EVENT_CHAIN_SOLVED)
			e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e6:SetLabelObject(g:GetFirst())
			e6:SetCondition(cm.descon)
			e6:SetOperation(cm.desop)
			e6:SetReset(RESET_CHAIN)
			--Duel.RegisterEffect(e6,tp)
			local e7=e6:Clone()
			e7:SetCode(EVENT_CHAIN_NEGATED)
			--Duel.RegisterEffect(e7,tp)
		end
	elseif opval[op]==2 then
		for i=0,6 do
			if attr&(1<<i)>0 then
				cm[1<<i]=cm[1<<i]+1
				c:RegisterFlagEffect(0,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,i+3))
			end
		end
		Duel.NegateEffect(ev)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		return Duel.GetCurrentChain()==1
	else
		e:Reset()
		return false
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end