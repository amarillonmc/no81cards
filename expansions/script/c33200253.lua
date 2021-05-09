--机略纵横 荀文若
function c33200253.initial_effect(c)
	c:SetUniqueOnField(1,1,33200253)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(3,33200250+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33200253.target)
	e1:SetOperation(c33200253.activate)
	c:RegisterEffect(e1)	 
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200253,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c33200253.tdtg)
	e2:SetOperation(c33200253.tdop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200253,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c33200253.descon)
	e3:SetTarget(c33200253.destg)
	e3:SetOperation(c33200253.desop)
	c:RegisterEffect(e3)
end

--e1
function c33200253.cfilter(c)
	return c:GetSequence()<5
end
function c33200253.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33200250,0,0x4011,1000,1000,2,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33200253.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,33200253,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,33200250,0,0x4011,1000,1000,2,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK) then return end
	local token=Duel.CreateToken(tp,33200250)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33200253.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33200253.splimit(e,c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WARRIOR)) and c:IsLocation(LOCATION_EXTRA)
end

--e2
function c33200253.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x326) and c:IsAbleToDeck()
end
function c33200253.thfilter(c,code)
	return c:IsSetCard(0x326) and c:IsAbleToHand() and not c:IsCode(code)
end
function c33200253.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c33200253.tdfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c33200253.tdfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c33200253.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetFirstTarget()
	local code=g1:GetCode()
	if Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(c33200253.thfilter,tp,LOCATION_DECK,0,1,nil,code) and Duel.SelectYesNo(tp,aux.Stringid(33200253,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,c33200253.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	end
end

--e3
function c33200253.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33200253)==0
end
function c33200253.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33200253.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.Destroy(c,REASON_EFFECT) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c33200253.aclimit)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c33200253.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(33200253)
end