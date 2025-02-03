--庆祝之铠
function c75010017.initial_effect(c)
	--spsummon-other
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75010017+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75010017.target)
	e1:SetOperation(c75010017.activate)
	c:RegisterEffect(e1)
	--select
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c75010017.slcon)
	e2:SetTarget(c75010017.sltg)
	e2:SetOperation(c75010017.slop)
	c:RegisterEffect(e2)
end
function c75010017.rsfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:IsType(TYPE_RITUAL) and Duel.IsPlayerCanDiscardDeck(tp,c:GetLevel())
end
function c75010017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c75010017.rsfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c75010017.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75010017.rsfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if not sc then return end
	Duel.DiscardDeck(tp,sc:GetLevel(),REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
	Duel.BreakEffect()
	local og=Duel.GetOperatedGroup()
	sc:SetMaterial(og)
	Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	sc:CompleteProcedure()
	--effect
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c75010017.indtg)
	e2:SetValue(c75010017.efilter)
	sc:RegisterEffect(e2)
end
function c75010017.eqlimit(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_RITUAL)
end
function c75010017.indtg(e,c)
	local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
	return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c75010017.efilter(e,te)
	if not te:IsActivated() then return false end
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c75010017.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function c75010017.slcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c75010017.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c75010017.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75010017.sltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c75010017.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,75010017)==0
	local b2=Duel.IsExistingMatchingCard(c75010017.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.GetFlagEffect(tp,75010018)==0
	if chk==0 then return b1 or b2 end
end
function c75010017.slop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c75010017.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,75010017)==0
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c75010017.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.GetFlagEffect(tp,75010018)==0
	local op=aux.SelectFromOptions(tp,
		{b1,1190},
		{b2,1152})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c75010017.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
		Duel.RegisterFlagEffect(tp,75010017,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75010017.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.RegisterFlagEffect(tp,75010018,RESET_PHASE+PHASE_END,0,1)
	end
end
