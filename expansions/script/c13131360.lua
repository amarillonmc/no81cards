--黄金凶 黄金国巫妖 
function c13131360.initial_effect(c) 
	--
	aux.AddXyzProcedure(c,nil,10,3,c13131360.ovfilter,aux.Stringid(13131360,0),3,c13131360.xyzop)
	c:EnableReviveLimit() 
	--code
	aux.EnableChangeCode(c,95440946,LOCATION_MZONE) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--disable 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,13131360) 
	e2:SetCost(c13131360.discost) 
	e2:SetTarget(c13131360.distg) 
	e2:SetOperation(c13131360.disop) 
	c:RegisterEffect(e2)
end
function c13131360.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1142)
end 
function c13131360.cfilter(c)
	return c:IsSetCard(0x2142) and c:IsAbleToGraveAsCost() 
end
function c13131360.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13131360.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c13131360.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST) 
end
function c13131360.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c13131360.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c13131360.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler()) 
	if g:GetCount()>0 then 
	local tc=g:GetFirst() 
	while tc do 
	if (tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
	tc=g:GetNext() 
	end 
	end 
end 











