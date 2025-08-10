-- 绝灭者 阳雷的业果 晨昏之眼 (71200848)
local s,id=GetID()
function s.initial_effect(c)
    -- Xyz Summon
    aux.AddXyzProcedure(c,nil,12,2)
    c:EnableReviveLimit()
    
    -- ①: Xyz Summon effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(s.sumcon)
    e1:SetTarget(s.sumtg)
    e1:SetOperation(s.sumop)
    c:RegisterEffect(e1)
    
    -- ②: Banish self effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(s.bancost)
    e2:SetTarget(s.bantg)
    e2:SetOperation(s.banop)
    c:RegisterEffect(e2)
    
    -- ③: Banished status effects
    -- Disable low ATK monsters
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetRange(LOCATION_REMOVED)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetTarget(s.distg)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_DISABLE_EFFECT)
    c:RegisterEffect(e4)
    
    -- Return to Extra Deck (强制效果)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,3))
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetRange(LOCATION_REMOVED)
    e5:SetCountLimit(1)
    e5:SetCondition(s.retcon)
    e5:SetTarget(s.rettg)
    e5:SetOperation(s.retop)
    c:RegisterEffect(e5)
    
    -- Global flag for grave check
    local ge1=Effect.GlobalEffect()
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_TO_GRAVE)
    ge1:SetOperation(s.regop)
    Duel.RegisterEffect(ge1,0)
end

-- ①: Xyz Summon condition
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.setfilter(c)
    return c:IsCode(24299458) and c:IsSSetable() -- 禁忌的一滴卡密
end

function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,3000)
    Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,e:GetHandler(),1,0,3000)
    Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,0,tp,LOCATION_DECK+LOCATION_HAND)
end

function s.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        -- ATK/DEF increase
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(3000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
        
        -- Set "Forbidden Droplet"
        local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
        if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
            local sg=g:Select(tp,1,1,nil)
            if #sg>0 then
                Duel.SSet(tp,sg:GetFirst())
            end
        end
    end
end

-- ②: Banish cost
function s.bancost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToRemove() end
    Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end

function s.banop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_GRAVE)
    if #g>0 then
        Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
end

-- ③: Disable condition
function s.distg(e,c)
    return c:GetBaseAttack()<=500
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