local s,id=GetID()
Duel.LoadScript("kcode_myxyz.lua")
function s.initial_effect(c)
	c:EnableReviveLimit()
   -- c:SetSPSummonOnce(id)
   myxyz.AddXyzProcedure(c, id, 2)
 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.matcon)
	e1:SetTarget(s.mattg)
	e1:SetOperation(s.matop)
	c:RegisterEffect(e1)
	

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.eqcon)
	e2:SetCost(s.eqcost)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(s.attval)
	c:RegisterEffect(e4)
end

s.nightmare_setcode = my  -- 梦魇


function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.matfilter1(c)
	return c:IsFaceup() and c:IsSetCard(s.nightmare_setcode) and c:GetSequence()<5
end
function s.matfilter2(c)
	return c:IsFaceup() and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,s.nightmare_setcode)
end

function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g1=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_SZONE,0,nil)
		local g2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_MZONE,0,nil)
		return #g1>0 or #g2>0
	end
end

function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	local g1=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_SZONE,0,nil)
	local g2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_MZONE,0,nil)
	local tc=g1:GetFirst()
	while tc do
		tc:CancelToGrave()
		tc=g1:GetNext()
	end
	local mg=Group.CreateGroup()
	if #g1>0 then
		mg:Merge(g1)
	end
	if #g2>0 then
		mg:Merge(g2)
	end
	
	if #mg>0 then
		Duel.Overlay(c,mg)
	end
end




function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end

function s.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.eqfilter(c)
	return c:IsSetCard(s.nightmare_setcode) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,false) then return end
		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		tc:RegisterEffect(e1)
	end
end

function s.eqlimit(e,c)
	return e:GetOwner()==c
end

function s.atkval(e,c)
	return c:GetOverlayCount()*200
end

function s.nightmarefilter(c)
	return c:IsSetCard(s.nightmare_setcode) and c:IsType(TYPE_MONSTER)
end

function s.attval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(s.nightmarefilter,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if ct>0 then
		return ct-1
	else
		return 0
	end
end