--赛博空间坍缩
function c9910406.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9910406)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910406.target)
	e1:SetOperation(c9910406.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910406)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910406.sptg)
	e2:SetOperation(c9910406.spop)
	c:RegisterEffect(e2)
end
function c9910406.cfilter(c,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and lv>=4
		and Duel.GetDecktopGroup(1-tp,lv-3):FilterCount(Card.IsAbleToRemove,nil)==lv-3
end
function c9910406.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910406.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910406.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c9910406.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,tc:GetLevel()-3,1-tp,LOCATION_DECK)
end
function c9910406.rmfilter(c,cardtype)
	return c:IsSetCard(0x6950) and c:IsType(cardtype) and c:IsAbleToRemove()
end
function c9910406.gcheck(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function c9910406.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ct=tc:GetLevel()-3
	if ct<=0 then return end
	local g=Duel.GetDecktopGroup(1-tp,ct)
	if #g==0 then return end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	if #og==0 then return end
	Duel.HintSelection(og)
	local cardtype=0
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then cardtype=cardtype+TYPE_MONSTER end
	if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then cardtype=cardtype+TYPE_SPELL end
	if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then cardtype=cardtype+TYPE_TRAP end
	local tg=Duel.GetMatchingGroup(c9910406.rmfilter,tp,LOCATION_DECK,0,nil,cardtype)
	if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(9910406,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=tg:SelectSubGroup(tp,c9910406.gcheck,false,1,3)
		if sg then
			Duel.DisableShuffleCheck(false)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c9910406.spfilter(c,e,tp)
	return c:IsSetCard(0x6950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c9910406.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910406.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function c9910406.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910406.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()<=0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
