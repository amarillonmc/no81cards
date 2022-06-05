--异梦书使-馆长女儿
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400011.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,yume.YumeCheck(c,true),4,3)
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400011,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,71400011)
	e1:SetCondition(c71400011.con1)
	e1:SetTarget(c71400011.tg1)
	e1:SetOperation(c71400011.op1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400011,1))
	e2:SetCountLimit(1,71500011)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c71400011.cost)
	e2:SetTarget(c71400011.tg2)
	e2:SetOperation(c71400011.op2)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71400011,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c71400011.tg3)
	e3:SetOperation(c71400011.op3)
	c:RegisterEffect(e3)
end
function c71400011.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c71400011.filter1(c)
	return c:IsSetCard(0xe714) and c:IsAbleToHand()
end
function c71400011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400011.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71400011.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71400011.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71400011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c71400011.filter2(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_MONSTER)
end
function c71400011.xyzfilter(c,e,tp)
	return c:IsSetCard(0x714) and c:IsType(TYPE_XYZ) and not c:IsCode(71400011) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c71400011.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400011.filter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c71400011.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,0,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71400011.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71400011.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	if not sc then return end
	if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECK)
		sc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		local mg=Duel.GetMatchingGroup(c71400011.filter2,tp,LOCATION_GRAVE,0,nil)
		if mg:GetCount()>0 then
			local smg=mg:Select(tp,1,3,nil)
			Duel.Overlay(sc,smg)
		end
	else
		Duel.SpecialSummonComplete()
	end
end
function c71400011.filter3(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c71400011.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400011.filter3,tp,LOCATION_DECK,0,1,nil) end
end
function c71400011.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c71400011.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end