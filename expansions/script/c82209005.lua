local m=82209005
local cm=_G["c"..m]

--强度达到1vs10的卡
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(TIMING_BATTLE_START+TIMING_END_PHASE)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())  
	if chk==0 then return g:GetCount()>9 end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,10,0,0)  
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then  
		Duel.SetChainLimit(aux.FALSE)  
	end  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())  
	if g:GetCount()<10 then return end
	local sg=g:Select(tp,10,10,nil)
	Duel.HintSelection(g)  
	Duel.Destroy(g,REASON_EFFECT)   
end  