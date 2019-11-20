--AST 冈峰美纪惠 仰慕
function c33400426.initial_effect(c)
	--link summon
	 aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WARRIOR),2,2,c33400426.lcheck)
	c:EnableReviveLimit()
  --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400426,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,33400426)
	e1:SetCondition(c33400426.thcon)
	e1:SetTarget(c33400426.thtg)
	e1:SetOperation(c33400426.thop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetCondition(c33400426.thcon2)
	e3:SetTarget(c33400426.thtg2)
	c:RegisterEffect(e3)
   --set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400426,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33400426+10000)
	e2:SetTarget(c33400426.settg)
	e2:SetOperation(c33400426.setop)
	c:RegisterEffect(e2)
end
function c33400426.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x9343) 
end
function c33400420.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400420.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400420.ccfilter(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
   (Duel.IsExistingMatchingCard(c33400420.cccfilter1,tp,LOCATION_ONFIELD,0,1,nil) or 
	Duel.IsExistingMatchingCard(c33400420.cccfilter2,tp,LOCATION_MZONE,0,1,nil) 
	)
end
function c33400426.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and not (not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x341) or c33400420.ccfilter(e,tp,eg,ep,ev,re,r,rp))
end
function c33400426.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x341) or  c33400420.ccfilter(e,tp,eg,ep,ev,re,r,rp)
 
end
function c33400426.thfilter(c)
	return (c:IsSetCard(0x5342) or c:IsSetCard(0x9343)) and c:IsAbleToDeck()
end
function c33400426.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33400426.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400426.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c33400426.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,HINTMSG_TODECK,g,1,0,0)
end
function c33400426.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33400426.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400426.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c33400426.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,HINTMSG_TODECK,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c33400426.thfilter2(c,code)
	return c:IsSetCard(0x9343)  and not c:IsCode(code) and c:IsAbleToHand()
end
function c33400426.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) and Duel.IsExistingTarget(c33400426.thfilter2,tp,LOCATION_DECK,0,1,nil,tc:GetCode())then
		if Duel.SelectYesNo(tp,aux.Stringid(33400426,0)) then 
			 Duel.BreakEffect()
			 local g=Duel.SelectMatchingCard(tp,c33400426.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
			 if g:GetCount()>0 then
				Duel.SendtoHand(g,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)			
			 end
		end
	end
end

function c33400426.setfilter1(c,tp)
	return c:IsFaceup()  and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsExistingMatchingCard(c33400426.setfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c33400426.setfilter2(c,code)
	return c:IsSetCard(0x9343) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(code) and c:IsSSetable()
end
function c33400426.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c33400426.setfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33400426.setfilter1,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33400426.setfilter1,tp,LOCATION_SZONE,0,1,1,nil,tp)
end
function c33400426.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c33400426.setfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if g:GetCount()>0 then
			local tc1=g:GetFirst()
			Duel.SSet(tp,tc1)
			Duel.ConfirmCards(1-tp,g)
			if  (Duel.IsExistingMatchingCard(c33400426.spcfilter,tp,0,LOCATION_MZONE,1,nil) and 
			not Duel.IsExistingMatchingCard(c33400426.spcfilter,tp,LOCATION_MZONE,0,1,nil))
			or
			(not Duel.IsExistingMatchingCard(c33400426.spcfilter,tp,LOCATION_MZONE,0,1,nil) and
			Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
				(Duel.IsExistingMatchingCard(c33400426.cccfilter1,tp,LOCATION_SZONE,0,1,nil) or 
				Duel.IsExistingMatchingCard(c33400426.cccfilter2,tp,LOCATION_MZONE,0,1,nil) 
				)
			)
			then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc1:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc1:RegisterEffect(e2)
			end
	   end
	end
end
function c33400426.spcfilter(c)
	return c:IsSetCard(0x341) and c:IsFaceup()
end
function c33400426.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400426.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end