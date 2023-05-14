local m=82204244
local cm=_G["c"..m]
cm.name="秋之妖狐 凉枫"
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
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,m+10000)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.descon)
	e2:SetCost(cm.descost)  
	e2:SetTarget(cm.destg)  
	e2:SetOperation(cm.desop)  
	c:RegisterEffect(e2)
end
cm.SetCard_01_YaoHu=true 
function cm.isYaoHu(code)
	local ccode=_G["c"..code]
	return ccode.SetCard_01_YaoHu
end
function cm.filter(c)  
	return cm.isYaoHu(c:GetCode()) and not c:IsCode(m) and c:IsAbleToDeck() 
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.HintSelection(g)  
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end  
end  
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsReleasable,1,nil) end  
	local g=Duel.SelectReleaseGroup(tp,Card.IsReleasable,1,1,nil)  
	Duel.Release(g,REASON_COST)  
end  
function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()~=PHASE_DRAW  
end  
function cm.desfilter(c,tp)  
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_HAND)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)  
	if g:GetCount()>0 then  
		local sg=g:RandomSelect(tp,1)  
		Duel.Destroy(sg,REASON_EFFECT) 
	end  
end  