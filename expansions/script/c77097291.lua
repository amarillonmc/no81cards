--机械伊丽亲
function c77097291.initial_effect(c)
	c:SetSPSummonOnce(77097291) 
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c77097291.ovfilter,aux.Stringid(77097291,0))
	c:EnableReviveLimit() 
	--defense 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1)  
	e1:SetCost(c77097291.defcost)
	e1:SetTarget(c77097291.deftg) 
	e1:SetOperation(c77097291.defop) 
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
end 
function c77097291.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsLevel(8) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) 
end 
function c77097291.defcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.PayLPCost(tp,500)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77097291.deftg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return not c:IsDefensePos() and c:IsCanChangePosition() end,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,1-tp,LOCATION_MZONE)
end 
function c77097291.defop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return not c:IsDefensePos() and c:IsCanChangePosition() end,tp,0,LOCATION_MZONE,nil)  
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(0) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)	  
	end 
end 









