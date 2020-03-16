--星宫六喰 归宇
local m=33400601
local cm=_G["c"..m]
function cm.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
   --todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.tdcon1)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.tdcon2)
	c:RegisterEffect(e3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.filter(c)
	return  c:IsSetCard(0x9342)  and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33460651)==0
end
function cm.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33460651)>0 
end
function cm.tdfilter(c,tp)
	return  c:IsSetCard(0x340,0x341) and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),tp)
end
function cm.refilter(c,m2,tp)
	return  c:IsSetCard(0x9342) and c:IsAbleToRemove() and not c:IsCode(m2) 
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_REMOVED,0,1,nil,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	local tc=g:GetFirst()
	local m1=tc:GetCode()
	if  Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
		local g2=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_DECK,0,1,1,nil,m1,tp)
		local tc2=g2:GetFirst()
		Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)		   
	end 
end