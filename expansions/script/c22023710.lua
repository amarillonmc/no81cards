--人理之基 美杜莎·战争女神
function c22023710.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcCodeFun(c,22020320,c22023710.mfilter,1,true,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023710,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22023710)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c22023710.settg)
	e1:SetOperation(c22023710.setop)
	c:RegisterEffect(e1)
	--position ere
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023710,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22023710)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c22023710.erecon)
	e2:SetCost(c22023710.erecost)
	e2:SetTarget(c22023710.settg)
	e2:SetOperation(c22023710.setop)
	c:RegisterEffect(e2)
	--3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c22023710.con3)
	c:RegisterEffect(e3)
	--6
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(c22021830.con6)
	e4:SetTargetRange(0,1)
	c:RegisterEffect(e4)
	--6
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(c22021830.con6)
	e5:SetTargetRange(0,1)
	c:RegisterEffect(e5)
	--9
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetTargetRange(0,1)
	e6:SetCondition(c22021830.con9)
	e6:SetValue(c22021830.aclimit)
	c:RegisterEffect(e6)
end
function c22023710.mfilter(c)
	return c:IsLevelAbove(5) and c:IsCode(0xff1)
end
function c22023710.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c22023710.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22023710.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22023710.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c22023710.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c22023710.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c22023710.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023710.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22023710.cfilter(c)
	return c:IsFacedown()
end
function c22023710.con3(e)
	return Duel.GetFieldGroupCount(c22020370.cfilter,tp,0,LOCATION_ONFIELD,nil)>=3
end
function c22023710.con6(e)
	return Duel.GetFieldGroupCount(c22020370.cfilter,tp,0,LOCATION_ONFIELD,nil)>=6
end
function c22023710.con9(e)
	return Duel.GetFieldGroupCount(c22020370.cfilter,tp,0,LOCATION_ONFIELD,nil)>=9
end
function c22023710.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end