--云端星灵 弥赛亚
local m=87498386
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,cm.lcheck)
	c:EnableReviveLimit()
	--Add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	--remove target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.ccon)
	e3:SetTarget(cm.ctg)
	e3:SetOperation(cm.cop)
	c:RegisterEffect(e3)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsRace,1,nil,RACE_PSYCHO)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and re:GetHandler()~=c and c:GetFlagEffect(FLAG_ID_CHAINING)>0 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
		if g:GetCount()>0 then
			local dg=Group.CreateGroup()
			local sc=g:GetFirst()
			while sc do
				local preatk=sc:GetAttack()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-800)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
				if preatk~=0 and sc:IsAttack(0) then dg:AddCard(sc) end
				sc=g:GetNext()
			end
			if Duel.Remove(dg,0,REASON_EFFECT+REASON_TEMPORARY)>0 and dg:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
				local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
				for tc in aux.Next(og) do
					tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
				end
				og:KeepAlive()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabelObject(og)
				e1:SetCountLimit(1)
				e1:SetCondition(cm.retcon)
				e1:SetOperation(cm.retop)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function cm.retfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(cm.retfilter,1,nil)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(cm.retfilter,nil)
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
end
function cm.ccon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 or not g:GetFirst():IsType(TYPE_MONSTER) then return false end
	return true
end
function cm.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if chk==0 then return tc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function cm.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local dg=Group.CreateGroup()
	local og=Group.CreateGroup()
	local tc=g:GetFirst()
	if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 and tc:IsLocation(LOCATION_REMOVED) then
		og:AddCard(tc)
		tc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.BreakEffect()
		local fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if fg:GetCount()>0 then
			local sc=fg:GetFirst()
			while sc do
				local preatk=sc:GetAttack()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-1800)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
				if preatk~=0 and sc:IsAttack(0) then dg:AddCard(sc) end
				sc=fg:GetNext()
			end
			if Duel.Remove(dg,0,REASON_EFFECT+REASON_TEMPORARY)>0 and dg:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
				local op_g=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
				for reg_card in aux.Next(op_g) do
					reg_card:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
					og:AddCard(reg_card)
				end
			end
		end
	end
	og:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(og)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.retcon2)
	e1:SetOperation(cm.retop2)
	Duel.RegisterEffect(e1,tp)
end
function cm.retfilter2(c)
	return c:GetFlagEffect(m+1)~=0
end
function cm.retcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(cm.retfilter2,1,nil)
end
function cm.retop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(cm.retfilter2,nil)
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
end