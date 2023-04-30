local m=82204243
local cm=_G["c"..m]
cm.name="夏之妖狐 绯焰"
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
	--destroy  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetCountLimit(1,m+10000)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCost(cm.descost)  
	e2:SetTarget(cm.destg)  
	e2:SetOperation(cm.desop)  
	c:RegisterEffect(e2)
end
cm.SetCard_01_YaoHu=true 
function cm.filter(c)  
	return c.SetCard_01_YaoHu and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and not c:IsCode(m) and c:IsAbleToHand() 
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
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsReleasable,1,nil) end  
	local g=Duel.SelectReleaseGroup(tp,Card.IsReleasable,1,1,nil)  
	Duel.Release(g,REASON_COST)  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end  
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetBaseAttack())  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then  
		Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)  
	end  
end  