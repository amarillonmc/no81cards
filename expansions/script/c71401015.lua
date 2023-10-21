--花构-「洄」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401015.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),4,2)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c71401015.aclimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401001,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71401015)
	e2:SetCost(c71401015.cost2)
	e2:SetTarget(yume.ButterflyPlaceTg)
	e2:SetOperation(c71401015.op2)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71401015,1))
	e3:SetCountLimit(1,71501015)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_SSET+TIMING_END_PHASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(yume.ButterflyLimitCost)
	e3:SetCondition(c71401015.con3)
	e3:SetTarget(c71401015.tg3)
	e3:SetOperation(c71401015.op3)
	c:RegisterEffect(e3)
	yume.ButterflyCounter()
end
function c71401015.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c71401015.aclimit(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not Duel.IsExistingMatchingCard(c71401015.filter1,rp,LOCATION_ONFIELD,0,1,nil)
end
function c71401015.filter2c(c)
	return c:IsLevel(4) and c:IsAbleToRemoveAsCost()
end
function c71401015.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71401015.filter2c,tp,LOCATION_HAND,0,1,nil) and Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71401015.filter2c,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	yume.RegButterflyCostLimit(e,tp)
end
function c71401015.filter2(c,e,tp)
	return c:IsType(TYPE_XYZ) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71401015.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local ct=c:GetOverlayCount()
		if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			if ct>ft then ct=ft end
			local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71401015.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,e,tp)
			if ct>0 and mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71401015,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=mg:Select(tp,1,ct,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c71401015.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c71401015.filter3(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c71401015.filter3a,tp,LOCATION_ONFIELD,0,1,c)
end
function c71401015.filter3a(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsCanOverlay()
end
function c71401015.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c71401015.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71401015.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c71401015.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c71401015.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		mg=Duel.SelectMatchingCard(tp,c71401015.filter3a,tp,LOCATION_ONFIELD,0,1,tc)
		Duel.Overlay(tc,mg)
	end
end