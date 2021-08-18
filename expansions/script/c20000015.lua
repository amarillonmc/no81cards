--极密合约仲介
function c20000015.initial_effect(c)
	aux.AddXyzProcedure(c,c20000015.xyzf,4,2)
	c:EnableReviveLimit()
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c20000015.con2)
	e2:SetOperation(c20000015.op2)
	c:RegisterEffect(e2)
	--xyz success
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20000015,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c20000015.tg3)
	e3:SetOperation(c20000015.op3)
	c:RegisterEffect(e3)
	--give
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,20000015)
	e4:SetCondition(c20000015.con4)
	e4:SetCost(c20000015.co4)
	e4:SetTarget(c20000015.tg4)
	e4:SetOperation(c20000015.op4)
	c:RegisterEffect(e4)
	--todeck
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c20000015.co5)
	e5:SetTarget(c20000015.tg5)
	e5:SetOperation(c20000015.op5)
	c:RegisterEffect(e5)
end
--xyz
function c20000015.xyzf(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK)
end
--e2
function c20000015.conf2(c)
	return ((c:IsSetCard(0x5fd1) and c:IsFaceup()) or c:IsFacedown()) and c:IsAbleToDeckOrExtraAsCost()
end
function c20000015.con2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c20000015.conf2,tp,LOCATION_ONFIELD,0,3,nil,c)
end
function c20000015.op2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c20000015.conf2,tp,LOCATION_ONFIELD,0,3,3,nil,c)
	c:SetMaterial(g1)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
--e3
function c20000015.tgf3(c)
	return c:IsCode(20000000) and c:IsAbleToGrave()
end
function c20000015.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20000015.tgf3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c20000015.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c20000015.tgf3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--e4
function c20000015.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c20000015.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20000015)==0 end
	Duel.RegisterFlagEffect(tp,20000015,RESET_CHAIN,0,1)
end
function c20000015.tgf4(c)
	return c:IsCode(20000000) and c:IsFaceup() and c:GetFlagEffect(20000015)==0
end
function c20000015.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c20000015.tgf4(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20000015.tgf4,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c20000015.tgf4,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c20000015.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(20000015,2))
		e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetTarget(c20000015.optg4)
		e1:SetOperation(c20000015.opop4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(20000015,1))
end
function c20000015.optgf4(c)
	return c:IsSetCard(0x3fd1) and (c:IsAbleToExtra() or c:IsAbleToDeck())
end
function c20000015.optgf41(c)
	return (c:IsCode(20000003) or c:IsCode(20000004)) and c:IsAbleToHand()
end
function c20000015.optg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c20000015.optgf4,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c20000015.optgf41,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c20000015.optgf4,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH,g,1,tp,LOCATION_DECK)
end
function c20000015.opop4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20000015.optgf41,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
end
--e5
function c20000015.cof5(c)
	return c:IsSetCard(0x5fd1) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeckOrExtraAsCost()
end
function c20000015.co5(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c20000015.cof5,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=8 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	aux.GCheckAdditional=aux.dncheck
	local rg=g:SelectSubGroup(tp,aux.TRUE,false,8,8)
	aux.GCheckAdditional=nil
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c20000015.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c20000015.op5(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
