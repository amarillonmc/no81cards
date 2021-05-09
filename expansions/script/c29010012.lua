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
function c29010012.handcon(e)
	return Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_MZONE,1,nil,ATTRIBUTE_WATER)
end
function c29010012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end
	if Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_MZONE,0,nil,ATTRIBUTE_WATER):GetClassCount(Card.GetOriginalCode)>=3 and Duel.SelectYesNo(tp,aux.Stringid(29010012,0)) then 
	e:SetLabel(1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_MZONE)
end
function c29010012.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if e:GetLabel()==1 then 
	g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
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
	g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)	 
	end
end
function c29010012.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsCode(tc:GetCode())
end
function c29010012.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode())
end
function c29010012.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end







