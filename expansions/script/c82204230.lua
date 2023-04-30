local m=82204230
local cm=_G["c"..m]
cm.name="夜刃流·一斩"
function cm.initial_effect(c)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)  
	e1:SetCost(cm.cost) 
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end
cm.SetCard_01_YeRen=true 
function cm.tdfilter(c)  
	return c.SetCard_01_YeRen and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	local tg=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,1,99,nil) 
	e:SetLabel(tg:GetCount())
	Duel.SendtoDeck(tg,nil,2,REASON_COST)  
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0x0c,0x0c,1,e:GetHandler(),tp) end  
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x0c,0x0c,e:GetHandler(),tp) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,nil,0,0)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp) 
	local label=e:GetLabel()
	if label>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0x0c,0x0c,1,label,e:GetHandler(),tp) 
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end