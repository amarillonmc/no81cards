--怒喰大怪兽 哥莫拉
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
function c10150065.initial_effect(c)
	c:SetSPSummonOnce(10150065)
	--link summon
	c:EnableReviveLimit() 
	aux.AddLinkProcedure(c,nil,2,2,c10150065.lcheck)
	local e1=rsef.FV_EXTRA_MATERIAL_SELF(c,"link",nil,aux.TargetBoolFunction(Card.IsLinkSetCard,0xd3),{0,LOCATION_MZONE }) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150065,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c10150065.thtg)
	e2:SetOperation(c10150065.thop)
	c:RegisterEffect(e2)
	--th
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10150065,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c10150065.thcost2)
	e1:SetTarget(c10150065.thtg2)
	e1:SetOperation(c10150065.thop2)
	c:RegisterEffect(e1)
end
function c10150065.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xd3)
end
function c10150065.thfilter(c)
	return c:IsSetCard(0xd3) and c:IsFaceup() and c:IsAbleToHand()
end
function c10150065.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10150065.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10150065.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and c:IsAbleToExtra() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c10150065.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
end
function c10150065.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_EXTRA) and tc:IsRelateToEffect(e) then
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c10150065.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x37,1,REASON_COST) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.RemoveCounter(tp,1,1,0x37,1,REASON_COST)
end
function c10150065.thfilter2(c)
	return c:IsSetCard(0xd3) and c:IsAbleToHand()
end
function c10150065.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10150065.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10150065.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10150065.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
