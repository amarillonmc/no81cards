--人理之诗 兰丸·X
function c22024980.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,4,c22024980.ovfilter,aux.Stringid(22024980,0),4,c22024980.xyzop)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22024980,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,c22024980)
	e1:SetCost(c22024980.thcost)
	e1:SetTarget(c22024980.thtg)
	e1:SetOperation(c22024980.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22024980,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,c22024981)
	e2:SetCondition(c22024980.imcon)
	e2:SetTarget(c22024980.tgtg)
	e2:SetOperation(c22024980.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c22024980.imcon1)
	c:RegisterEffect(e3)
end
function c22024980.cfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c22024980.ovfilter(c)
	return c:IsFaceup() and c:IsCode(22024970)
end
function c22024980.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22024980.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c22024980.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c22024980.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22024980.thfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c22024980.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22024980.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22024980.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22024980.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22024980.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		for p=0,1 do
			local loc=LOCATION_HAND+LOCATION_ONFIELD
			if Duel.GetFieldGroupCount(p,loc,0)<2 then
				return false
			end
		end
		return true
	end
	Duel.SelectOption(tp,aux.Stringid(22024980,3))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,4,PLAYER_ALL,LOCATION_HAND+LOCATION_ONFIELD)
end
function c22024980.tgop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local loc=LOCATION_HAND+LOCATION_ONFIELD
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(p,Card.IsAbleToGrave,p,loc,0,2,2,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c22024980.xfilter1(c)
	return c:GetSequence()==0
end
function c22024980.xfilter2(c)
	return c:GetSequence()==2
end
function c22024980.xfilter3(c)
	return c:GetSequence()==4
end
function c22024980.imcon(e)
	return e:GetHandler():GetSequence()==5 and Duel.IsExistingMatchingCard(c22024980.xfilter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22024980.xfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22024980.xfilter3,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c22024980.xfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c22024980.imcon1(e)
	return e:GetHandler():GetSequence()==6 and Duel.IsExistingMatchingCard(c22024980.xfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22024980.xfilter3,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22024980.xfilter1,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c22024980.xfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end