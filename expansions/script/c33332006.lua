--苍星之智 清念
function c33332006.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c33332006.mfilter,6,2,c33332006.ovfilter,aux.Stringid(33332006,0),3,c33332006.xyzop)
	c:EnableReviveLimit() 
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,33332006)
	e1:SetTarget(c33332006.atktg) 
	e1:SetOperation(c33332006.atkop) 
	c:RegisterEffect(e1) 
	--rec and rm 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_REMOVE) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end)
	e2:SetTarget(c33332006.rrtg)  
	e2:SetOperation(c33332006.rrop) 
	c:RegisterEffect(e2) 
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval) 
	e3:SetCondition(function(e) 
	return e:GetHandler():GetOverlayGroup():IsExists(function(c) return c:IsType(TYPE_XYZ) and c:IsSetCard(0x5567) end,1,nil) end)
	c:RegisterEffect(e3)
end
function c33332006.mfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_WATER) 
end
function c33332006.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRank(3) 
end
function c33332006.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,33332006)==0 end
	Duel.RegisterFlagEffect(tp,33332006,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c33332006.ackfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x5567) and (c:IsLevelAbove(1) or c:IsRankAbove(1)) 
end 
function c33332006.atktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c33332006.ackfil,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return g:GetCount()>0 end  
end 
function c33332006.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c33332006.ackfil,tp,LOCATION_REMOVED,0,nil) 
	if c:IsRelateToEffect(e) and g:GetCount()>0 and c:IsFaceup() then 
		local atk=g:GetSum(Card.GetLevel)+g:GetSum(Card.GetRank) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(atk*100) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
		if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33332006,0)) then 
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil) 
			Duel.SendtoGrave(sg,REASON_EFFECT) 
		end 
	end 
end 
function c33332006.rmfil(c)  
	return c:IsSetCard(0x5567) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end  
function c33332006.rrtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(c33332006.rmfil,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c33332006.rmfil,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
end 
function c33332006.rrop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33332006.rmfil,tp,LOCATION_GRAVE,0,nil)
	if Duel.Recover(tp,500,REASON_EFFECT)~=0 and g:GetCount()>0 then 
		Duel.BreakEffect() 
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)  
	end 
end 









