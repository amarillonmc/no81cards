local m=82208119
local cm=_G["c"..m]
cm.name="龙法师 怪诞之业火"
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsRace(RACE_DRAGON) and c:IsFaceup()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)  
end 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
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
	local c=e:GetHandler()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(nil,tp,0x0c,0x0c,1,c) end  
	local g=Duel.GetMatchingGroup(nil,tp,0x0c,0x0c,c)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp) 
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
	if ct==0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectMatchingCard(tp,nil,tp,0x0c,0x0c,1,ct,e:GetHandler())  
	if g:GetCount()>0 then  
		Duel.HintSelection(g)  
		Duel.Destroy(g,REASON_EFFECT)  
	end  
end  