--忍鬼 时常
function c40009271.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--setcode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetValue(0x61)
	c:RegisterEffect(e1) 
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009271,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c40009271.xyzcon)
	e3:SetCountLimit(1,40009271)
	e3:SetTarget(c40009271.sptg)
	e3:SetOperation(c40009271.spop)
	c:RegisterEffect(e3)	
end
function c40009271.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c40009271.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,40009272,0,0x4011,00,0,1,RACE_PLANT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c40009271.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,40009272,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,40009272)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end