--星彩之授秽者
function c33332212.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,function(c) return c:IsCode(33332200) end,1,1)
	c:EnableReviveLimit() 
	--code
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_RECOVER) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCost(c33332212.cdcost)
	e1:SetTarget(c33332212.cdtg) 
	e1:SetOperation(c33332212.cdop) 
	c:RegisterEffect(e1) 
	--immuse 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_IMMUNE_EFFECT) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetValue(function(e,te) 
	local rc=te:GetOwner()
	return te:IsActiveType(TYPE_MONSTER) and rc and not rc:IsCode(33332200) end) 
	c:RegisterEffect(e2)
end 
function c33332212.cdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c33332212.cdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=eg:Filter(Card.IsSummonPlayer,nil,1-tp)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,500)
end 
function c33332212.cdop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=eg:Filter(Card.IsSummonPlayer,nil,1-tp)
	if Duel.Recover(1-tp,500,REASON_EFFECT)~=0 and g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CHANGE_CODE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(33332200)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)   
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CHANGE_LEVEL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(3)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)  
		tc=g:GetNext() 
		end 
	end 
end 










 