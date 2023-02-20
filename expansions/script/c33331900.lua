--堇霆之狂兽 肯特
function c33331900.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c33331900.mfilter1,c33331900.mfilter2,true) 
	--remove and damage 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetCost(c33331900.radcost) 
	e1:SetTarget(c33331900.radtg) 
	e1:SetOperation(c33331900.radop) 
	c:RegisterEffect(e1) 
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c33331900.discon) 
	e2:SetTarget(c33331900.distg)
	e2:SetOperation(c33331900.disop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_PZONE) 
	e3:SetTarget(c33331900.psptg) 
	e3:SetOperation(c33331900.pspop) 
	c:RegisterEffect(e3) 
end
function c33331900.mfilter1(c) 
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_REPTILE)
end 
function c33331900.mfilter2(c) 
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_THUNDER) 
end 
function c33331900.ctfil(c) 
	return c:IsAbleToDeckAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)  
end 
function c33331900.tdgck(g)  
	return g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)==1 
	   and g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)==1  
end 
function c33331900.radcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c33331900.ctfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return g:CheckSubGroup(c33331900.tdgck,2,2) end 
	local sg=g:SelectSubGroup(tp,c33331900.tdgck,false,2,2) 
	Duel.SendtoDeck(sg,nil,2,REASON_COST) 
end 
function c33331900.rmfil(c) 
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP)  
end 
function c33331900.radtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c33331900.rmfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*200)
end 
function c33331900.radop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33331900.rmfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if g:GetCount()>0 then 
		local x=Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
		if x>0 and c:IsRelateToEffect(e) and c:IsFaceup() then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(x*200) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			c:RegisterEffect(e1) 
			Duel.Damage(1-tp,x*200,REASON_EFFECT) 
		end 
	end 
end 
function c33331900.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end 
function c33331900.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c33331900.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then 
		Duel.NegateEffect(ev)
	end 
end
function c33331900.sctfil(c) 
	return c:IsAbleToDeck() and c:IsRace(RACE_THUNDER+RACE_REPTILE) and c:IsLevelAbove(1) 
end 
function c33331900.sctgck(g,tp) 
	return g:CheckWithSumGreater(Card.GetLevel,9) and Duel.GetMZoneCount(tp,g)>0 
end  
function c33331900.psptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c33331900.sctfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and g:CheckSubGroup(c33331900.sctgck,1,99,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c33331900.pspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33331900.sctfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil) 
	if g:CheckSubGroup(c33331900.sctgck,1,99,tp) then 
		local sg=g:SelectSubGroup(tp,c33331900.sctgck,false,1,99,tp) 
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end 
end 









