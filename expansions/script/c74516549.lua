--人偶·德莱洁恩
function c74516549.initial_effect(c)
	aux.EnableDualAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74516549,0))
	e1:SetHintTiming(0,TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c74516549.con1)
	e1:SetCost(c74516549.spcost1)
	e1:SetTarget(c74516549.sptg)
	e1:SetOperation(c74516549.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(c74516549.con2)
	e2:SetCost(c74516549.spcost2)
	c:RegisterEffect(e2)
end
function c74516549.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() and not Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74516549.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c74516549.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() and aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74516549.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Recover(tp,1000,REASON_COST)
end
function c74516549.spfilter(c,e,tp)
	return c:IsSetCard(0x745) and not c:IsCode(74516549) and c:IsLevelBelow(4) and c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c74516549.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c74516549.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c74516549.thfilter(c)
	return c:IsSetCard(0x745) and c:IsAbleToHand()
end
function c74516549.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c74516549.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c74516549.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(74516549,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c74516549.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
				Duel.ShuffleHand(tp)
				Duel.BreakEffect()
				Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
			end
		end
	end
end
