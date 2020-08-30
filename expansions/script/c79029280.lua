--企鹅战法·无畏冲锋
function c79029280.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c79029280.target)
	e1:SetOperation(c79029280.activate)
	c:RegisterEffect(e1)   
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c79029280.lztg)
	e2:SetOperation(c79029280.lzop)
	e2:SetCondition(c79029280.condition)
	c:RegisterEffect(e2)  
end
function c79029280.filter(c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_XYZ)
end
function c79029280.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029280.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c79029280.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029280.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetTargetCard(g)
end
function c79029280.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	e:GetHandler():CancelToGrave()
	Duel.Overlay(tc,e:GetHandler())
	Debug.Message("力量与荣耀！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029280,1))
end
function c79029280.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0)
	and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c79029280.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
end
function c79029280.lzop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	Duel.Destroy(tc,REASON_EFFECT)
	if e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029280,0)) then
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil)
	Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
	Duel.ConfirmCards(tp,e:GetHandler())
	Debug.Message("我要去战斗。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029280,2))
	end
end







