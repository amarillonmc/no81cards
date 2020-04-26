local m=82204208
local cm=_G["c"..m]
cm.name="杀手皇后第三炸弹·败者食尘"
function cm.initial_effect(c)
	aux.AddCodeList(c,82204200)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.condition)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)
end
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsCode(82204200)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Debug.Message("「杀手皇后」已经进入你的瞳孔了…")
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	if not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end  
	return Duel.IsChainNegatable(ev)
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)  
	end  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
		re:GetHandler():CancelToGrave()
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
	end  
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0  then  
		Duel.BreakEffect()  
		c:CancelToGrave()  
		Duel.ChangePosition(c,POS_FACEDOWN)  
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)  
	end  
end  