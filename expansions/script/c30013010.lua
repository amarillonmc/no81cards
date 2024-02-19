--深土之物 塔里克丝巨蛭
local m=30013010
local cm=_G["c"..m]  
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Effect 1
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.fpcon)
	e4:SetCost(cm.fpcost)
	e4:SetTarget(cm.fptg)
	e4:SetOperation(cm.fpop)
	c:RegisterEffect(e4)
	--Effect 2 
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e32:SetCode(EVENT_FLIP)
	e32:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e32:SetOperation(cm.flipop)
	c:RegisterEffect(e32)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FLIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCondition(cm.flipcon1)
	e1:SetOperation(cm.flipop1)
	c:RegisterEffect(e1)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_FLIP)
	e11:SetRange(LOCATION_MZONE)
	e11:SetProperty(EFFECT_FLAG_DELAY) 
	e11:SetCondition(cm.flipcon2)
	e11:SetOperation(cm.flipop2)
	c:RegisterEffect(e11)
	--Effect 3
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
	e12:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetCountLimit(1,m+100)
	e12:SetCondition(cm.thcon1)
	e12:SetCost(cm.thcost)
	e12:SetTarget(cm.thtg)
	e12:SetOperation(cm.thop)
	c:RegisterEffect(e12)
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
	e32:SetType(EFFECT_TYPE_QUICK_O)
	e32:SetCode(EVENT_FREE_CHAIN)
	e32:SetRange(LOCATION_GRAVE)
	e32:SetCountLimit(1,m+100)
	e32:SetCondition(cm.thcon2)
	e32:SetCost(cm.thcost)
	e32:SetTarget(cm.thtg)
	e32:SetOperation(cm.thop)
	c:RegisterEffect(e32)
end
--Effect 1
function cm.fpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.fpcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_FLIP)
end
function cm.fptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.fpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--Effect 2
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.flipcon5)
	e2:SetOperation(cm.flipop5)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.flipcon5(e)
	local c=e:GetHandler()
	local tsp=c:GetControler()
	local ct=Duel.GetFlagEffect(tsp,m+100)
	return ct>0
end
function cm.flipop5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tsp=c:GetControler()
	local ct=Duel.GetFlagEffect(tsp,m+100)
	if not c:IsDisabled() and Duel.IsPlayerCanDraw(tsp,1) and ct>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Draw(tsp,ct,REASON_EFFECT)
	end 
end
function cm.flipcon1(e)
	local c=e:GetHandler()
	local tsp=c:GetControler()
	return c:GetFlagEffect(m)>0 and not Duel.IsPlayerAffectedByEffect(tsp,30013020) 
end
function cm.flipop1(e,tp,eg,ep,ev,re,r,rp)
	local tsp=e:GetHandlerPlayer()
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tsp,m+100,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function cm.flipcon2(e)
	local c=e:GetHandler()
	local tsp=c:GetControler()
	return c:GetFlagEffect(m)>0 and Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.flipop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tsp=e:GetHandlerPlayer()
	local tc=eg:GetFirst()
	while tc do
		if not c:IsDisabled() and Duel.IsPlayerCanDraw(tsp,1) then
			Duel.Hint(HINT_CARD,0,m)
			Duel.Draw(tsp,1,REASON_EFFECT)
		end
		tc=eg:GetNext()
	end
end
--Effect 3 
function cm.thcon1(e)
	local tsp=e:GetHandler():GetControler()
	return not Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.thcon2(e)
	local tsp=e:GetHandler():GetControler()
	return Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.pos(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_FLIP) and c:IsCanTurnSet()
		and Duel.IsExistingMatchingCard(cm.tog,tp,LOCATION_DECK,0,1,nil)
end
function cm.tog(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x92c)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.pos,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,cm.pos,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=Duel.SelectMatchingCard(tp,cm.tog,tp,LOCATION_DECK,0,1,1,nil)
			if g1:GetCount()>0 then
				Duel.SendtoGrave(g1,REASON_EFFECT)
			end
		end
	end
end
 
