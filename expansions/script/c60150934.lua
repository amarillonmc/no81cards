--幻致的再构造
function c60150934.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60150934+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c60150934.target)
    e1:SetOperation(c60150934.activate)
    c:RegisterEffect(e1)
	--to hand
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCondition(aux.exccon)
    e1:SetCost(c60150934.thcost)
    e1:SetTarget(c60150934.thtg)
    e1:SetOperation(c60150934.thop)
    c:RegisterEffect(e1)
end
function c60150934.cfilter(c,tp)
    return c:IsSetCard(0x6b23) and c:IsType(TYPE_TOKEN) and c:IsDestructable()
end
function c60150934.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60150934.cfilter,tp,LOCATION_MZONE,0,1,nil) end
    local g=Duel.GetMatchingGroup(c60150934.cfilter,tp,LOCATION_MZONE,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c60150934.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60150934.cfilter,tp,LOCATION_MZONE,0,nil)
    local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct~=0 then
		Duel.Draw(tp,ct+1,REASON_EFFECT)
	end
end
function c60150934.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60150934.thfilter(c)
    return c:IsSetCard(0x6b23) and c:IsAbleToHand()
end
function c60150934.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60150934.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60150934.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60150934.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end