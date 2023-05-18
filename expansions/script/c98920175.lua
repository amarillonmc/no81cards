--天空之神圣骑士 卡珀耳修斯
function c98920175.initial_effect(c)
	aux.AddCodeList(c,56433456)
	c:SetSPSummonOnce(98920175)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x10a),aux.FilterBoolFunction(Card.IsSummonLocation,LOCATION_EXTRA),2,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c98920175.sprcon)
	e2:SetOperation(c98920175.sprop)
	c:RegisterEffect(e2)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98920175.imcon)
	e1:SetValue(c98920175.efilter)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920175,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c98920175.condition)
	e1:SetTarget(c98920175.target)
	e1:SetOperation(c98920175.operation)
	c:RegisterEffect(e1)
end
function c98920175.sprcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c98920175.srfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c)
	return Duel.IsEnvironment(56433456) and c:CheckFusionMaterial(mg,nil,tp|0x200)
end
function c98920175.srfilter(c,sc)
	return c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c98920175.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c98920175.srfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c)
	local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|0x200)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98920175.imcon(e)
	return e:GetHandler():GetSequence()>4
end
function c98920175.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c98920175.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c98920175.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98920175.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end