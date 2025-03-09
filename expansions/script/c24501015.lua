-- 支援型神威骑士
function c24501015.initial_effect(c)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c24501015.spcon)
	e1:SetTarget(c24501015.sptg)
	e1:SetOperation(c24501015.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCountLimit(1,24501015)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c24501015.tgtg)
	e3:SetOperation(c24501015.tgop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c24501015.thtg)
	e4:SetOperation(c24501015.thop)
	c:RegisterEffect(e4)
end
-- 1
function c24501015.chkfilter(c)
	return c:IsLevelAbove(8) and c:IsSetCard(0x501) and c:IsFaceup()
end
function c24501015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24501015.chkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c24501015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c24501015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
-- 2
function c24501015.tgfilter(c)
	return c:IsSetCard(0x501) and c:IsAbleToGrave()
end
function c24501015.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501015.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler())   end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c24501015.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c24501015.tgfilter,tp,LOCATION_DECK,0,1,2,nil)
	if #tg>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
		if tg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==0 then return end
		local c=e:GetHandler()
		if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),c)
		end
	end
end
-- 3
function c24501015.thfilter(c)
	return c:IsSetCard(0x501) and c:IsAbleToHand()
end
function c24501015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501015.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c24501015.tffilter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x501) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c24501015.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c24501015.thfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local g=Duel.GetMatchingGroup(c24501015.tffilter,tp,LOCATION_HAND,0,nil,tp)
		if Duel.IsEnvironment(24501035,tp,LOCATION_FZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(24501015,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,1,nil)
			Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
