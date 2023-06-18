--转生炎兽 狮鹫
function c98921022.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921022,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98921022)
	e1:SetTarget(c98921022.sptg)
	e1:SetOperation(c98921022.spop)
	c:RegisterEffect(e1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921022,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98931022)
	e1:SetCost(c98921022.cost)
	e1:SetTarget(c98921022.tg)
	e1:SetOperation(c98921022.op)
	c:RegisterEffect(e1)
	--ritual summon
	local e2=aux.AddRitualProcGreater2(c,c98921022.rfilter,LOCATION_HAND+LOCATION_DECK,nil,c98921022.mfilter,true)
	e2:SetDescription(aux.Stringid(98921022,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,98921022)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c98921022.rscon)
	c:RegisterEffect(e2)
end
function c98921022.spfilter(c,e,tp,ec)
	local zone=c:GetLinkedZone(tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_LINK) and ec:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c98921022.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98921022.spfilter(chkc,e,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(c98921022.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98921022.spfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c98921022.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local zone=tc:GetLinkedZone(tp)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and zone&0x1f~=0 then
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c98921022.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x119) and c:IsAbleToHand()
end
function c98921022.filter2(c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c98921022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c98921022.rfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c98921022.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c98921022.tg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c98921022.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c98921022.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c98921022.op(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(c98921022.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c98921022.filter2,tp,LOCATION_DECK,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98921022.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c98921022.filter2,tp,LOCATION_DECK,0,1,1,nil)
	g:Merge(g2)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
function c98921022.rfilter(c,e,tp,chk)
	return c:IsSetCard(0x119)
end
function c98921022.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x119) and c:IsType(TYPE_LINK)
end
function c98921022.rscon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()~=tp and Duel.IsExistingMatchingCard(c98921022.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c98921022.mfilter(c)
	return not c:IsLocation(LOCATION_HAND)
end