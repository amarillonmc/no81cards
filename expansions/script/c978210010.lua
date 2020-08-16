--多元闪刀机-大黄蜂浮游单元
function c978210010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c978210010.condition)
	e1:SetTarget(c978210010.target)
	e1:SetOperation(c978210010.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e3)
end
function c978210010.cfilter(c)
	return c:GetSequence()<5
end
function c978210010.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c978210010.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c978210010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=0
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
		atk=1500
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,978210026,0,0x4011,atk,atk,1,RACE_WARRIOR,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c978210010.activate(e,tp,eg,ep,ev,re,r,rp)
	local atk=0
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
		atk=1500
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,978210026,0,0x4011,atk,atk,1,RACE_WARRIOR,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) then return end
	local token=Duel.CreateToken(tp,978210026)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		token:RegisterEffect(e2)
		if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK)
			e3:SetValue(1500)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_SET_DEFENSE)
			token:RegisterEffect(e4)
		end
	end
	Duel.SpecialSummonComplete()
end