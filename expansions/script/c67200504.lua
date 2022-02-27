--珊海环的幽灵舰长
function c67200504.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c67200504.matfilter1,nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x675),1,1)
	c:EnableReviveLimit()  
	--to deck and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200504,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,67200504)
	e1:SetTarget(c67200504.drtg)
	e1:SetOperation(c67200504.drop)
	c:RegisterEffect(e1)  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200504,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c67200504.spcon)
	e2:SetTarget(c67200504.sptg)
	e2:SetOperation(c67200504.spop)
	c:RegisterEffect(e2)
end
function c67200504.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x675)
end
--
function c67200504.filter(c)
	return c:IsAbleToDeck()
end
function c67200504.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200504.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c67200504.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c67200504.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c67200504.filter,tp,LOCATION_GRAVE,0,nil)
	if aux.NecroValleyNegateCheck(tg) then return end
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--
function c67200504.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_GRAVE,0,1,e:GetHandler())
end
function c67200504.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67200504.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end

