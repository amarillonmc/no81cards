--闪刀姬-潮涡
function c98920320.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,90673288,aux.FilterBoolFunction(c98920320.fusfilter),1,true,true)
	aux.AddContactFusionProcedure(c,c98920320.cfilter,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	Duel.AddCustomActivityCounter(98920320,ACTIVITY_CHAIN,c98920320.chainfilter)
	 --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c98920320.splimit)
	c:RegisterEffect(e1)
	--cannot link material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4:SetCondition(c98920320.linkcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--atk update
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c98920320.atkval)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920320,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCountLimit(1)
	e3:SetCondition(c98920320.reccon)
	e3:SetTarget(c98920320.rectg)
	e3:SetOperation(c98920320.recop)
	c:RegisterEffect(e3)
end
function c98920320.linkcon(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c98920320.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c98920320.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0x115) and re:IsActiveType(TYPE_SPELL))
end
function c98920320.fusfilter(c)
	 return c:IsSetCard(0x1115) and not c:IsAttribute(ATTRIBUTE_WATER)
end
function c98920320.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c98920320.cfilter(c,fc)
	local tp=fc:GetControler()
	return c:IsAbleToRemoveAsCost() and (Duel.GetCustomActivityCount(98920320,tp,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(98920320,1-tp,ACTIVITY_CHAIN)~=0) 
end
function c98920320.atkval(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end
function c98920320.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsSetCard(0x1115)
end
function c98920320.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c98920320.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end