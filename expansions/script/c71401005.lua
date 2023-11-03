--蝶梦-「转」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401005.initial_effect(c)
	yume.AddButterflySpell(c,71401005)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401005,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,71501005)
	e2:SetCondition(c71401005.con2)
	e2:SetCost(c71401005.cost2)
	e2:SetTarget(c71401005.tg2)
	e2:SetOperation(c71401005.op2)
	c:RegisterEffect(e2)
	yume.ButterflyCounter()
end
function c71401005.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c71401005.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	yume.RegButterflyCostLimit(e,tp)
end
function c71401005.filter2(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71401005.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c71401005.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71401005.filter2a(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c71401005.filter2b(c)
	return c:IsFaceup() and c:GetType() & 0x20004==0x20004
end
function c71401005.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71401005.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local rg=Duel.GetMatchingGroup(c71401005.filter2a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if Duel.IsExistingMatchingCard(c71401005.filter2b,tp,LOCATION_ONFIELD,0,1,nil) and rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71401005,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local srg=rg:Select(tp,1,1,nil)
			Duel.Remove(srg,POS_FACEUP,REASON_EFFECT)
		end
	end
end