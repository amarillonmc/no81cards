--梦寂
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400056,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,71400056)
	e1:SetCondition(c71400056.con1)
	e1:SetCost(c71400056.cost1)
	e1:SetTarget(c71400056.tg1)
	e1:SetOperation(c71400056.op1)
	c:RegisterEffect(e1)
	--ac in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(yume.nonYumeCon)
	c:RegisterEffect(e0)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400056,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_SUMMON+TIMING_SPSUMMON+TIMING_END_PHASE)
	e2:SetCondition(c71400056.con2)
	e2:SetCost(c71400056.cost2)
	e2:SetTarget(c71400056.tg2)
	e2:SetOperation(c71400056.op2)
	c:RegisterEffect(e2)
end
function c71400056.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev)
end
function c71400056.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	if chk==0 then
		if c:IsLocation(LOCATION_ONFIELD) and c:IsFacedown() then
			return yume.YumeFieldCheck(tp,0,0,LOCATION_HAND+LOCATION_GRAVE) and Duel.IsPlayerCanDiscardDeck(tp,3)
		else
			return yume.YumeFieldCheck(tp,0,0,LOCATION_HAND+LOCATION_GRAVE)
		end
	end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		e:SetCategory(CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	else
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_DECKDES)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
	end
end
function c71400056.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	if yume.ActivateYumeField(e,tp,0,0,LOCATION_HAND+LOCATION_GRAVE) and not e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.DiscardDeck(tp,3,REASON_EFFECT)
	end
end
function c71400056.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c71400056.con2(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and yume.YumeCon(e,tp)
end
function c71400056.filter2c(c)
	return c:IsSetCard(0x714) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost()
end
function c71400056.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400056.filter2c,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_SZONE,0,2,nil) and e:GetHandler():IsAbleToRemoveAsCost() and Duel.CheckLPCost(tp,800) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	local g=Duel.SelectMatchingCard(tp,c71400056.filter2c,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_SZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.PayLPCost(tp,800)
end
function c71400056.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c71400056.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end