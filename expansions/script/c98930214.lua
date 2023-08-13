--萝卜-Romance 传奇
function c98930214.initial_effect(c)
	c:SetUniqueOnField(1,0,98930214)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--decrease atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c98930214.atkval)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
   --Cannot Become Target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c98930214.immtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c98930214.atkfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER)
end
function c98930214.atkval(e,c)
	local g=Duel.GetMatchingGroup(c98930214.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)*-400
end
function c98930214.immtg(e,c)
	return c:IsSetCard(0xad2) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
