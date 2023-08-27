--不 知 可 否 的 红 宝 石
local m=43990018
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,43990016)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCost(c43990018.spcost)
	e1:SetTarget(c43990018.sptg)
	e1:SetOperation(c43990018.spop)
	c:RegisterEffect(e1)
	--stt
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,43990018)
	e2:SetCost(c43990018.sacost)
	e2:SetTarget(c43990018.satg)
	e2:SetOperation(c43990018.saop)
	c:RegisterEffect(e2)
	
end
function c43990018.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToGraveAsCost()
end
function c43990018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990018.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c43990018.cfilter,1,1,REASON_COST,e:GetHandler())
end
function c43990018.tdfilter(c)
	return c:IsCode(43990016) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c43990018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43990018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c43990018.sacostfilter(c)
	return c:IsCode(43990016) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c43990018.sacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990018.sacostfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c43990018.sacostfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c43990018.stfilter(c,tp)
	return aux.IsCodeListed(c,43990016) and c:CheckActivateEffect(false,true,false)~=nil and (c:GetType()==0x20002 or c:GetType()==0x20004 or c:GetType()==0x80002) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c43990018.satg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c43990018.stfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
end
function c43990018.saop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c43990018.stfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and tc:GetType()==0x80002 then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end