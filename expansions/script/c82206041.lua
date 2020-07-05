local m=82206041
local cm=_G["c"..m]
cm.name="植占师21-陷阱"
function cm.initial_effect(c)
	--destroy  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(cm.condition)  
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)  
end  
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x29d)  
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	local at=Duel.GetAttacker()  
	return at:GetControler()~=tp and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsDiscardable() end  
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)  
end   
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tg=Duel.GetAttacker()  
	if chk==0 then return tg:IsOnField() end  
	Duel.SetTargetCard(tg)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	Duel.SetChainLimit(cm.chlimit)   
end  
function cm.chlimit(e,ep,tp)  
	return tp==ep  
end 
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		if Duel.NegateAttack() then
			Duel.Destroy(tc,REASON_EFFECT)  
		end
	end  
end  