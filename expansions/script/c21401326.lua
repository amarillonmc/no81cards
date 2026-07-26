--熔岩猫头鹰
local s,id,o=GetID()
function s.initial_effect(c)
	--①：展示这张卡，检索后丢弃1张手卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+1)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--②：被效果送去墓地的场合，特殊召唤墓地·除外的「熔岩」怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+2)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.listed_series={0x0039}

--①
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:IsPublic()
	end
	Duel.ConfirmCards(1-tp,c)
end

function s.thfilter(c)
	return c:IsSetCard(0x0039)
		and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(
			s.thfilter,tp,LOCATION_DECK,0,1,nil
		)
	end
	Duel.SetOperationInfo(
		0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK
	)
	Duel.SetOperationInfo(
		0,CATEGORY_HANDES,nil,0,tp,1
	)
end

function s.disfilter(c)
	return c:IsDiscardable(REASON_EFFECT)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(
		tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil
	)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then
		return
	end
	Duel.ConfirmCards(1-tp,g)
	Duel.BreakEffect()

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dg=Duel.SelectMatchingCard(
		tp,s.disfilter,tp,LOCATION_HAND,0,1,1,nil
	)
	if #dg>0 then
		Duel.SendtoGrave(
			dg,REASON_EFFECT+REASON_DISCARD
		)
	end
end

--②
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x0039)
		and c:IsType(TYPE_MONSTER)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(
				LOCATION_GRAVE+LOCATION_REMOVED
			)
			and aux.NecroValleyFilter(s.spfilter)(
				chkc,e,tp
			)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(
				aux.NecroValleyFilter(s.spfilter),
				tp,
				LOCATION_GRAVE+LOCATION_REMOVED,
				0,1,nil,e,tp
			)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(
		tp,
		aux.NecroValleyFilter(s.spfilter),
		tp,
		LOCATION_GRAVE+LOCATION_REMOVED,
		0,1,1,nil,e,tp
	)
	Duel.SetOperationInfo(
		0,CATEGORY_SPECIAL_SUMMON,g,1,tp,
		LOCATION_GRAVE+LOCATION_REMOVED
	)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc
		or not tc:IsRelateToEffect(e)
		or aux.NecroValleyNegateCheck(tc)
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	Duel.SpecialSummon(
		tc,0,tp,tp,false,false,POS_FACEUP
	)
end