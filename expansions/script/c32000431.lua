--武色站点

local id=32000431
local zd=0x3c5
function c32000431.initial_effect(c)

    --active
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	 --AToHandWhenCainingMonster
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,id)
	e2:SetCondition(c32000431.e2con)
	e2:SetTarget(c32000431.e2tg)
	e2:SetOperation(c32000431.e2op)
	c:RegisterEffect(e2)
	
	--RemoveDeckCardWhenDestroyedOrSendToGrave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(c32000431.e3con)
	e3:SetTarget(c32000431.e3tg)
	e3:SetOperation(c32000431.e3op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
	
end

--e2

function c32000431.e2tohfilter(c)
    return c:IsSetCard(zd) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c32000431.e2con(e,tp,eg,ep,ev,re,r,rp,chk)
    return re:GetHandler():IsType(TYPE_MONSTER)
end

function c32000431.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000431.e2tohfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end

	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end

function c32000431.e2op(e,tp,eg,ep,ev,re,r,rp)
	 if not (Duel.IsExistingMatchingCard(c32000431.e2tohfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil)) then return end 
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32000431.e2tohfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end

--e3

function c32000431.e3rmfilter(c)
    return c:IsSetCard(zd) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove() and not c:IsCode(id)
end

function c32000431.e3con(e,tp,eg,ep,ev,re,r,rp,chk)
    return e:GetHandler():IsReason(REASON_EFFECT) and re and re:GetHandler():IsSetCard(zd)
end

function c32000431.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000431.e3rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end

	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end

function c32000431.e3op(e,tp,eg,ep,ev,re,r,rp)
	 if not (Duel.IsExistingMatchingCard(c32000431.e3rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)) then return end 
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c32000431.e3rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end












