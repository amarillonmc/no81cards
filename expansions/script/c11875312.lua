--神龙姬 娜琪
function c11875312.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(function(c) return c.SetCard_tt_FireEmblem end),2,2)
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
	--to hand and equip 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_EQUIP) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,11875312) 
	e2:SetTarget(c11875312.thetg) 
	e2:SetOperation(c11875312.theop) 
	c:RegisterEffect(e2) 
end 
c11875312.SetCard_tt_FireEmblem=true  
function c11875312.thfil(c) 
	return c:IsAbleToHand() and c:GetSequence()<5   
end 
function c11875312.xeqfil(c,e,tp) 
	return c:IsFaceup() and c.SetCard_tt_FireEmblem and Duel.IsExistingMatchingCard(c11875312.eqfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)  
end 
function c11875312.eqfil(c) 
	return c:IsType(TYPE_MONSTER) and c.SetCard_tt_FireEmblem and not c:IsForbidden() 
end 
function c11875312.thetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11875312.thfil,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c11875312.xeqfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c11875312.thfil,tp,LOCATION_SZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end 
function c11875312.theop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(c11875312.xeqfil,tp,LOCATION_MZONE,0,1,nil,e,tp) then 
		local sc=Duel.SelectMatchingCard(tp,c11875312.xeqfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()  
		local ec=Duel.SelectMatchingCard(tp,c11875312.eqfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil):GetFirst() 
		if not Duel.Equip(tp,ec,sc) then return end   
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		e1:SetLabelObject(sc)
		e1:SetValue(function(e,c)
		return e:GetLabelObject()==c end)
		ec:RegisterEffect(e1)  
	end 
end 












