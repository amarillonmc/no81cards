--烈火纹章士 琳
function c11875303.initial_effect(c)
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
	--des damage 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11875303,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_MOVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11875303)  
	e2:SetCondition(c11875303.ddcon)
	e2:SetTarget(c11875303.ddtg)  
	e2:SetOperation(c11875303.ddop) 
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
c11875303.SetCard_tt_FireEmblem=true   
function c11875303.mckfil(c) 
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_ONFIELD)	 
end 
function c11875303.ddcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c11875303.mckfil,1,nil)  
end 
function c11875303.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500) 
end 
function c11875303.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil) 
		Duel.Destroy(dg,REASON_EFFECT)   
		Duel.Damage(1-tp,500,REASON_EFFECT) 
	end 
end 






