--星海航线 帝皇之御
function c11560703.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2) 
	c:EnableReviveLimit()   
	--xyz 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCost(c11560703.xyzcost) 
	e1:SetTarget(c11560703.xyztg) 
	e1:SetOperation(c11560703.xyzop) 
	c:RegisterEffect(e1) 

	--indes
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_XMATERIAL)
	--e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	--e3:SetValue(1)
	--c:RegisterEffect(e3)
	--local e4=e3:Clone()
	--e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--c:RegisterEffect(e4)
end 
c11560703.SetCard_SR_Saier=true 
function c11560703.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) 
end 
function c11560703.xspfil(c,e,tp) 
	local mc=e:GetHandler()
	return c:IsType(TYPE_XYZ) and c.SetCard_SR_Saier and c:IsAttribute(mc:GetAttribute()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0  
end 
function c11560703.xyztg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11560703.xspfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
	--Duel.SetChainLimit(c11560703.chlimit)
end
function c11560703.chlimit(e,ep,tp)
	return tp==ep
end
function c11560703.xyzop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11560703.xspfil,tp,LOCATION_EXTRA,0,nil,e,tp) 
	if g:GetCount()>0 and c:IsRelateToEffect(e) then 
	local sc=g:Select(tp,1,1,nil):GetFirst() 
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		Duel.Overlay(sc,c) 
		sc:SetMaterial(Group.FromCards(c)) 
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) 
		sc:CompleteProcedure()
	--double damage
	--local e1=Effect.CreateEffect(sc)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE) 
	--e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE)) 
	--e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	--sc:RegisterEffect(e1) 
	--actlimit
	--local e2=Effect.CreateEffect(sc)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetTargetRange(0,1)
	--e2:SetValue(1)
	--e2:SetCondition(c11560703.actcon)
	--e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	--sc:RegisterEffect(e2) 
		--indes
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE) 
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		sc:RegisterEffect(e3)
		--actlimit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,1)
		e2:SetValue(1)
		e2:SetCondition(function(e)
		return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() end) 
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		sc:RegisterEffect(e2)
	end 
end 
function c11560703.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end









