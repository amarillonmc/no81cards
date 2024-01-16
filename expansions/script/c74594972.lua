--教团终端·SID72
function c74594972.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--dual summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74594972,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,74594972)
	e1:SetTarget(c74594972.sumtg)
	e1:SetOperation(c74594972.sumop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(74594972,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,84594972)
	e3:SetTarget(c74594972.tdtg)
	e3:SetOperation(c74594972.tdop)
	c:RegisterEffect(e3)
	--ritual summon
	local e4=aux.AddRitualProcEqual2(c,c74594972.rsfilter,LOCATION_HAND,nil,nil,true)
	e4:SetDescription(aux.Stringid(74594972,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,94594972)
	c:RegisterEffect(e4)
end
function c74594972.filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and c:IsSetCard(0x745) and c:IsSummonable(true,nil) and (not e or c:IsRelateToEffect(e)) and not c:IsHasEffect(74594972) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c74594972.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c74594972.filter,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,eg,1,0,0)
end
function c74594972.sumop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c74594972.filter,nil,e,tp)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
	if not tc then return end
	Duel.Summon(tp,tc,true,nil)
end
function c74594972.rfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c74594972.tdfilter(c,check)
	return c:IsSetCard(0x745) and c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or (check and c:IsFaceup()))
end
function c74594972.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.IsExistingMatchingCard(c74594972.rfilter,tp,LOCATION_MZONE,0,1,nil)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c74594972.tdfilter(chkc,check) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c74594972.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil,check) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c74594972.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil,check)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c74594972.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if not tg then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c74594972.rsfilter(c)
	return c:IsSetCard(0x745)
end
