--幻致的结界 冰之槛
function c60150932.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60150932+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c60150932.cost)
    e1:SetOperation(c60150932.activate)
    c:RegisterEffect(e1)
end
function c60150932.cfilter(c,tp)
    return c:IsSetCard(0x6b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() 
        and ((c:IsLocation(LOCATION_DECK) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
end
function c60150932.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60150932.cfilter,tp,LOCATION_HAND,LOCATION_DECK,1,nil,tp) end
    local cg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
    Duel.ConfirmCards(tp,cg)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60150932.cfilter,tp,LOCATION_HAND,LOCATION_DECK,1,1,nil,tp)
    Duel.SendtoGrave(g,REASON_COST)
end
function c60150932.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    --disable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e1:SetTarget(c60150932.distarget)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    --disable effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetOperation(c60150932.disoperation)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
    --disable trap monster
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
    e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e3:SetTarget(c60150932.distarget2)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
    --disable trap monster
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_REMOVE)
    e4:SetTargetRange(0,LOCATION_GRAVE)
    e4:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e4,tp)
end
function c60150932.distarget(e,c)
    return c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function c60150932.distarget2(e,c)
    return c:IsType(TYPE_TRAP)
end
function c60150932.disoperation(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_ONFIELD and re:IsActiveType(TYPE_TRAP+TYPE_SPELL) then
        Duel.NegateEffect(ev)
    end
end