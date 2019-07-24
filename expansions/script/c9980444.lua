--降临卡片·抢夺降临
function c9980444.initial_effect(c)
	 --act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c9980444.handcon)
	c:RegisterEffect(e2)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,99804440)
	e1:SetCondition(c9980444.condition)
	e1:SetCost(c9980444.cost)
	e1:SetTarget(c9980444.target)
	e1:SetOperation(c9980444.activate)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,9980444)
	e1:SetCondition(c9980444.ctcon)
	e1:SetTarget(c9980444.target)
	e1:SetOperation(c9980444.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980444,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c9980444.tdcon)
	e2:SetTarget(c9980444.tdtg)
	e2:SetOperation(c9980444.tdop)
	c:RegisterEffect(e2)
end
function c9980444.handfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bca)
end
function c9980444.handcon(e)
	return Duel.IsExistingMatchingCard(c9980444.handfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c9980444.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_REVEAL) 
end
function c9980444.cfilter(c)
	return c:IsFaceup() and (c:IsRace(RACE_WARRIOR) or c:IsSetCard(0x1bca))
end
function c9980444.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9980444.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9980444.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9980444.geffilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bca)
end
function c9980444.filter(c,tp)
	return (Duel.IsExistingMatchingCard(c9980444.geffilter,tp,LOCATION_ONFIELD,0,1,nil)
		or (c:IsFaceup() and c:IsType(TYPE_LINK))) and c:IsControlerCanBeChanged()
end
function c9980444.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c9980444.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9980444.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c9980444.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c9980444.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(200)
	e1:SetTarget(c9980444.tg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function c9980444.tg(e,c)
	return c:IsSetCard(0x6bca)
end
function c9980444.rccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bca)
end
function c9980444.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.IsExistingMatchingCard(c9980444.rccfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c9980444.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c9980444.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end