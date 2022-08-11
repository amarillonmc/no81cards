--星辉末裔 阿尔梅瑞亚斯
function c33200958.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200958,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33200958.sctg)
	e1:SetOperation(c33200958.scop)
	c:RegisterEffect(e1)
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200958,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,33200958)
	e2:SetTarget(c33200958.thtg)
	e2:SetOperation(c33200958.thop)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200958,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,33210958)
	e3:SetCondition(c33200958.pencon)
	e3:SetTarget(c33200958.pentg)
	e3:SetOperation(c33200958.penop)
	c:RegisterEffect(e3)
end

--e1
function c33200958.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 and e:GetHandler():GetRightScale()<13 end
end
function c33200958.dspfilter(c)
	return c:IsSetCard(0x632a)
end
function c33200958.scop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 or e:GetHandler():GetRightScale()>=13 then return end
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local dc=g:FilterCount(c33200958.dspfilter,nil)*2
	local csc=13-c:GetRightScale()
	if dc>=csc then
		dc=csc
	end
	if dc>0 and c:IsLocation(LOCATION_PZONE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(dc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		c:RegisterEffect(e2)
	end
end

--e2
function c33200958.thfilter(c)
	return c:IsSetCard(0x632a) and c:IsAbleToHand() and not c:IsCode(33200958)
end
function c33200958.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200958.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_DECK,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c33200958.thop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(c33200958.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,e:GetHandler())) then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local thg=Duel.SelectMatchingCard(tp,c33200958.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local thc=thg:GetFirst()
	if thc then
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(thc,tp,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,thc)
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local tdg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,1,nil)
				Duel.SendtoDeck(tdg,nil,0,REASON_EFFECT)
				--atk up
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(500)
				e1:SetReset(RESET_EVENT+0xff0000)
				c:RegisterEffect(e1)
			end
		end
	end
end

--e3
function c33200958.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c33200958.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler()) end
end
function c33200958.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_PZONE,0,1,e:GetHandler()) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		local tdg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_PZONE,0,e:GetHandler())
		if tdg:GetCount()>0 then 
			Duel.SendtoDeck(tdg,tp,0,REASON_EFFECT)
		end
	end
end