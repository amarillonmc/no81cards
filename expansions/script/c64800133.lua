--万人要求的海盗狗
function c64800133.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetOperation(c64800133.op)
	c:RegisterEffect(e1)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,64800133)
	e3:SetCost(c64800133.ccost)
	e3:SetTarget(c64800133.ctg)
	e3:SetOperation(c64800133.cop)
	c:RegisterEffect(e3)
end

--e1
function c64800133.atkfilter(c)
	return not c:IsAttack(0) and not c:IsCode(64800133)
end
function c64800133.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) then return end
	local g=Duel.GetMatchingGroup(c64800133.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if g:GetCount()>0 then 
		local tg=g:GetMaxGroup(Card.GetAttack)
		for tc in aux.Next(tg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end

--e3
function c64800133.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c64800133.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c64800133.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c64800133.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c64800133.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c64800133.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c64800133.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:IsControlerCanBeChanged() then
		if Duel.GetTurnPlayer()==tp then
			if Duel.GetControl(tc,tp,PHASE_END,1) and tc:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_RACE)
				e1:SetValue(RACE_BEASTWARRIOR)
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
				tc:RegisterEffect(e1)
			end
		else		   
			if Duel.GetControl(tc,tp,PHASE_END,2) and tc:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_RACE)
				e1:SetValue(RACE_BEASTWARRIOR)
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
				tc:RegisterEffect(e1)
			end
		end
	end
end
