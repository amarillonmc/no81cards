local m=82208118
local cm=_G["c"..m]
cm.name="龙法师 七環王"
function cm.initial_effect(c)
	--atk up  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetValue(cm.val)  
	c:RegisterEffect(e1) 
	--to deck  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_TODECK)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)  
	e2:SetCost(cm.tdcost)  
	e2:SetTarget(cm.tdtg)  
	e2:SetOperation(cm.tdop)  
	c:RegisterEffect(e2)   
end
function cm.atkfilter(c)  
	return c:GetAttribute()~=0  
end  
function cm.val(e,c)  
	local g=Duel.GetMatchingGroup(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)  
	local att=0  
	local tc=g:GetFirst()  
	while tc do  
		att=bit.bor(att,tc:GetAttribute())  
		tc=g:GetNext()  
	end  
	local ct=0  
	while att~=0 do  
		if bit.band(att,0x1)~=0 then ct=ct+1 end  
		att=bit.rshift(att,1)  
	end  
	return ct*700  
end  
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,7) end  
	Duel.DiscardDeck(tp,7,REASON_COST)  
end  
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)  
	local att=0  
	local tc=g:GetFirst()  
	while tc do  
		att=bit.bor(att,tc:GetAttribute())  
		tc=g:GetNext()  
	end  
	local ct=0  
	while att~=0 do  
		if bit.band(att,0x1)~=0 then ct=ct+1 end  
		att=bit.rshift(att,1)  
	end  
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0x1c,0x1c,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,0x1c)  
end  
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)  
	local att=0  
	local tc=g:GetFirst()  
	while tc do  
		att=bit.bor(att,tc:GetAttribute())  
		tc=g:GetNext()  
	end  
	local ct=0  
	while att~=0 do  
		if bit.band(att,0x1)~=0 then ct=ct+1 end  
		att=bit.rshift(att,1)  
	end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,0x1c,0x1c,1,ct,nil)  
	if #g>0 then  
		Duel.HintSelection(g)  
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)  
	end  
end  