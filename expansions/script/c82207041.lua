local m=82207041
local cm=c82207041

function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)  
	e1:SetCategory(CATEGORY_TODECK)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_BATTLE_DESTROYED)  
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)  
end

function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil) end  
	local tc=Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	if tc>3 then
		tc=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,tc,tp,LOCATION_HAND)  
end  

function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)  
	local tc=g:GetCount()
	if tc>0 then  
		if tc>3 then tc=3 end
		local sg=g:RandomSelect(tp,tc)  
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)  
	end  
end  
