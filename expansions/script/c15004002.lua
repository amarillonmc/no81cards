local m=15004002
local cm=_G["c"..m]
cm.name="破晓之时"
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--self
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(15004002)
	e2:SetRange(LOCATION_SZONE) 
	c:RegisterEffect(e2)
	if not cm.global_effect then
		cm.global_effect=true
		--cannot activate
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge0:SetCode(EFFECT_CANNOT_ACTIVATE)
		ge0:SetTargetRange(1,1)
		ge0:SetCondition(cm.actcon)
		ge0:SetValue(cm.aclimit)
		Duel.RegisterEffect(ge0,0)
		--banish
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(cm.rmcon)
		ge1:SetOperation(cm.rmop)
		ge1:SetLabel(0)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCondition(cm.rmcon)
		ge2:SetOperation(cm.rmop)
		ge2:SetLabel(1)
		Duel.RegisterEffect(ge2,1)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetCondition(cm.tgcon)
		ge3:SetOperation(cm.tgop)
		Duel.RegisterEffect(ge3,1)
		--token
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetRange(LOCATION_SZONE)
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetCondition(cm.tkcon)
		ge4:SetOperation(cm.tkop)
		ge4:SetLabel(0)
		Duel.RegisterEffect(ge4,0)
		--token
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge5:SetRange(LOCATION_SZONE)
		ge5:SetCode(EVENT_ADJUST)
		ge5:SetCondition(cm.tkcon)
		ge5:SetOperation(cm.tkop)
		ge5:SetLabel(1)
		Duel.RegisterEffect(ge5,1)
	end
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.selffilter,p,LOCATION_SZONE,LOCATION_SZONE,nil,1)~=0 and Duel.GetMatchingGroupCount(cm.sel2ffilter,p,LOCATION_SZONE,LOCATION_SZONE,nil,0)~=0
end
function cm.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return ((re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_SPELL)) or (re:IsActiveType(TYPE_MONSTER) and not rc:IsLocation(LOCATION_HAND)))
end
function cm.selffilter(c,x)
	return c:IsFaceup() and c:IsCode(15004002) and ((not c:IsDisabled()) or (x==1))
end
function cm.sel2ffilter(c,x)
	return c:IsFaceup() and c:IsHasEffect(15004002) and ((not c:IsDisabled()) or (x==1))
end
function cm.rmfilter(c)
	return ((not c:IsCode(15004002) and not c:IsCode(15004003)) or c:IsFacedown())
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	return Duel.GetMatchingGroupCount(cm.selffilter,p,LOCATION_SZONE,LOCATION_SZONE,nil,1)~=0 and Duel.GetMatchingGroupCount(cm.sel2ffilter,p,LOCATION_SZONE,LOCATION_SZONE,nil,0)~=0 and Duel.GetMatchingGroupCount(cm.rmfilter,p,LOCATION_ONFIELD,0,nil)~=0
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	local g=Duel.GetMatchingGroup(cm.rmfilter,p,LOCATION_ONFIELD,0,nil)
	local ac=g:GetFirst()
	local ag=Group.CreateGroup()
	while ac do
		if ac:IsFacedown() then ag:AddCard(ac) end
		ac=g:GetNext()
	end
	if ag:GetCount()~=0 then Duel.ConfirmCards(1-p,ag) end
	if Duel.Remove(g,POS_FACEDOWN,REASON_RULE)~=0 then
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(15004002,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
			tc=g:GetNext()
		end
	end
end
function cm.tgfilter(c)
	return c:IsFacedown() and c:GetFlagEffect(15004002)~=0
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.selffilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,1)==0 and Duel.GetMatchingGroupCount(cm.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)~=0
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local ac=g:GetFirst()
	if g:GetCount()==0 or Duel.GetMatchingGroupCount(cm.selffilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)~=0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	return Duel.GetMatchingGroupCount(cm.selffilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,1)~=0 and Duel.GetMatchingGroupCount(cm.sel2ffilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,0)~=0 and not Duel.IsExistingMatchingCard(Card.IsCode,p,LOCATION_MZONE,0,1,nil,15004003)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	if Duel.IsPlayerCanSpecialSummonMonster(p,15004003,nil,0x4011,0,0,11,RACE_AQUA,ATTRIBUTE_LIGHT) then
		local code=15004003
		local token=Duel.CreateToken(p,code)
		if Duel.SpecialSummonStep(token,0,p,p,false,false,POS_FACEUP) then
			--atkdef
			local e1=Effect.CreateEffect(token)
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetRange(LOCATION_MZONE)  
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(cm.atkval)
			e1:SetLabel(p)
			token:RegisterEffect(e1)
			local e2=Effect.CreateEffect(token)
			e2:SetType(EFFECT_TYPE_SINGLE)  
			e2:SetRange(LOCATION_MZONE)  
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(cm.defval)
			e2:SetLabel(p)
			token:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.atkval(e,c)
	local p=e:GetLabel()
	local ag=Duel.GetMatchingGroup(cm.tgfilter,p,LOCATION_REMOVED,0,nil)
	return ag:GetSum(Card.GetBaseAttack)
end
function cm.defval(e,c)
	local p=e:GetLabel()
	local ag=Duel.GetMatchingGroup(cm.tgfilter,p,LOCATION_REMOVED,0,nil)
	return ag:GetSum(Card.GetBaseDefense)
end