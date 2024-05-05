--武色机仓

local id=32000435
local zd=0x3c5
function c32000435.initial_effect(c)

    --active
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--Ad2AndReturn2ToDeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(c32000435.e2con)
	e2:SetTarget(c32000435.e2tg)
	e2:SetOperation(c32000435.e2op)
	c:RegisterEffect(e2)
	
	--AToHandWhenOpStandby
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1,id+1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c32000435.e3con)
	e3:SetTarget(c32000435.e3tg)
	e3:SetOperation(c32000435.e3op)
	c:RegisterEffect(e3)
	
	--DesMonAndSpSumDGWhenDestroyedOrSendToGrave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,id+2)
	e4:SetTarget(c32000435.e4tg)
	e4:SetOperation(c32000435.e4op)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	
	
end



--e2

function c32000435.e2tohfilter(c)
    return c:IsSetCard(zd) and c:IsAbleToHand()
end

function c32000435.e2con(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 or Duel.GetCurrentPhase()==PHASE_BATTLE) and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end

function c32000435.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000435.e2tohfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,nil) end

	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND+LOCATION_ONFIELD)
end

function c32000435.e2op(e,tp,eg,ep,ev,re,r,rp)
	 if not (Duel.IsExistingMatchingCard(c32000435.e2tohfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil)) then return end 
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32000435.e2tohfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	
	if not (Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,g)) then return end 
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,g)
	Duel.SendtoDeck(g2,tp,2,REASON_EFFECT)
	
end


--e3

function c32000435.e3tohfilter(c)
    return c:IsSetCard(zd) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function c32000435.e3con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function c32000435.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000435.e3tohfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end

function c32000435.e3op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000435.e3tohfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) ) then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32000435.e3tohfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end


--e4

function c32000435.e4spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end

function c32000435.e4desfilter(c)
    return c:IsSetCard(zd) and c:IsDestructable()
end

function c32000435.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000435.e4desfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c32000435.e4spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function c32000435.e4op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000435.e4desfilter,tp,LOCATION_MZONE,0,1,nil)) then return end 

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c32000435.e4desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_EFFECT)
	
    if not (Duel.IsExistingMatchingCard(c32000435.e4spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)) then return end
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c32000435.e4spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)

end







