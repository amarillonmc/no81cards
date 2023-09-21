--梦 殿 大 祀 庙
function c53700008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53700008,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53700008+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c53700008.target)
	e1:SetOperation(c53700008.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53700008,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c53700008.tgcost)
	e2:SetTarget(c53700008.tgtg)
	e2:SetOperation(c53700008.tgop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53700008,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c53700008.spcon)
	e3:SetTarget(c53700008.sptg)
	e3:SetOperation(c53700008.spop)
	c:RegisterEffect(e3)
end
function c53700008.filter(c,e,tp,chk)
	return c:IsCode(53700005)
		and (c:IsAbleToHand() or chk and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c53700008.ffilter(c)
	return c:IsFaceup() and c:IsCode(53700006)
end
function c53700008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=Duel.IsExistingMatchingCard(c53700008.ffilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		return Duel.IsExistingMatchingCard(c53700008.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,res)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c53700008.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.IsExistingMatchingCard(c53700008.ffilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c53700008.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,res):GetFirst()
	if tc then
		if res and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53700008,2))
			local lv=Duel.AnnounceNumber(tp,1,2,3,4)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c53700008.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	if c:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,c)
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c53700008.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsType(TYPE_RITUAL) or c:IsCode(53700005)) and c:IsAbleToGrave()
end
function c53700008.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53700008.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c53700008.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c53700008.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c53700008.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp and bit.band(c:GetPreviousTypeOnField(),TYPE_RITUAL)>0
end
function c53700008.spcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()~=1 then return false end
	return eg:IsExists(c53700008.cfilter,1,nil,tp)
end
function c53700008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if not tc then return false end
		return tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
			and Duel.IsExistingMatchingCard(c53700008.relfilter,tp,LOCATION_MZONE,0,1,tc,e,tp,tc,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
end
function c53700008.relfilter(c,e,tp,tc,ft)
	if not c:IsLevelAbove(tc:GetLevel()) then return false end
	if tc.mat_filter and not tc.mat_filter(c,tp) then return false end
	return (ft>0 or c:IsControler(tp)) and c:IsReleasableByEffect(e)
end
function c53700008.spop(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if not rc or rc:IsFacedown() then return end
	if not rc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c53700008.relfilter),tp,LOCATION_MZONE,0,1,1,rc,e,tp,rc,ft):GetFirst()
	if tc then
		rc:SetMaterial(Group.FromCards(tc))
		if Duel.Release(tc,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)==0 then return end
		Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		rc:CompleteProcedure()
	end
end
