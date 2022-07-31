--轮回世界 拒绝
function c6162601.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_IMMUNE_EFFECT)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))  
	e2:SetValue(c6162601.efilter)  
	c:RegisterEffect(e2) 
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6162601,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,6162601)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCost(c6162601.cost)
	e3:SetTarget(c6162601.target)
	e3:SetOperation(c6162601.activate)
	c:RegisterEffect(e3) 
end
function c6162601.efilter(e,te)  
	return te:GetOwner():IsSetCard(0x616)
end 
function c6162601.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)  
end  
function c6162601.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end  
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function c6162601.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end