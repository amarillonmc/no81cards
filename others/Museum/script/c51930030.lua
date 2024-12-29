--魔餐的狂欢
function c51930030.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,51930030)
	e1:SetTarget(c51930030.destg)
	e1:SetOperation(c51930030.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c51930030.sptg)
	e2:SetOperation(c51930030.spop)
	c:RegisterEffect(e2)
end
function c51930030.tdfilter(c)
	return c:IsSetCard(0x5258) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function c51930030.cfilter(c)
	return c:IsSetCard(0x5258) and c:IsFaceup()
end
function c51930030.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c51930030.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local ct=Duel.IsExistingMatchingCard(c51930030.cfilter,tp,LOCATION_MZONE,0,1,nil) and 2 or 1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c51930030.desop(e,tp,eg,ep,ev,re,r,rp)
	--to deck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c51930030.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #tg==0 or Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	--destroy
	local g=Duel.GetTargetsRelateToChain()
	Duel.Destroy(g,REASON_EFFECT)
end
function c51930030.tgfilter(c,e,tp)
	return c:IsSetCard(0x5258) and c:IsLevelAbove(1) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c51930030.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,c:GetLevel())
end
function c51930030.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x5258) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 and c:IsLevel(lv) and c:IsFaceup()
end
function c51930030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51930030.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c51930030.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c51930030.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(c51930030.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,tc:GetLevel()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c51930030.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,tc:GetLevel()):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
