--花境-「落」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401022.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SPELLCASTER),2,2,c71401022.lcheck)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c71401022.chainop)
	c:RegisterEffect(e1)
	--attribute change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401022,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,71401022)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c71401022.tg2)
	e2:SetCost(c71401022.cost2)
	e2:SetOperation(c71401022.op2)
	c:RegisterEffect(e2)
	--place
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71401022,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(1,71501022)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c71401022.cost3)
	e3:SetTarget(c71401022.tg3)
	e3:SetOperation(c71401022.op3)
	c:RegisterEffect(e3)
	yume.ButterflyCounter()
end
function c71401022.lcheck(g)
	return aux.SameValueCheck(g,Card.GetLinkAttribute)
end
function c71401022.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActivateLocation()==LOCATION_HAND and race&RACE_SPELLCASTER~=0 then
		Duel.SetChainLimit(c71401022.chainlm)
	end
end
function c71401022.chainlm(re,rp,tp)
	return tp==rp
end
function c71401022.filterc2(c,attr)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToDeckOrExtraAsCost() and not c:IsAttribute(attr)
end
function c71401022.filterc2a(c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_SPELLCASTER) and c:IsLinkState()
end
function c71401022.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=Duel.GetMatchingGroup(c71401022.filterc2a,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 and lg:GetCount()==0 then return false end
	local same_attr=0x0
	if lg:GetClassCount(Card.GetAttribute)==1 then same_attr=lg:GetFirst():GetAttribute() end
	if chk==0 then return Duel.IsExistingMatchingCard(c71401022.filterc2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,same_attr) and Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c71401022.filterc2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,same_attr)
	local rc=g:GetFirst()
	local attr=rc:GetAttribute()
	Duel.SendtoDeck(rc,nil,SEQ_DECKSHUFFLE,REASON_COST)
	e:SetLabel(attr)
	yume.RegButterflyCostLimit(e,tp)
end
function c71401022.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
end
function c71401022.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=Duel.GetMatchingGroup(c71401022.filterc2a,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local attr=e:GetLabel()
	for tc in aux.Next(lg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(attr)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c71401022.filterc3(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsRace(RACE_SPELLCASTER) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c71401022.fselect3(g)
	return g:GetClassCount(Card.GetAttribute)==1 and Duel.GetMZoneCount(tp,g)>0
end
function c71401022.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c71401022.filterc3,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 and g:CheckSubGroup(c71401022.fselect3,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,c71401022.fselect3,false,2,2)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	yume.RegButterflyCostLimit(e,tp)
end
function c71401022.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c71401022.filter3(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71401022.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71401022.filter3),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		if mg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(71401022,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=mg:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end