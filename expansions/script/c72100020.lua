--魔導原典 クロウリー
function c72100020.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SPELLCASTER),2,2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72100020,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,72100020+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c72100020.thcon)
	e1:SetTarget(c72100020.thtg)
	e1:SetOperation(c72100020.thop)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72100020,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCountLimit(1)
	e2:SetCondition(c72100020.ntcon)
	e2:SetTarget(c72100020.nttg)
	c:RegisterEffect(e2)
	-------
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,72110020+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c72100020.condition2)
	e3:SetCost(c72100020.cost2)
	e3:SetTarget(c72100020.target2)
	e3:SetOperation(c72100020.operation2)
	c:RegisterEffect(e3)
	-----
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72100020,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,72120020+EFFECT_COUNT_CODE_OATH)
	e4:SetCondition(c72100020.lkcon)
	e4:SetTarget(c72100020.lktg)
	e4:SetOperation(c72100020.lkop)
	c:RegisterEffect(e4)
end
function c72100020.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c72100020.thfilter(c)
	return c:IsSetCard(0x306e) and c:IsAbleToHand()
end
function c72100020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c72100020.thfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72100020.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c72100020.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,sg1)
		local cg=sg1:RandomSelect(1-tp,1)
		local tc=cg:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
function c72100020.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c72100020.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_SPELLCASTER)
end
------
function c72100020.condition2(e,tp,eg,ep,ev,re,r,rp,chk)
	return re:GetHandler():IsSetCard(0x206e)
end
function c72100020.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c72100020.filter2(c,tp,sc)
	return c:IsSetCard(0x206e) and c:IsFaceup() and Duel.IsExistingMatchingCard(c72100020.filter4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,c,sc)
end
function c72100020.filter4(c,tp,mc,sc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc),sc)>0
end
function c72100020.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c72100020.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,true,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_EXTRA)
end
function c72100020.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c72100020.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,c)
	local tc=tg:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		tg:Merge(Duel.SelectMatchingCard(tp,c72100020.filter4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,tc,tp,tc,c))
		if tg and Duel.SendtoGrave(tg,REASON_EFFECT)==2 then
			Duel.SpecialSummon(c,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP)
		end
	end
end
------
function c72100020.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c72100020.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c72100020.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end