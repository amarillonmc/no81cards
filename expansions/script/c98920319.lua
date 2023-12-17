--闪刀姬-灼乌
function c98920319.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,63288573,aux.FilterBoolFunction(c98920319.fusfilter),1,true,true)
	aux.AddContactFusionProcedure(c,c98920319.cfilter,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	Duel.AddCustomActivityCounter(98920319,ACTIVITY_CHAIN,c98920319.chainfilter)
	 --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c98920319.splimit)
	c:RegisterEffect(e1)
	--cannot link material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4:SetCondition(c98920319.linkcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(-1500)
	c:RegisterEffect(e2)
	local e3=Effect.Clone(e2)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--attack all
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_ALL)
	e5:SetValue(c98920319.atkfilter)
	c:RegisterEffect(e5)
end
function c98920319.linkcon(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c98920319.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c98920319.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0x115) and re:IsActiveType(TYPE_SPELL))
end
function c98920319.fusfilter(c)
	 return c:IsSetCard(0x1115) and not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c98920319.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c98920319.cfilter(c,fc)
	local tp=fc:GetControler()
	return c:IsAbleToRemoveAsCost() and (Duel.GetCustomActivityCount(98920319,tp,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(98920319,1-tp,ACTIVITY_CHAIN)~=0) 
end
function c98920319.atkfilter(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end