--星辉末裔 米雷斯托
function c33200957.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200957,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33200957.sctg)
	e1:SetOperation(c33200957.scop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200957,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,33200957)
	e2:SetTarget(c33200957.tdtg)
	e2:SetOperation(c33200957.tdop)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200957,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,33210957)
	e3:SetCondition(c33200957.pencon)
	e3:SetTarget(c33200957.pentg)
	e3:SetOperation(c33200957.penop)
	c:RegisterEffect(e3)
end

--e1
function c33200957.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 and e:GetHandler():GetRightScale()<13 end
end
function c33200957.dspfilter(c)
	return c:IsSetCard(0x632a)
end
function c33200957.scop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 or e:GetHandler():GetRightScale()>=13 then return end
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local dc=g:FilterCount(c33200957.dspfilter,nil)*2
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
function c33200957.tdfilter(c)
	return c:IsSetCard(0x632a) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToDeck()
end
function c33200957.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200957.tdfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_EXTRA)
end
function c33200957.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c33200957.tdfilter,tp,LOCATION_EXTRA,0,1,nil) then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c33200957.tdfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	local atk=math.floor(tc:GetBaseAttack()/2)
	if tc then
		if Duel.SendtoDeck(g,nil,0,REASON_EFFECT) then
			--atk up
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x632a))
			e1:SetValue(atk)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

--e3
function c33200957.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c33200957.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler()) end
end
function c33200957.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_PZONE,0,1,e:GetHandler()) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		local tdg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_PZONE,0,e:GetHandler())
		if tdg:GetCount()>0 then 
			Duel.SendtoDeck(tdg,tp,0,REASON_EFFECT)
		end
	end
end