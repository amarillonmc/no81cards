local m=82228567
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(cm.spcon)  
	c:RegisterEffect(e1)
	--to hand 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con1) 
	e2:SetTarget(cm.tg)  
	e2:SetCost(cm.cost2) 
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(cm.con2)
	e3:SetCost(cm.cost)
	c:RegisterEffect(e3)
end
function cm.spfilter(c)  
	return c:IsCode(82228562)  
end  
function cm.spcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)  
end 
function cm.con1(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsPlayerAffectedByEffect(tp,82228569)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp) 
	return not Duel.IsPlayerAffectedByEffect(tp,82228569)
end 
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end 
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)  
end  
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end  
function cm.thfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x297) and c:IsAbleToHand()  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return false end  
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_ONFIELD,0,1,nil)  
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)  
	local g1=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)  
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)  
	g1:Merge(g2)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
	end  
end  