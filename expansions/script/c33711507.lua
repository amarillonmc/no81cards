--水晶魔法小妖精 艾尼斯
local m=33711507
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate from your hand or Mzone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66570171,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1) 
	--to deck reverse()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.lpcon)
	e2:SetOperation(cm.lpop)
	c:RegisterEffect(e2)
	--Damage Plus
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_DECK)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.damcon)
	e3:SetValue(cm.val)
	c:RegisterEffect(e3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.con(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>5
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetOperation(cm.operation)
	Duel.RegisterEffect(e1,tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local d1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local d2=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)
	if d1>d2 then
		Duel.Recover(tp,1200,REASON_EFFECT)
	elseif d1<d2 then
		Duel.Damage(1-tp,600,REASON_EFFECT)
	else
		Duel.SetLP(tp,Duel.GetLP(tp)*2)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)*2)
	end
end
function cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)>0 and c:IsAbleToDeck()
end
function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(c,tp,0,REASON_EFFECT)
		c:ReverseInDeck()
	end
end
function cm.damcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetDecktopGroup(tp,1)
	return g:IsContains(e:GetHandler()) and c:IsFaceup()
end
function cm.val(e)
	return dam*2
end