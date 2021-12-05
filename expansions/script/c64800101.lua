--神代丰的铁骑 胜利光辉
function c64800101.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c64800101.ffilter,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),true)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c64800101.upcon)
	e1:SetOperation(c64800101.upop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,64800101)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c64800101.con)
	e2:SetTarget(c64800101.target)
	e2:SetOperation(c64800101.activate)
	c:RegisterEffect(e2)
end

--fusion
function c64800101.ffilter(c)
	return c:IsFusionSetCard(0x641a) and c:IsFusionType(TYPE_EFFECT)
end

--e1
function c64800101.upcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c64800101.upop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(800)
		c:RegisterEffect(e1)
	end
end

--e2
function c64800101.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(64800101)==0 and Duel.IsExistingMatchingCard(c64800101.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c64800101.cfilter(c)
	return c:IsSetCard(0x641a) and (c:IsAbleToGrave() or c:IsAbleToHand())
end
function c64800101.cfilter2(c)
	return c:IsType(TYPE_EQUIP)
end
function c64800101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64800101.cfilter,tp,LOCATION_DECK,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(64800101,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,nil,0,aux.Stringid(64800101,0))
end
function c64800101.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c64800101.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		if Duel.SendtoGrave(tc,REASON_EFFECT) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(64800101,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
