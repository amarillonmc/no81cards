--喷气★假期 美空
local m=11561075
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c11561075.mfilter,c11561075.xyzcheck,2,99)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32559361,2))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c11561075.dtccost)
	e1:SetTarget(c11561075.dtctg)
	e1:SetOperation(c11561075.dtcop)
	c:RegisterEffect(e1)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c11561075.atkval)
	c:RegisterEffect(e2)
	--th
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,11561075)
	e3:SetTarget(c11561075.thtg)
	e3:SetOperation(c11561075.thop)
	c:RegisterEffect(e3)
	
end
function c11561075.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(0) and Duel.IsExistingTarget(c11561075.thfilter2,tp,0,LOCATION_GRAVE,1,nil,c)
end
function c11561075.thfilter2(c,tc)
	return c:IsAttribute(tc:GetAttribute()) and not c:IsRace(tc:Getrace()) and c:IsAbleToHand()
end
function c11561075.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c11561075.thfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11561075.thfilter1,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c11561075.thfilter1,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11561075.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11561075.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end

end
function c11561075.atkval(e,c)
	return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)*e:GetHandler():GetCounter(0x1)*100
end
function c11561075.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,6)
end
function c11561075.xyzcheck(g)
	return g:GetClassCount(Card.GetAttribute)==1
end
function c11561075.dtccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	local ct2=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct1>ct2 then ct1=ct2 end
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsPlayerCanDraw(tp) and Duel.IsPlayerCanDraw(1-tp) and Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.IsPlayerCanDiscardDeck(1-tp,1) and ct1>0 end
	local ct=e:GetHandler():RemoveOverlayCard(tp,1,math.ceil(ct1/2),REASON_COST)
	e:SetLabel(ct)
end
function c11561075.dtctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ct)
end
function c11561075.dtcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		c:AddCounter(0x1,ct)
	end
	local d1=Duel.Draw(tp,ct,REASON_EFFECT)
	local d2=Duel.Draw(1-tp,ct,REASON_EFFECT)
	if d1~=0 or d2~=0 then
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,ct,ct,nil)
		local g2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_HAND,ct,ct,nil)
		local g3=Duel.GetDecktopGroup(tp,ct)
		local g4=Duel.GetDecktopGroup(1-tp,ct)
		g1:Merge(g2)
		g1:Merge(g3)
		g1:Merge(g4)
			Duel.BreakEffect()
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
end