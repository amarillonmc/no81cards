--绝海一战
function c29010012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c29010012.target)
	e1:SetOperation(c29010012.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c29010012.handcon)
	c:RegisterEffect(e2)
end
function c29010012.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c29010012.handcon(e)
	return Duel.IsExistingMatchingCard(c29010012.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c29010012.filter,tp,0,LOCATION_MZONE,1,nil)
end
function c29010012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_MZONE 
	local res=Duel.GetMatchingGroup(c29010012.filter,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetOriginalCode)>=3
	if res then loc=LOCATION_ONFIELD end
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,loc,nil)
	if chk==0 then return g:GetCount()>0 end
	if res then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_MZONE)
	else
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	end
end
function c29010012.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local loc=LOCATION_MZONE 
	local res=Duel.GetMatchingGroup(c29010012.filter,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetOriginalCode)>=3
	if res then loc=LOCATION_ONFIELD end
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,loc,nil)
	if g:GetCount()==0 then return end
	if res and Duel.SelectYesNo(tp,aux.Stringid(29010012,0)) then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetTarget(c29010012.distg)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(c29010012.discon)
			e2:SetOperation(c29010012.disop)
			e2:SetLabelObject(tc)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)  
			tc=g:GetNext()
		end
	else
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c29010012.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c29010012.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local rc=re:GetHandler()
	return rc:IsControler(1-tp) and rc:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c29010012.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
