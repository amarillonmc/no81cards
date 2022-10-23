local m=53737011
local cm=_G["c"..m]
cm.name="异赤伤痕"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.drcost)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.hfcon)
	e2:SetTarget(cm.hftg)
	e2:SetOperation(cm.hfop)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(cm.accon1)
	e3:SetCost(cm.drcost2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e4:SetCondition(cm.accon2)
	e4:SetCost(cm.cost)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetTargetRange(1,1)
	e5:SetLabelObject(e3)
	e5:SetTarget(function(e,te,tp)return te==e:GetLabelObject()end)
	e5:SetOperation(cm.costop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetLabelObject(e4)
	c:RegisterEffect(e6)
end
function cm.costfilter(c)
	return c:IsSetCard(0x6531) and c:IsDiscardable()
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c,exc=e:GetHandler(),nil
	if c:IsLocation(LOCATION_HAND) then exc=c end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,exc) end
	Duel.DiscardHand(tp,cm.costfilter,1,1,REASON_DISCARD+REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function cm.hfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 and Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,6,nil)
end
function cm.hftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.hfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	Duel.BreakEffect()
	Duel.Recover(tp,Duel.GetLP(1-tp),REASON_EFFECT)
end
function cm.accon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function cm.accon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 and Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,6,nil)
end
function cm.drcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c,exc=e:GetHandler(),nil
	if c:IsLocation(LOCATION_HAND) then exc=c end
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,3,REASON_COST) and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,exc) end
	Duel.RemoveCounter(tp,1,0,0x1,3,REASON_COST)
	Duel.DiscardHand(tp,cm.costfilter,1,1,REASON_DISCARD+REASON_COST)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,3,REASON_COST)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabelObject(te)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return re==e:GetLabelObject() end)
	e1:SetOperation(cm.ready)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetOperation(cm.rsop)
	Duel.RegisterEffect(e2,tp)
end
function cm.ready(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():GetHandler():SetStatus(STATUS_EFFECT_ENABLED,true)
	e:Reset()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():GetHandler():SetStatus(STATUS_ACTIVATE_DISABLED,true)
	e:Reset()
end
