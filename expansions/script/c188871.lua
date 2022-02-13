local m=188871
local cm=_G["c"..m]
cm.name="祷告之神意"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcac))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UPDATE_LEVEL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_SZONE)
	e6:SetOperation(cm.chainop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,0))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCountLimit(1,m)
	e7:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetTurnPlayer()==tp end)
	e7:SetCost(cm.tfcost)
	e7:SetTarget(cm.tftg)
	e7:SetOperation(cm.tfop)
	c:RegisterEffect(e7)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_GRAVE and re:GetHandler():IsSetCard(0xcac) then Duel.SetChainLimit(function(e,rp,tp)return tp==rp or not e:GetHandler():IsType(TYPE_MONSTER)end) end
end
function cm.tdfilter(c)
	return c:IsSetCard(0xcac) and c:IsAbleToDeckAsCost() and c:IsFaceup()
end
function cm.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,1,99,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcac))
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
