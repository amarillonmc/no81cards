--破灭的初始
function c11533707.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e1:SetTarget(c11533707.actg) 
	e1:SetOperation(c11533707.acop) 
	c:RegisterEffect(e1) 
end
function c11533707.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x1=Duel.GetMatchingGroupCount(function(c) return c:IsFacedown() or not c:IsCode(11533707) end,tp,LOCATION_ONFIELD,0,nil) 
	local x2=Duel.GetMatchingGroupCount(function(c) return c:IsFacedown() or not c:IsCode(11533707) end,tp,0,LOCATION_ONFIELD,nil)  
	local g1=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 and x1>0 and x2>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)  
end 
function c11533707.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x1=Duel.GetMatchingGroupCount(function(c) return c:IsFacedown() or not c:IsCode(11533707) end,tp,LOCATION_ONFIELD,0,nil) 
	local x2=Duel.GetMatchingGroupCount(function(c) return c:IsFacedown() or not c:IsCode(11533707) end,tp,0,LOCATION_ONFIELD,nil)  
	local g1=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,e:GetHandler()) 
	if g1:GetCount()>0 and x1>0 then 
		if x1>g1:GetCount() then x1=g1:GetCount() end 
		local sg=g1:Select(1-tp,x1,x1,nil) 
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RULE)   
	end 
	if g2:GetCount()>0 and x2>0 then 
		if x2>g2:GetCount() then x2=g2:GetCount() end 
		local sg=g2:Select(tp,x2,x2,nil) 
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RULE)   
	end 
end 






