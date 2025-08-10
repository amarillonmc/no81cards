-- 至高 至阳 天空的化身 (71200847)
local s,id=GetID()
function s.initial_effect(c)
    -- Xyz Summon
    aux.AddXyzProcedure(c,nil,10,2)
    c:EnableReviveLimit()
    
    -- ①: Xyz Summon effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(s.thcon)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    
    -- ②: Banish self effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(s.descost)
    e2:SetTarget(s.destg)
    e2:SetOperation(s.desop)
    c:RegisterEffect(e2)
    
    -- ③: Banished status effects
    -- ATK decrease
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_REMOVED)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetCondition(s.atkcon)
    e3:SetValue(s.atkval)
    c:RegisterEffect(e3)
    
    -- Return to Extra Deck (强制效果)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,3))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCountLimit(1)
    e4:SetCondition(s.retcon)
    e4:SetTarget(s.rettg)
    e4:SetOperation(s.retop)
    c:RegisterEffect(e4)
    
    -- Global flag for grave check
    local ge1=Effect.GlobalEffect()
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_TO_GRAVE)
    ge1:SetOperation(s.regop)
    Duel.RegisterEffect(ge1,0)
end

-- ①: Xyz Summon condition
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.thfilter(c)
    return c:IsCode(10045474) and c:IsAbleToHand() -- 无限泡影卡密
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

-- ②: Banish cost
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToRemove() end
    e:SetLabel(c:GetOverlayCount())
    Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    local ct=e:GetLabel()
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,ct,1-tp,LOCATION_ONFIELD)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    if ct<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,ct,ct,nil)
    if #g>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end

-- ③: ATK decrease condition
function s.atkcon(e)
    return e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_REMOVED)
end

function s.atkval(e,c)
    return Duel.GetFieldGroupCount(0,LOCATION_ONFIELD,0)*-200
end

-- Global grave registration
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    for p=0,1 do
        if eg:IsExists(Card.IsControler,1,nil,p) then
            Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
        end
    end
end

-- Return to Extra condition
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END 
        and e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_REMOVED)
        and Duel.GetFlagEffect(tp,id)==0
end

function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
end