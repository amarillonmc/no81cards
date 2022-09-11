--窥视渊异之龙皇
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20000455)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(m,0))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCost(cm.op1_cos)
	e1:SetOperation(cm.op1_op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(0x10000000+m)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	Duel.RegisterEffect(e2,tp)
end
function cm.op1_cos(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,m)
	local n=Duel.GetMatchingGroupCount(Card.IsPublic,tp,0,LOCATION_HAND,nil)
	return Duel.CheckLPCost(tp,ct*n*500) or n==0
end
function cm.op1_op(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetMatchingGroupCount(Card.IsPublic,tp,0,LOCATION_HAND,nil)
	if n>0 then Duel.PayLPCost(tp,n*500) end
end
--e3
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsPublic,nil):Filter(Card.IsAbleToDeck,nil)
	if chk==0 then return #g>0 and Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsAbleToDeck() end
	Duel.SetTargetPlayer(tp)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0):Filter(Card.IsPublic,nil):Filter(Card.IsAbleToDeck,nil)
	if e:GetHandler():IsRelateToEffect(e) then g:AddCard(e:GetHandler()) end
	if #g==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.Draw(p,#g,REASON_EFFECT)
end