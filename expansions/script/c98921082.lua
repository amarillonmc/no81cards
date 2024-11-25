--北极天熊-星辉白熊
function c98921082.initial_effect(c)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98921082)
	e3:SetTarget(c98921082.thtg)
	e3:SetOperation(c98921082.thop)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,98931082)
	e2:SetCondition(c98921082.sumcon)
	e2:SetCost(c98921082.sumcost)
	e2:SetTarget(c98921082.sumtg)
	e2:SetOperation(c98921082.sumop)
	c:RegisterEffect(e2)
end
function c98921082.thfilter(c)
	return c:IsSetCard(0x163) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsAbleToHand()
end
function c98921082.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921082.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98921082.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98921082.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98921082.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c98921082.costfilter(c,e,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsSetCard(0x163)
end
function c98921082.rfilter(c,tp)
	return c:IsSetCard(0x163) and (c:IsControler(tp) or c:IsFaceup())
end
function c98921082.excostfilter(c,tp)
	return c:IsAbleToRemove() and (c:IsHasEffect(16471775,tp) or c:IsHasEffect(89264428,tp))
end
function c98921082.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp):Filter(c98921082.rfilter,nil,tp)
	local g2=Duel.GetMatchingGroup(c98921082.excostfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),tp)
	g1:Merge(g2)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and g1:IsExists(c98921082.costfilter,1,nil,e,tp) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g1:FilterSelect(tp,c98921082.costfilter,1,1,nil,e,tp)
	local tc=rg:GetFirst()
	local te=tc:IsHasEffect(16471775,tp) or tc:IsHasEffect(89264428,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		aux.UseExtraReleaseCount(rg,tp)
		Duel.Release(tc,REASON_COST)
		if tc:IsType(TYPE_SYNCHRO) then e:SetLabel(100,1) end
	end
end
function c98921082.sumfilter(c)
	return c:IsSetCard(0x8e) and c:IsSummonable(true,nil)
end
function c98921082.filter(c,e,tp,check)
	return c:IsSetCard(0x163) and (c:IsLevel(1) or check) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98921082.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=true
	local l1,l2=e:GetLabel()
	if chk==0 then 
		if chk==0 then
		if l1~=100 then check=false end
		e:SetLabel(0,0)
		return Duel.IsExistingMatchingCard(c98921082.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,check) end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98921082.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=false
	local l1,l2=e:GetLabel()
	if l2==1 then check=true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98921082.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,check)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end