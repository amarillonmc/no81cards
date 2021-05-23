--伪典·天移
function c60000105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c60000105.accon)
	e1:SetTarget(c60000105.actg)
	e1:SetOperation(c60000105.acop)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c60000105.ahcon)
	e2:SetCountLimit(1,60000105)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,00000105)
	e3:SetTarget(c60000105.xxtg)
	e3:SetOperation(c60000105.xxop)
	c:RegisterEffect(e3) 
end
function c60000105.ahcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
end
function c60000105.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x6a19)
end
function c60000105.accon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c60000105.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60000105.actg(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) and Duel.GetTurnPlayer()~=tp then
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	end
	local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
end
function c60000105.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60000105,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	tc:RegisterEffect(e2)   
	tc=g:GetNext()
	end
end
function c60000105.thfil1(c)
	return (c:IsSetCard(0x6a31) or c:IsSetCard(0x6a32)) and c:IsAbleToHand()
end
function c60000105.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000105.thfil1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_DECK,0))
	if not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x6a19)then 
	e:SetLabel(1)
	end
end
function c60000105.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(c60000105.thfil1,tp,LOCATION_GRAVE,0,1,nil) then 
	sg=Duel.SelectMatchingCard(tp,c60000105.thfil1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	end
end









