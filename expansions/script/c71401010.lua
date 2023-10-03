--蝶境-「漫」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401010.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c71401010.lcheck)
	--target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetTarget(c71401010.tg1)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--spsummon from hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401010,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,71401010)
	e2:SetTarget(c71401010.tg2)
	e2:SetCost(c71401010.cost2)
	e2:SetOperation(c71401010.op2)
	c:RegisterEffect(e2)
	--place
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71401010,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(1,71501010)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c71401010.cost3)
	e3:SetTarget(c71401010.tg3)
	e3:SetOperation(c71401010.op3)
	c:RegisterEffect(e3)
	yume.ButterflyCounter()
end
function c71401010.lcheck(g)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c71401010.tg1(e,c)
	return c:IsRace(RACE_SPELLCASTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c71401010.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	yume.RegButterflyCostLimit(e,tp)
end
function c71401010.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71401010.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLinkedGroupCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71401010.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c71401010.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local lct=c:GetLinkedGroupCount()
	if lct==0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c71401010.filter2,tp,LOCATION_HAND,0,nil,e,tp)
	if ft<=0 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=math.min(g:GetClassCount(Card.GetAttribute),ft,lct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,1,ct)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c71401010.filterc3(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_SPELLCASTER)
end
function c71401010.fselect(g,tp)
	return aux.dabcheck(g) and Duel.IsExistingMatchingCard(c71401010.filter3,tp,LOCATION_HAND,0,1,g,tp)
end
function c71401010.filter3(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_ONFIELD,nil)
end
function c71401010.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c71401010.filterc3,tp,LOCATION_HAND,0,nil)
	if chk==0 then return Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 and g:CheckSubGroup(c71401010.fselect,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c71401010.fselect,false,2,2,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	yume.RegButterflyCostLimit(e,tp)
end
function c71401010.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		e:SetCategory(CATEGORY_GRAVE_SPSUMMON+CATEGORY_SPECIAL_SUMMON)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	end
end
function c71401010.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c71401010.filter3,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc then
		local c=e:GetHandler()
		local ctype=Duel.SelectOption(tp,aux.Stringid(71401010,2),aux.Stringid(71401010,3))==0 and TYPE_SPELL or TYPE_TRAP
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(ctype+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and Duel.SelectYesNo(tp,aux.Stringid(71401010,4)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end