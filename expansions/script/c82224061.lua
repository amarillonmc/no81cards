local m=82224061
local cm=_G["c"..m]
cm.name="鸽了"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	 if c:IsRelateToEffect(e) then   
		c:CancelToGrave()  
		Duel.SendtoGrave(c,REASON_EFFECT) 
	end  
end  