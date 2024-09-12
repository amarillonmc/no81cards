--动物聚会
local m=13000757
local cm=_G["c"..m]
function c13000757.initial_effect(c)
	  c:EnableReviveLimit()
local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,m)
	e5:SetRange(LOCATION_HAND)
	e5:SetTarget(cm.tg)
	e5:SetCost(cm.cost)
	e5:SetOperation(cm.op)
	c:RegisterEffect(e5)
local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1000)
	e3:SetCondition(cm.discon2)
	e3:SetCost(cm.cost2)
	e3:SetOperation(cm.disop2)
	c:RegisterEffect(e3)
local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m+1000)
	e4:SetCost(cm.cost2)
	e4:SetOperation(cm.disop2)
	c:RegisterEffect(e4)
 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
   local g=Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
   if chk==0 then return true end
   local aa=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,2,2,nil)
   Duel.SendtoDeck(aa,tp,0,REASON_EFFECT)
end
function cm.filter0(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_RITUAL) 
end
function cm.filter3(c,tp,a,b)
	return c:IsType(TYPE_RITUAL) and (c:GetSequence()==a or c:GetSequence()==b)
end
function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
 local seq=e:GetHandler():GetSequence()
	local a
	local b
	if seq>0 then a=seq-1 end
	if seq<4 then b=seq+1 end
	return eg:IsExists(cm.filter3,1,nil,tp,a,b) and not eg:IsContains(e:GetHandler())
end
function cm.disop2(e,tp,eg,ep,ev,re,r,rp)
	local aa=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_GRAVE,1,2,nil)
	Duel.SendtoDeck(aa,tp,0,REASON_EFFECT)
end
function cm.efilter(e,te,c)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(c)
end
function cm.eftg(e,c)
	local seq=e:GetHandler():GetSequence()
	local a
	local b
	if seq>0 then a=seq-1 end
	if seq<4 then b=seq+1 end
	return c:IsType(TYPE_RITUAL) and (c:GetSequence()==a or c:GetSequence()==b)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,13000753) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,13000751) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,13000749)
end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
local aa=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,13000753)
Duel.SendtoHand(aa,tp,REASON_EFFECT)
local bb=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,13000751)
Duel.SendtoHand(bb,tp,REASON_EFFECT)
local cc=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,13000749)
Duel.SendtoHand(cc,tp,REASON_EFFECT)
	local sg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,3,3,nil,TYPE_RITUAL)
	Duel.SendtoDeck(sg,tp,0,REASON_EFFECT)
end





