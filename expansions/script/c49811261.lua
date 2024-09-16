--朱罗纪隐存种
function c49811261.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,49811261+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c49811261.cost)
	e1:SetTarget(c49811261.target)
	e1:SetOperation(c49811261.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c49811261.actcon)
	c:RegisterEffect(e2)
	--decrease atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c49811261.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function c49811261.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c49811261.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,49811261,0x22,TYPES_EFFECT_TRAP_MONSTER+TYPE_TUNER,1700,200,4,RACE_DINOSAUR,ATTRIBUTE_FIRE) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49811261.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,49811261,0x22,TYPES_EFFECT_TRAP_MONSTER+TYPE_TUNER,1700,200,4,RACE_DINOSAUR,ATTRIBUTE_FIRE) then
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TUNER)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c49811261.indtg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
end
function c49811261.indtg(e,c)
	return c:IsSetCard(0x22)
end
function c49811261.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_DINOSAUR)
end
function c49811261.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsRace,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,RACE_DINOSAUR)
		and not Duel.IsExistingMatchingCard(c49811261.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c49811261.atkfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_MZONE+LOCATION_REMOVED) and c:IsFaceup()))
		and c:IsSetCard(0x22) and c:IsType(TYPE_MONSTER)
end
function c49811261.atkval(e,c)
	return Duel.GetMatchingGroupCount(c49811261.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*-100
end