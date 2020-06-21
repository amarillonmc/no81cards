--罗德岛·辅助干员-格劳克斯
function c79029124.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c79029124.mfilter,c79029124.xyzcheck,2,99)   
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c79029124.effcon)
	e1:SetValue(c79029124.atkval)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15240238,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c79029124.effcon)
	e2:SetLabel(2)
	e2:SetTarget(c79029124.target)
	e2:SetOperation(c79029124.operation)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetCondition(c79029124.effcon)
	e3:SetLabel(2)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029124.effcon)
	e3:SetLabel(3)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--limit
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(11760174,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1)
	e4:SetCondition(c79029124.effcon)  
	e4:SetLabel(4)
	e4:SetCost(c79029124.actcost)
	e4:SetOperation(c79029124.actop)
	c:RegisterEffect(e4)
	--overlay
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCondition(c79029124.effcon1)
	e5:SetCountLimit(1)
	e5:SetCost(c79029124.cost)
	e5:SetOperation(c79029124.ovop)
	c:RegisterEffect(e5)
end
function c79029124.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ)
end
function c79029124.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c79029124.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c79029124.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function c79029124.effcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()<=4 and tp~=Duel.GetTurnPlayer()
end
function c79029124.filter(c)
	return c:IsFaceup()
end
function c79029124.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c79029124.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029124.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c79029124.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c79029124.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		Debug.Message("坠落吧！")
end
end
function c79029124.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,4,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,4,4,REASON_COST)
end
function c79029124.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Debug.Message("满功率输出！")
end
function c79029124.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,3,REASON_COST)
end
function c79029124.ovop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local x=a:RandomSelect(tp,1)
	Duel.Overlay(e:GetHandler(),x)
	Debug.Message("这次能捡到什么有趣的东西呢？")
end 



















