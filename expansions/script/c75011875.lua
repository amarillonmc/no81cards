--秩序守护者-基格尔德50%
function c75011875.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c75011875.mfilter,c75011875.xyzcheck,5,5)	 
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_FZONE) 
	c:RegisterEffect(e1)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(tl,LOCATION_SZONE)~=0 and re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsType(TYPE_FIELD) then
		Duel.NegateEffect(ev)
	end end) 
	c:RegisterEffect(e2) 
	--des 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1) 
	e3:SetTarget(c75011875.destg) 
	e3:SetOperation(c75011875.desop) 
	c:RegisterEffect(e3) 
end
c75011875.SetCard_TT_JGRD=true   
function c75011875.mfilter(c,xyzc)
	return (c:IsXyzLevel(xyzc,1) or c:IsRank(1)) and c.SetCard_TT_JGRD  
end
function c75011875.xyzcheck(g)
	return true 
end
function c75011875.desfil(c) 
	return c:IsFacedown() or not c:IsAttribute(ATTRIBUTE_WIND)
end 
function c75011875.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c75011875.desfil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	local a=g:GetCount()
	local x=e:GetHandler():RemoveOverlayCard(tp,1,a,REASON_COST) 
	e:SetLabel(x) 
end 
function c75011875.desop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local x=e:GetLabel() 
	local g=Duel.GetMatchingGroup(c75011875.desfil,tp,0,LOCATION_MZONE,nil) 
	if x>0 and g:GetCount()>=x then 
		local dg=g:Select(tp,x,x,nil) 
		Duel.Destroy(dg,REASON_EFFECT)	  
	end  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_ONFIELD+LOCATION_GRAVE))
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_DECK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_ONFIELD+LOCATION_GRAVE))
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end 




