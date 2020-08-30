local m=82208121
local cm=_G["c"..m]
cm.name="龙法师 憎恶之浊流"
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)  
end 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
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
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() and chkc~=e:GetHandler() end  
	if chk==0 then return ct>0 and Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,e:GetHandler())  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)	
	Duel.SendtoGrave(g,REASON_EFFECT)  
end  