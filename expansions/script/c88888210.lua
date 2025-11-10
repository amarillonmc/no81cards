--CAN:D 缤可卜
function c88888210.initial_effect(c)
	--to hand or set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888210,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,88888210)
	e1:SetTarget(c88888210.thtg)
	e1:SetOperation(c88888210.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--szone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88888210,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,18888210)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c88888210.xcon)
	e3:SetTarget(c88888210.xtg)
	e3:SetOperation(c88888210.xop)
	c:RegisterEffect(e3)
end
function c88888210.thfilter(c)
	if not (c:IsSetCard(0x8908) and c:IsType(TYPE_SPELL+TYPE_TRAP)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c88888210.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888210.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c88888210.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c88888210.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end
function c88888210.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c88888210.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x8908)
end
function c88888210.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c88888210.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88888210.xfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c88888210.xfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c88888210.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_ONFIELD) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Overlay(tc,Group.FromCards(c))
	local mg=tc:GetOverlayGroup():Filter(c88888210.spfilter,nil,e,tp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #mg>0
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(88888210,1),1},
		{b2,aux.Stringid(88888210,2),2},
		{true,aux.Stringid(88888210,3),3})
	if op==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=mg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	elseif op==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_SZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c88888210.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8908) and c:GetOwner()==tp and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end