--红锈结界
local id=32000224
local zd=0xff6
function c32000224.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--SpSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
	e2:SetTarget(c32000224.e2tg)
	e2:SetCondition(c32000224.e2con)
	e2:SetOperation(c32000224.e2op)
	c:RegisterEffect(e2)
	 --IgnitionSelfToHand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c32000224.e3tg)
	e3:SetOperation(c32000224.e3op)
	c:RegisterEffect(e3)
	--IgnitionAdToHand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,id+1+EFFECT_COUNT_CODE_OATH)
	e4:SetTarget(c32000224.e4tg)
	e4:SetOperation(c32000224.e4op)
	c:RegisterEffect(e4)
end

--e2
function c32000224.e2spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32000224.e2con(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandlerPlayer()==1-tp
end
function c32000224.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000224.e1spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
end
function c32000224.e2op(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(c32000224.e2spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c32000224.e2spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
     Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end

--e3

function c32000224.e3desfilter(c)
	return c:IsSetCard(zd) and c:IsDestructable()
end

function c32000224.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000224.e3desfilter,tp,LOCATION_ONFIELD,0,1,nil) and Card.IsAbleToHand(e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end

function c32000224.e3op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000224.e3desfilter,tp,LOCATION_ONFIELD,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTORY)
	local g=Duel.SelectMatchingCard(tp,c32000224.e3desfilter,tp,LOCATION_ONFIELD,0,1,2,nil)
    Duel.Destroy(g,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	
	if not (Card.IsAbleToHand(e:GetHandler())) then return end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end

--e4
function c32000224.e4tohfilter(c)
	return c:IsSetCard(zd) and c:IsAbleToHand()
end

function c32000224.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000224.e4tohfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c32000224.e4op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000224.e4tohfilter,tp,LOCATION_DECK,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32000224.e4tohfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
	

	
	