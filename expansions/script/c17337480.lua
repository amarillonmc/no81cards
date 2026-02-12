--半魔的公主 艾米莉亚
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337400,17337402,17337404,17337435) 
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,s.matfilter1,s.matfilter2,true)
	aux.AddContactFusionProcedure(c,s.cfilter,LOCATION_HAND+LOCATION_MZONE,0,aux.ContactFusionSendToDeck(c))

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.disptg)
	e2:SetOperation(s.dispop)
	c:RegisterEffect(e2)
end

function s.matfilter1(c)
	return c:IsFusionCode(17337402)
end
function s.matfilter2(c)
	return c:IsFusionCode(17337400,17337404)
end
function s.cfilter(c)
	return (s.matfilter1(c) or s.matfilter2(c)) and c:IsAbleToDeckOrExtraAsCost()
end

function s.thfilter(c,typ)
	return c:IsSetCard(0x3f50) and c:IsType(typ) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and chkc:IsSetCard(0x3f50) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,nil,0x3f50) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,1,nil,0x3f50)
	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e)) then return end

	local typ=tc:GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,typ)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.disptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	
	 Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	 Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	 Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.dispop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end

	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)

	if Duel.Destroy(tc,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,17337435,0,TYPE_TOKEN+TYPE_MONSTER,1000,1000,1,RACE_AQUA,ATTRIBUTE_WATER)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,17337435)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end