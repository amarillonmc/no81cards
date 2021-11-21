--时间潜行者交错
function c18678558.initial_effect(c)

	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetCode(EFFECT_SPSUMMON_PROC)
	e01:SetDescription(aux.Stringid(18678558,0))
	e01:SetRange(LOCATION_EXTRA)
	e01:SetCountLimit(1,18678553)
	e01:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCondition(c18678558.xyzcon)
	e01:SetOperation(c18678558.xyzop)
	e01:SetValue(SUMMON_TYPE_XYZ)
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e02:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e02:SetTargetRange(0xff,0)
	e02:SetRange(LOCATION_DECK)
	e02:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x126))
	e02:SetLabelObject(e01)
	c:RegisterEffect(e02)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18678558,3))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c18678558.target)
	e1:SetCountLimit(1,18678559)
	e1:SetOperation(c18678558.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c18678558.actcon)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18678558,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,18678558)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c18678558.sptg)
	e3:SetOperation(c18678558.spop)
	c:RegisterEffect(e3)
end

function c18678558.xyzfilter1(c,lc,tp)
	return c:IsCode(18678558) and c:IsLocation(LOCATION_DECK)
end
function c18678558.xyzfilter2(c,lc,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsLevel(4) and c:IsCanBeXyzMaterial(lc) and c:IsSetCard(0x126)
end
function c18678558.xyzcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c18678558.xyzfilter1,tp,LOCATION_DECK,0,nil,c,tp)
	local mg2=Duel.GetMatchingGroup(c18678558.xyzfilter2,tp,LOCATION_MZONE,0,nil,c,tp)
	mg:Merge(mg2)
	return Duel.IsExistingMatchingCard(c18678558.xyzfilter1,tp,LOCATION_DECK,0,1,nil,c,tp) and Duel.IsExistingMatchingCard(c18678558.xyzfilter2,tp,LOCATION_MZONE,0,1,nil,c,tp) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c18678558.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c18678558.xyzfilter1,tp,LOCATION_DECK,0,1,1,nil,c,tp)
	local g2=Duel.SelectMatchingCard(tp,c18678558.xyzfilter2,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	g1:Merge(g2)
	local sg=Group.CreateGroup()
	local tc=g1:GetFirst()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end

function c18678558.tgfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c18678558.thfilter,tp,LOCATION_DECK,0,1,nil,c) and c:IsSetCard(0x126)
end
function c18678558.thfilter(c,tc)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and c:IsRace(tc:GetRace()) and not c:IsCode(tc:GetCode())
end
function c18678558.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c18678558.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c18678558.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c18678558.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18678558.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c18678558.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function c18678558.filter(c,e,tp)
	return c:IsSetCard(0x126) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c18678558.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c18678558.filter(chkc,e,tp) end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c18678558.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c18678558.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c18678558.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 and e:GetHandler():IsLocation(LOCATION_DECK) then
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function c18678558.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()==tp 
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
