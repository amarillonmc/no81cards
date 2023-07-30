--圣华之授秽者
function c33332211.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c33332211.ovfilter,aux.Stringid(33332211,0),2,c33332211.xyzop)
	c:EnableReviveLimit() 
	--ov 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)   
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)   
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,33332211)   
	e1:SetTarget(c33332211.ovtg) 
	e1:SetOperation(c33332211.ovop) 
	c:RegisterEffect(e1) 
	--indes 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1) 
	e2:SetCost(c33332211.idcost)
	e2:SetTarget(c33332211.idtg) 
	e2:SetOperation(c33332211.idop) 
	c:RegisterEffect(e2) 
end 
function c33332211.ovfilter(c)
	return c:IsFaceup() and c:IsCode(33332200)
end
function c33332211.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,33332200)==0 end
	Duel.RegisterFlagEffect(tp,33332200,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end 
function c33332211.ovfil(c) 
	return c:IsCanOverlay() and c:IsSetCard(0x3568) and c:IsType(TYPE_MONSTER)  
end 
function c33332211.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33332211.ovfil,tp,LOCATION_DECK,0,1,nil) end 
end 
function c33332211.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33332211.ovfil,tp,LOCATION_DECK,0,nil) 
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
		local og=g:Select(tp,1,1,nil) 
		Duel.Overlay(c,og) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_ADD_CODE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(33332200)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		c:RegisterEffect(e1) 
	end 
end 
function c33332211.idcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33332211.idtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c33332211.xovfil(c) 
	return c:IsCanOverlay() and c:IsCode(33332200)
end 
function c33332211.idop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		--indes
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2) 
		if Duel.IsExistingMatchingCard(c33332211.xovfil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,c) and Duel.SelectYesNo(tp,aux.Stringid(33332211,1)) then 
			local og=Duel.SelectMatchingCard(tp,c33332211.xovfil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,c) 
			Duel.Overlay(c,og) 
		end 
	end 
end 










