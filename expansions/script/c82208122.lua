local m=82208122
local cm=_G["c"..m]
cm.name="龙法师 幽风死神"
function cm.initial_effect(c)
	--change effect  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCondition(cm.chcon)
	e1:SetCost(cm.chcost)  
	e1:SetOperation(cm.chop)  
	c:RegisterEffect(e1)  
	--pos  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_SET_POSITION)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetTargetRange(0,LOCATION_MZONE)  
	e4:SetTarget(cm.postg)  
	e4:SetValue(POS_FACEDOWN_DEFENSE)  
	c:RegisterEffect(e4)  
end
function cm.postg(e,c)  
	return c:IsFaceup()  
end  
function cm.costfilter(c)  
	return c:IsAbleToDeckAsCost()  
end  
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)  
	return rp==1-tp  
end  
function cm.chcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,7,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,7,7,nil)  
	Duel.SendtoDeck(g,nil,2,REASON_COST)  
end  
function cm.chop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Group.CreateGroup()  
	Duel.ChangeTargetCard(ev,g)  
	Duel.ChangeChainOperation(ev,cm.repop)  
end  
function cm.repop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.IsPlayerCanDraw(1-tp,1) and Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then   
		Duel.Hint(HINT_OPSELECTED,tp,1213)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	else
		Duel.Hint(HINT_OPSELECTED,tp,1214)
	end
end  