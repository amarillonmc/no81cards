--刹那的樱花 樱
function c32131323.initial_effect(c)
	aux.AddCodeList(c,32131322) 
	--xyz summon
	aux.AddXyzProcedure(c,c32131323.mfilter,8,2)
	c:EnableReviveLimit() 
	--code 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE) 
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(0xff)  
	e0:SetValue(32131322) 
	c:RegisterEffect(e0)
	--xyz 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,32131323) 
	e1:SetTarget(c32131323.xyztg) 
	e1:SetOperation(c32131323.xyzop) 
	c:RegisterEffect(e1) 
	c32131323.sp_effect=e1 
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1) 
	e2:SetCost(c32131323.negcost)
	e2:SetTarget(c32131323.negtg)
	e2:SetOperation(c32131323.negop)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c32131323.actcon)
	e3:SetValue(1)
	c:RegisterEffect(e3) 
end
c32131323.SetCard_HR_flame13=true 
c32131323.HR_Flame_CodeList=false 
function c32131323.mfilter(c) 
	return c.SetCard_HR_flame13 
end 
function c32131323.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_GRAVE,0,1,nil) end 
end 
function c32131323.xyzop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then 
	   local og=g:Select(tp,1,1,nil) 
	   if c:IsRelateToEffect(e) then 
	   Duel.Overlay(c,og) 
	   end 
	end 
end  
function c32131323.negcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) 
end  
function c32131323.negtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD) 
end
function c32131323.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc:IsFaceup() then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(0) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e2)
	end
end
function c32131323.actcon(e)
	local tc=Duel.GetAttacker()
	local tp=e:GetHandlerPlayer()
	return tc and tc:IsControler(tp) and tc.SetCard_HR_flame13  
end




