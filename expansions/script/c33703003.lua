--动物朋友 北极兔
local m=33703003
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.costa)
	e1:SetTarget(cm.tga)
	e1:SetOperation(cm.opa)
	c:RegisterEffect(e1)
	--Effect 2  
	local e02=Effect.CreateEffect(c)  
	e02:SetCategory(CATEGORY_RECOVER)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_GRAVE)
	--e02:SetCountLimit(1,m)
	e02:SetCondition(aux.exccon)
	e02:SetCost(cm.costb)
	e02:SetTarget(cm.tgb)
	e02:SetOperation(cm.opb)
	c:RegisterEffect(e02)  
	--all
end
--??
function cm.sf(c) 
	return c:IsSetCard(0x442)
end 
--Effect 1
function cm.costa(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.cf(c)
	return c:GetAttack()>0 and cm.sf(c)  and not c:IsPublic()
end
function cm.tga(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cf,tp,LOCATION_HAND,0,1,ec) end
end
function cm.opa(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.cf,tp,LOCATION_HAND,0,ec)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,#g)
	if not sg or #sg==0 then return false end
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	local val=sg:GetSum(Card.GetAttack)
	if val==0 then return false end
	Duel.Recover(tp,val,REASON_EFFECT)
end
--Effect 2
function cm.costb(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.kf(c)
	local b1=c:IsFaceup()
	local b2=cm.sf(c) 
	local b3=c:GetDefense()>0
	return b1 and b2 and b3
end
function cm.tgb(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.kf,tp,LOCATION_MZONE,0,nil)
	local val=g:GetSum(Card.GetDefense)
	if chk==0 then return val>0 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function cm.opb(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.kf,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return false end
	local val=g:GetSum(Card.GetDefense)
	if val==0 then return false end
	Duel.Recover(tp,val,REASON_EFFECT)
end

