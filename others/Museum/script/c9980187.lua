--刻刻帝女神 八之弹·Het
function c9980187.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6bc8),4,2)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9980187.atkcon)
	e1:SetValue(c9980187.atkval)
	c:RegisterEffect(e1)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetDescription(aux.Stringid(9980187,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,9980187)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c9980187.spcost)
	e1:SetOperation(c9980187.spop)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,99801870)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9980187.atktg)
	e1:SetOperation(c9980187.atkop)
	c:RegisterEffect(e1)
end
function c9980187.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9980187.atkfilter(c,ec)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(ec)
end
function c9980187.atkval(e,c)
	local g=Duel.GetMatchingGroup(c9980187.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	return g:GetSum(Card.GetLink)*300
end
function c9980187.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9980187.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9980195,0x6bc8,0x4011,1300,1300,4,RACE_FAIRY,ATTRIBUTE_DARK) then 
	Duel.BreakEffect()
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		repeat
			local token=Duel.CreateToken(tp,9980195)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		token:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
		ft=ft-1
		until ft==0 or not Duel.SelectYesNo(tp,210)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980187,0))
end
function c9980187.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9980187.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1300)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		tc:RegisterEffect(e4)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980187,0))
end