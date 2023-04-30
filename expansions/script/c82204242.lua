local m=82204242
local cm=_G["c"..m]
cm.name="春之妖狐 流芳"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e1:SetCountLimit(1,m)  
	e1:SetCost(aux.bfgcost)  
	e1:SetTarget(cm.thtg)  
	e1:SetOperation(cm.thop)  
	c:RegisterEffect(e1)  
	--negate  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m+10000)  
	e2:SetCondition(cm.discon)  
	e2:SetCost(cm.discost)  
	e2:SetTarget(cm.distg)  
	e2:SetOperation(cm.disop)  
	c:RegisterEffect(e2) 
end
cm.SetCard_01_YaoHu=true 
function cm.filter(c)  
	return c.SetCard_01_YaoHu and not (c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand() 
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)  
end  
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsReleasable,1,nil) end  
	local g=Duel.SelectReleaseGroup(tp,Card.IsReleasable,1,1,nil)  
	Duel.Release(g,REASON_COST)  
end  
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Destroy(eg,REASON_EFFECT)  
	end  
end  