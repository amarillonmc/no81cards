--战车道极限装填
function c9910152.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910152)
	e1:SetTarget(c9910152.target)
	e1:SetOperation(c9910152.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910153)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910152.mattg)
	e2:SetOperation(c9910152.matop)
	c:RegisterEffect(e2)
end
function c9910152.xmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910152.spfilter(c,e,tp)
	return c:IsCode(9910105) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910152.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsCanOverlay() and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_HAND,0,1,c)
		and Duel.IsExistingMatchingCard(c9910152.xmfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsExistingMatchingCard(c9910152.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,c)>0
	if chk==0 then return b1 or b2 end
end
function c9910152.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsRelateToEffect(e) and c:IsCanOverlay() and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_HAND,0,1,c)
		and Duel.IsExistingMatchingCard(c9910152.xmfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsExistingMatchingCard(c9910152.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,c)>0
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9910152,0),aux.Stringid(9910152,1))+1
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9910152,0))+1
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9910152,1))+2
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g1=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_HAND,0,1,1,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,c9910152.xmfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(tg)
		if tg:GetFirst():IsImmuneToEffect(e) then return end
		g1:AddCard(c)
		c:CancelToGrave()
		Duel.Overlay(tg:GetFirst(),g1)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c9910152.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g2>0 and Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
			Duel.BreakEffect()
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function c9910152.matfilter(c)
	return c:IsSetCard(0x9958) and c:IsCanOverlay()
end
function c9910152.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910152.xmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910152.xmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910152.matfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910152.xmfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9910152.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c9910152.matfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
