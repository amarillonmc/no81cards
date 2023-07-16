--极彩色的祭典
function c11561040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTarget(c11561040.actg) 
	e1:SetOperation(c11561040.acop) 
	c:RegisterEffect(e1) 
end 
function c11561040.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsAbleToRemoveAsCost() end,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.dabcheck,3,7) end 
	local cg=g:SelectSubGroup(tp,aux.dabcheck,false,3,7) 
	local x=Duel.Remove(cg,POS_FACEUP,REASON_COST) 
	e:SetLabel(x)
	local rg=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE) 
	if x>=4 then rg:Merge(Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)) end 
	if x>=5 then rg:Merge(Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)) end 
	if x>=6 then rg:Merge(Duel.GetFieldGroup(tp,0,LOCATION_HAND)) end 
	if x>=7 then rg:Merge(Duel.GetFieldGroup(tp,0,LOCATION_DECK)) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,rg:GetCount(),0,0)
end 
function c11561040.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local x=e:GetLabel() 
	if x and x>=3 then 
		local rg=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE) 
		if x>=4 then rg:Merge(Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)) end 
		if x>=5 then rg:Merge(Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)) end 
		if x>=6 then rg:Merge(Duel.GetFieldGroup(tp,0,LOCATION_HAND)) end 
		if x>=7 then rg:Merge(Duel.GetFieldGroup(tp,0,LOCATION_DECK)) end 
		if rg:GetCount()>0 then 
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)   
		end 
	end 
end 






