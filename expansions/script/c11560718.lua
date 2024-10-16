--星海航线 星灵圣王
function c11560718.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c11560718.mfilter,c11560718.xyzcheck,2,99) 
	--xyz 
	local e1=Effect.CreateEffect(c) 
--  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11560718) 
	--e1:SetCondition(function(e) 
	--return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) end)
	e1:SetTarget(c11560718.xyztg)
	e1:SetOperation(c11560718.xyzop)
	c:RegisterEffect(e1) 
	--get effect
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetCondition(c11560718.atkcon)
	e2:SetOperation(c11560718.atkop)
	c:RegisterEffect(e2)
	--spsummon cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_COST)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCost(c11560718.spccost)
	e3:SetOperation(c11560718.spcop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(11560718,ACTIVITY_ATTACK,c11560718.counterfilter)
end
c11560718.SetCard_SR_Saier=true 
function c11560718.counterfilter(c)
	return c.SetCard_SR_Saier 
end 
function c11560718.spccost(e,c,tp)
	return Duel.GetCustomActivityCount(11560718,tp,ACTIVITY_ATTACK)==0
end
function c11560718.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c) 
	return not c.SetCard_SR_Saier end) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11560718.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,2) or c:IsRank(2) or c:IsLink(2)
end
function c11560718.xyzcheck(g)
	return true 
end
function c11560718.xyzfil(c,e,tp,mc)
	return c:IsRank(2) and c.SetCard_SR_Saier and c:IsType(TYPE_XYZ)
		and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c11560718.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c11560718.xyzfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
--  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11560718.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsControler(tp) and not c:IsImmuneToEffect(e) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c11560718.xyzfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local tc=g:GetFirst()
		if tc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.Overlay(tc,mg)
			end
			tc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(tc,Group.FromCards(c))
			Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) 
			tc:CompleteProcedure() 
		end
	end
end
function c11560718.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ  
end
function c11560718.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
--  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL) 
	e1:SetOperation(c11560718.atkop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c11560718.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and g:GetCount()>0  
end 
function c11560718.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c11560718.atkcon(e,tp,eg,ep,ev,re,r,rp) then 
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)  
		local tc=g:GetFirst() 
		while tc do  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(0) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
		tc=g:GetNext() 
		end 
	end 
end 




