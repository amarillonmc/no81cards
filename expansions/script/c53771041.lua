--生者之书-完结的咒术-
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function c53771041.initial_effect(c)
	SNNM.Sarcoveil_Sort(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c53771041.target)
	e1:SetOperation(c53771041.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,53771041)
	e2:SetCost(c53771041.spcost)
	e2:SetTarget(c53771041.sptg)
	e2:SetOperation(c53771041.spop)
	c:RegisterEffect(e2)
end
function c53771041.cfilter(c,e,tp,chk)
	return (c:IsSetCard(0xa53b) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_DECK) and c:IsAbleToHand()) or (c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 and (chk==0 or aux.NecroValleyFilter()(c)))
end
function c53771041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53771041.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,0) end
end
function c53771041.rmfilter(c,tp)
	return c:IsLevelAbove(1) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c53771041.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function c53771041.thfilter(c,lv)
	return c:IsSetCard(0xa53b) and c:IsLevel(lv) and c:IsAbleToHand()
end
function c53771041.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=Duel.SelectMatchingCard(tp,c53771041.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,1)
	local tg=Group.CreateGroup()
	if sg:GetCount()==0 then return end
	if Duel.IsExistingMatchingCard(c53771041.rmfilter,tp,0,LOCATION_GRAVE,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(53771041,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=Duel.SelectMatchingCard(tp,c53771041.rmfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp):GetFirst()
		Duel.HintSelection(Group.FromCards(rc))
		local lv=rc:GetLevel()
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tg=Duel.SelectMatchingCard(tp,c53771041.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	end
	Duel.BreakEffect()
	if sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)~=0 then tg:Merge(sg) end
	if tg:GetCount()~=0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	if sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)~=0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c53771041.costfilter(c,tp)
	return c:IsCode(53771033) and c:IsAbleToRemoveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,0x40)>0--f
end
function c53771041.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53771041.costfilter,tp,LOCATION_MZONE,0,1,nil,tp) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c53771041.costfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c53771041.spfilter(c,e,tp)
	return c:IsCode(53771037) and c:CheckFusionMaterial() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsType(TYPE_FUSION)
end
function c53771041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(c53771041.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c53771041.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c53771041.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
	end
end
