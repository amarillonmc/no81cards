--最后的潜海奇袭
function c88880746.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--code
	aux.EnableChangeCode(c,22702055,LOCATION_SZONE)
end
	function c88880746.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88880746+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c88880746.target)
	e1:SetOperation(c88880746.activate)
	c:RegisterEffect(e1)
end
function c88880746.filter(c)
	return aux.IsCodeListed(c,22702055) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function c88880746.spfilter(c,e,tp)
	return aux.IsCodeListed(c,22702055)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88880746.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c88880746.filter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c88880746.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAN)
end
function c88880746.activate(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local op=0
	local b1=Duel.IsExistingMatchingCard(c88880746.filter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c88880746.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	if b1 then
		if not b2 or Duel.SelectYesNo(tp,aux.Stringid(88880746,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c88880746.filter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
			op=1
		end
	end
	b2=Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c88880746.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	if b2 and (op==0 or ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.SelectYesNo(tp,aux.Stringid(88880746,2))) then
		if op~=0 then
			Duel.BreakEffect()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c88880746.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end