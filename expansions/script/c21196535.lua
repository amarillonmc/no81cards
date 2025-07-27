--超龙机兵 灰黯之手
local m=21196535
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not cm._ then
		cm._=true
		cm_remove_limit_botton=true
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_ADJUST)
		e0:SetRange(0xff)
		e0:SetCountLimit(1)
		e0:SetOperation(cm.op0)
		c:RegisterEffect(e0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.q(c)
	return c:GetOriginalCode()==m and not c:IsForbidden()
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	for p = 0,1 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(cm.op0_con)
		e1:SetOperation(cm.op0_op)
		Duel.RegisterEffect(e1,p)
	end
	e:Reset()
end
function cm.op0_con(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetLocationCount(tp,4)>0 and Duel.IsExistingMatchingCard(cm.q,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY,0,1,nil)
end
function cm.op0_op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,0)) then
		local x=Duel.GetLocationCount(tp,4)
		local g=Duel.SelectMatchingCard(tp,cm.q,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY,0,1,x,nil)
		for tc in aux.Next(g) do
			Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
			Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		end
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=10000 and e:GetHandler():IsAbleToGrave()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<10000
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp*2)
end