--自奏圣乐的残音
function c79029527.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,79029527+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c79029527.cost)
	e1:SetTarget(c79029527.target)
	e1:SetOperation(c79029527.activate)
	c:RegisterEffect(e1)
end
function c79029527.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c79029527.filter1(c,e,tp)
	local lv=c:GetLink()
	local rg=Duel.GetMatchingGroup(c79029527.filter3,tp,LOCATION_REMOVED,0,nil)
	return c:IsType(TYPE_LINK) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and rg:GetCount()>=lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c79029527.filter3(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c79029527.filter2(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x11b) 
end
function c79029527.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029527.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029527.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c79029527.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	if tc then
		local lv=tc:GetLink()
		local rg=Duel.GetMatchingGroup(c79029527.filter3,tp,LOCATION_REMOVED,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=rg:Select(tp,lv,lv,nil)
		Duel.SendtoDeck(g3,nil,2,REASON_EFFECT)
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
	if not Duel.IsExistingMatchingCard(c79029527.filter2,tp,LOCATION_ONFIELD,0,1,nil) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(79029527,0)) then
	local gb=Duel.GetDecktopGroup(tp,lv)
	Duel.SendtoGrave(gb,REASON_EFFECT) 
	end
	end
end












