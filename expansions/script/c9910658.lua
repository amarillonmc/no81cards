--拉尼亚凯亚之飓风
function c9910658.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910658,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9910658)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c9910658.tgtg)
	e2:SetOperation(c9910658.tgop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910658,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9910658)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c9910658.xmtg)
	e3:SetOperation(c9910658.xmop)
	c:RegisterEffect(e3)
	--xyz summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,9910675)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c9910658.xyztg)
	e4:SetOperation(c9910658.xyzop)
	c:RegisterEffect(e4)
end
function c9910658.tgfilter(c)
	return c:IsSetCard(0xa952) and c:IsAbleToGrave()
end
function c9910658.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910658.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9910658.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910658.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c9910658.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa952)
end
function c9910658.xmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910658.xmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_GRAVE
	if Duel.IsExistingMatchingCard(c9910658.cfilter,tp,LOCATION_MZONE,0,1,nil) then loc=LOCATION_ONFIELD+LOCATION_GRAVE end
	if chkc then return (chkc:IsLocation(LOCATION_GRAVE) or (chkc:IsLocation(loc) and chkc:IsControler(1-tp)))
		and chkc:IsCanOverlay(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanOverlay,tp,LOCATION_GRAVE,loc,1,nil,tp)
		and Duel.IsExistingMatchingCard(c9910658.xmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,Card.IsCanOverlay,tp,LOCATION_GRAVE,loc,1,1,nil,tp)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function c9910658.xmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c9910658.xmfilter,tp,LOCATION_MZONE,0,1,nil) and tc:IsCanOverlay(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,c9910658.xmfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(tg)
		if tg:GetFirst():IsImmuneToEffect(e) then return end
		local og=tc:GetOverlayGroup()
		if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
		tc:CancelToGrave()
		Duel.Overlay(tg:GetFirst(),Group.FromCards(tc))
	end
end
function c9910658.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910658.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end
