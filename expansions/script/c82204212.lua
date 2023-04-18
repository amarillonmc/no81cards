local m=82204212
local cm=_G["c"..m]
cm.name="吉良吉广"
function cm.initial_effect(c)
	aux.AddCodeList(c,82204200)
	--field
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,m)  
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)  
	--destroy replace  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EFFECT_DESTROY_REPLACE)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetTarget(cm.reptg)  
	e2:SetValue(cm.repval)  
	e2:SetOperation(cm.repop)  
	c:RegisterEffect(e2) 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsDiscardable() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)  
end  
function cm.filter(c,tp)  
	return c:IsType(TYPE_FIELD) and c:IsCode(82204203) and c:GetActivateEffect():IsActivatable(tp,true,true)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tp) end  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)  
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()  
	if tc then  
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)  
		if fc then  
			Duel.SendtoGrave(fc,REASON_RULE)  
			Duel.BreakEffect()  
		end  
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)  
		local te=tc:GetActivateEffect()  
		te:UseCountLimit(tp,1,true)  
		local tep=tc:GetControler()  
		local cost=te:GetCost()  
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end  
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())  
	end  
end  
function cm.repfilter(c,tp)  
	return c:IsFaceup() and c:IsCode(82204200) and c:IsLocation(LOCATION_MZONE)  
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)  
end  
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end  
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)  
end  
function cm.repval(e,c)  
	return cm.repfilter(c,e:GetHandlerPlayer())  
end  
function cm.repop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)  
end  