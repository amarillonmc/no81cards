--核心惩戒者-基格尔德100%
function c75011874.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c75011874.mfilter,c75011874.xyzcheck,2,2) 
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1) 
	--indes 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c75011874.reptg) 
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(POS_FACEUP_ATTACK) 
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(function(e,c)
	return c:IsType(TYPE_SPELL) end)
	c:RegisterEffect(e2)
	--disable effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	local tl,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_PLAYER)
	if bit.band(tl,LOCATION_SZONE)~=0 and p~=tp and re:IsActiveType(TYPE_SPELL) then
		Duel.NegateEffect(ev)
	end end) 
	c:RegisterEffect(e3) 
	--immuse 
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN)  
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end) 
	e4:SetTarget(c75011874.immtg) 
	e4:SetOperation(c75011874.immop) 
	c:RegisterEffect(e4) 
	--
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e0:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e0:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end) 
	e0:SetOperation(function(e) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(75011874,0))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(75011874,0)) 
	end) 
	c:RegisterEffect(e0)
end 
c75011874.SetCard_TT_JGRD=true 
function c75011874.mfilter(c,xyzc)
	return (c:IsXyzLevel(xyzc,5) or c:IsRank(5)) and c.SetCard_TT_JGRD  
end
function c75011874.xyzcheck(g)
	return true 
end
function c75011874.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	local dam=Duel.GetBattleDamage(tp) 
	if chk==0 then return c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE) end 
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_DEFENSE)  
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(-dam)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
		if c:IsDefense(0) then 
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)  
		end 
		return true
	else return false end
end
function c75011874.immtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end 
end 
function c75011874.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil) 
	if c:IsRelateToEffect(e) and g:GetCount()>0 then  
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		--immune
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetLabelObject(tc) 
		e1:SetValue(function(e,te) 
		return te:GetOwner()==e:GetLabelObject() end) 
		e1:SetReset(RESET_CHAIN) 
		c:RegisterEffect(e1)
	end 
end 




