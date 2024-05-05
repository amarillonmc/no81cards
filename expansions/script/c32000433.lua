--武色僚机

local id=32000433
local zd=0x3c5
function c32000433.initial_effect(c)

    --activeSpSumAndEquip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c32000433.e1tg)
	e1:SetOperation(c32000433.e1op)
	c:RegisterEffect(e1)
	
	--DeckToGraveWhenDestroyedOrSendToGrave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(c32000433.e2con)
	e2:SetTarget(c32000433.e2tg)
	e2:SetOperation(c32000433.e2op)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
	
	
end

--e1

function c32000433.e1spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c32000433.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c32000433.e1spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end

function c32000433.e1op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c32000433.e1spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp)) then return end
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32000433.e1spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	
	local c=e:GetHandler()
	if not (c:IsLocation(LOCATION_SZONE)) then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Equip(tp,c,g2:GetFirst())
	
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(true)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

--e2

function c32000433.e2togfilter(c)
    return c:IsSetCard(zd) and c:IsAbleToGrave() and not c:IsCode(id)
end

function c32000433.e2con(e,tp,eg,ep,ev,re,r,rp,chk)
    return e:GetHandler():IsReason(REASON_EFFECT) and re and re:GetHandler():IsSetCard(zd)
end

function c32000433.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000433.e2togfilter,tp,LOCATION_DECK,0,1,nil) end

	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c32000433.e2op(e,tp,eg,ep,ev,re,r,rp)
	 if not (Duel.IsExistingMatchingCard(c32000433.e2togfilter,tp,LOCATION_DECK,0,1,nil)) then return end 
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c32000433.e2togfilter,tp,LOCATION_DECK,0,1,1,nil)
	
	Duel.SendtoGrave(g,nil,REASON_EFFECT)
end














