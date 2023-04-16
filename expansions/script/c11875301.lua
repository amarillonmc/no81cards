--选择纹章士 神威
function c11875301.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(function(e,c)
	return not e:GetHandler():GetColumnGroup():IsContains(c) end)
	c:RegisterEffect(e1)  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE) 
	e1:SetTarget(function(e,c) 
	return not e:GetHandler():GetColumnGroup():IsContains(c) end)
	e1:SetValue(function(e,c)
	return c==e:GetHandler() end)
	c:RegisterEffect(e1)	 
	--Destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11875301,1))
	e2:SetCategory(CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,11875301) 
	e2:SetCondition(function(e) 
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e2:SetTarget(c11875301.destg) 
	e2:SetOperation(c11875301.desop)  
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(function(e,c)
	return c:IsType(TYPE_MONSTER) and c.SetCard_tt_FireEmblem and c:GetEquipGroup():IsContains(e:GetHandler()) end) 
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3) 
end
c11875301.SetCard_tt_FireEmblem=true 
function c11875301.desfil(c,e,tp) 
	return e:GetHandler():GetColumnGroup():IsContains(c)   
end 
function c11875301.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11875301.desfil,tp,0,LOCATION_ONFIELD,nil,e,tp)
	if chk==0 then return g:GetCount()>0 and e:GetHandler():GetFlagEffect(11875301)==0 end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end 
function c11875301.desop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11875301.desfil,tp,0,LOCATION_ONFIELD,nil,e,tp)
	if g:GetCount()>0 then 
		Duel.Destroy(g,REASON_EFFECT) 
	end 
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(11875301,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end 
end 











