local m=82204245
local cm=_G["c"..m]
cm.name="冬之妖狐 霜痕"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TODECK)  
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
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1,m+10000)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.descon)
	e2:SetCost(cm.descost)  
	e2:SetTarget(cm.destg)  
	e2:SetOperation(cm.desop)  
	c:RegisterEffect(e2)
end
cm.SetCard_01_YaoHu=true 
function cm.filter(c)  
	return c.SetCard_01_YaoHu and c:IsFaceup() and not c:IsCode(m) and c:IsAbleToGrave()
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)  
	end  
end  
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsReleasable,1,nil) end  
	local g=Duel.SelectReleaseGroup(tp,Card.IsReleasable,1,1,nil)  
	Duel.Release(g,REASON_COST)  
end 
function cm.descon(e,tp,eg,ep,ev,re,r,rp)   
	local at=Duel.GetAttacker()  
	return at:GetControler()~=tp 
end  
function cm.desfilter(c,tp)  
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tg=Duel.GetAttacker()  
	if chk==0 then return tg:IsLocation(LOCATION_MZONE) end  
	Duel.SetTargetCard(tg)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		if Duel.NegateAttack()~=0 then
			Duel.Destroy(tc,REASON_EFFECT)  
		end
	end  
end  