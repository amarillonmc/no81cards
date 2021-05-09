--异梦书使-馆长女儿
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400011.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,yume.YumeCheck(c),4,2)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400011,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,71400011+EFFECT_COUNT_CODE_DUEL)
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
	--fly away
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3a:SetCode(EVENT_CHAINING)
	e3a:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3a:SetOperation(aux.chainreg)
	c:RegisterEffect(e3a)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71400011,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCondition(c71400011.con3)
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
	return c:IsSetCard(0x3715) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
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
	if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
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
	end
end
function c71400011.filter3(c)
	return c:IsSetCard(0xb714) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c71400011.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc:IsCode(71400026) and c:GetFlagEffect(1)>0
end
function c71400011.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c71400011.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and bit.band(c:GetOriginalType(),0x802040)~=0 and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71400011.filter3),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end