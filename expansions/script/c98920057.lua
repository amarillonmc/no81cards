--魔玩具·破损熊
function c98920057.initial_effect(c)
		c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xa9),1,1)
	--cannot be link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)  
  --change name
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920057,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98920057)
	e2:SetCost(c98920057.tgcost)
	e2:SetOperation(c98920057.tgop)
	c:RegisterEffect(e2)   
 --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920057,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98930057)
	e1:SetCost(c98920057.thcost)
	e1:SetTarget(c98920057.thtg)
	e1:SetOperation(c98920057.thop)
	c:RegisterEffect(e1)
end
function c98920057.tgfilter(c)
	return c:IsSetCard(0xa9) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c98920057.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920057.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920057.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function c98920057.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(e:GetLabel())
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920057,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e1)
	e2:SetOperation(c98920057.rstop)
	c:RegisterEffect(e2)
end
function c98920057.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c98920057.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c98920057.thfilter(c,thchk)
	return (c:IsCode(24094653) or (thchk and c:IsCode(6077601))) and c:IsAbleToHand()
end
function c98920057.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local thchk=Duel.IsEnvironment(70245411)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920057.thfilter,tp,LOCATION_DECK,0,1,nil,thchk) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920057.thop(e,tp,eg,ep,ev,re,r,rp)
	local thchk=Duel.IsEnvironment(70245411)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920057.thfilter,tp,LOCATION_DECK,0,1,1,nil,thchk)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end