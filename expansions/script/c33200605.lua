--圣殿剑骑 赫纳斯
function c33200605.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200605,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33200605)
	e1:SetCondition(c33200605.spcon)
	e1:SetTarget(c33200605.sptg)
	e1:SetOperation(c33200605.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200605,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,33200606)
	e2:SetTarget(c33200605.thtg)
	e2:SetOperation(c33200605.thop)
	c:RegisterEffect(e2)
end

--e1
function c33200605.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c33200605.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk))
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv+2,greater_or_equal)
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv+2,tp,c,lv+2,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function c33200605.rfilter(c,e,tp)
	return c:IsSetCard(0x5329)
end
function c33200605.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200605.RitualUltimateFilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,c33200605.rfilter,e,tp,mg,nil,Card.GetLevel,"Equal") end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c33200605.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c33200605.RitualUltimateFilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,c33200605.rfilter,e,tp,mg,nil,Card.GetLevel,"Equal")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel()+2,"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel()+2,tp,tc,tc:GetLevel()+2,"Equal")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--e2
function c33200605.thfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33200605.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsAbleToHand() and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(c33200605.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33200605.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33200605.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tc:GetControler(),tc)
		Duel.ShuffleHand(tc:GetControler())
	end
end