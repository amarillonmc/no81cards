--墓 园 死 者 历 战 遗 骨
local m=22348093
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--TO GRAVE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348093,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22348093)
	e1:SetTarget(c22348093.tgtg)
	e1:SetOperation(c22348093.tgop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348093,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22348093)
	e2:SetCost(c22348093.spcost)
	e2:SetTarget(c22348093.sptg)
	e2:SetOperation(c22348093.spop)
	c:RegisterEffect(e2)
	
end
function c22348093.thfilter(c)
	return c:IsSetCard(0x703) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)   
end
function c22348093.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c22348093.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsPreviousControler(tp) and Duel.IsExistingMatchingCard(c22348093.thfilter,tp,LOCATION_DECK,0,1,nil) and tc:IsLocation(LOCATION_GRAVE) and Duel.SelectYesNo(tp,aux.Stringid(22348093,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c22348093.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
-- Duel.IsExistingMatchingCard(c22348093.thfilter,tp,LOCATION_DECK,0,1,nil) and 
function c22348093.spcostfilter(c,tp)
	return c:IsSetCard(0x703) and c:IsFaceup() and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c22348093.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348093.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348093.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22348093.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22348093.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end











