--黑化觉醒 赤姬
function c79520001.initial_effect(c)
	aux.AddCodeList(c,79520000)
	c:SetSPSummonOnce(79520001)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),10,2,c79520001.ovfilter,aux.Stringid(79520001,0))
	c:EnableReviveLimit()
	--xyz
	--local e1=Effect.CreateEffect(c) 
	--e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1:SetProperty(EFFECT_FLAG_DELAY)
	--e1:SetCondition(c79520001.xyzcon)
	--e1:SetTarget(c79520001.xyztg)
	--e1:SetOperation(c79520001.xyzop)
	--c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetDescription(aux.Stringid(79520001,2))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79520001)
	e2:SetCost(c79520001.cost)
	e2:SetTarget(c79520001.target)
	e2:SetOperation(c79520001.operation)
	c:RegisterEffect(e2)
	--to deck and damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79520001,3))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetCountLimit(1,19520001)
	e3:SetCondition(c79520001.ddcon)
	e3:SetTarget(c79520001.ddtg)
	e3:SetOperation(c79520001.ddop)
	c:RegisterEffect(e3)
end
c79520001.named_with_Constellation=true 
c79520001.assault_name=79520000
function c79520001.ovfilter(c)
	return c:IsFaceup() and c:IsCode(79520000)
end
function c79520001.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79520001.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,nil) end 
end
function c79520001.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()<=0 then return end
	local og=g:Select(tp,1,1,nil)
	Duel.Overlay(c,og)
end
function c79520001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79520001.filter(c)
	return c:IsFaceup()
end
function c79520001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79520001.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79520001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79520001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c79520001.thfil(c)
	return c:IsAbleToHand() and c.named_with_Constellation 
end
function c79520001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
	if tc==c and Duel.IsExistingMatchingCard(c79520001.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79520001,1)) then 
	local g=Duel.SelectMatchingCard(tp,c79520001.thfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,tp,REASON_EFFECT+REASON_REVEAL)
	Duel.ConfirmCards(1-tp,g)
	end
end
function c79520001.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())  
end
function c79520001.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,1,nil,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c79520001.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil) 
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoDeck(tc,tp,2,REASON_EFFECT) 
	if not tc:IsLocation(LOCATION_DECK) then return end
	Duel.ShuffleDeck(tp)
	tc:ReverseInDeck()
	local dg=Group.FromCards(tc)
	Duel.ConfirmCards(1-tp,dg) 
	dg:Select(tp,1,1,nil)
	dg:Select(1-tp,1,1,nil)
	local x=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=x-tc:GetSequence()+1 
	if seq==4 or seq==8 or seq==12 or seq==16 or seq==20 or seq==24 or seq==28 or seq==32 or seq==36 or seq==40 or seq==44 or seq==48 or seq==52 or seq==56 or seq==60 or seq==64 or seq==68 then 
	Duel.Damage(1-tp,c:GetAttack(),REASON_EFFECT)
	else
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
	end
end








