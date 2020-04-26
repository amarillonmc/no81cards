local m=82204213
local cm=_G["c"..m]
cm.name="已经到极限了！我要按下去！"
function cm.initial_effect(c)
	aux.AddCodeList(c,82204200)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1) 
	--to deck  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_TODECK)  
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)   
	e4:SetCost(aux.bfgcost)  
	e4:SetTarget(cm.tdtg)  
	e4:SetOperation(cm.tdop)  
	c:RegisterEffect(e4)   
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,3,e:GetHandler()) end  
	Debug.Message("已经到极限了！我要按下去！")
	Duel.DiscardHand(tp,Card.IsDiscardable,3,3,REASON_COST+REASON_DISCARD)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end  
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)  
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then  
		Duel.SetChainLimit(cm.chainlm)  
	end  
end  
function cm.chainlm(e,rp,tp)  
	return not e:GetHandler():IsType(TYPE_MONSTER)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)  
	Duel.Destroy(sg,REASON_EFFECT)  
end  
function cm.tdfilter(c)  
	return (c:IsCode(82204200) or aux.IsCodeListed(c,82204200)) and c:IsAbleToDeck()  and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end  
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)  
end  
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c)  
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local sg=g:Select(tp,1,99,nil)  
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end  