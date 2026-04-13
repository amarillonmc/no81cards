local s,id=GetID()
function s.initial_effect(c)
    -- 连接召唤：占术姬怪兽1只
    c:EnableReviveLimit()
    -- 原生 Link 召唤手续 (Link-1)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetCondition(s.linkcon)
    e0:SetOperation(s.linkop)
    e0:SetValue(SUMMON_TYPE_LINK)
    c:RegisterEffect(e0)

    -- ①：连接召唤成功时，特招并反转
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    -- ②：主要阶段解放检索（本家怪兽/任意仪式魔法）
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_MAIN_END)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,id+1)
    e2:SetCondition(s.thcon)
    e2:SetCost(s.thcost)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end

-- --- Link 召唤判定 ---
function s.matfilter(c,lc,sumtype,tp)
    return c:IsSetCard(0xcc) and c:IsCanBeLinkMaterial(lc,tp)
end
function s.linkcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_MZONE,0,nil,c,SUMMON_TYPE_LINK,tp)
    return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and #g>=1
end
function s.linkop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_MZONE,0,1,1,nil,c,SUMMON_TYPE_LINK,tp)
    c:SetMaterial(g)
    Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
end

-- --- ① 效果：特招并反转 ---
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.spfilter(c,e,tp)
    -- 拉本家非仪式下级（里侧特招）
    return c:IsSetCard(0xcc) and not c:IsType(TYPE_RITUAL) 
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
            Duel.ConfirmCards(1-tp,tc)
            -- 强制变更为表侧触发反转
            Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
            
            -- 反转效果触发不受无效影响
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_CANNOT_INACTIVATE)
            e1:SetTarget(s.protect_target)
            e1:SetLabel(tc:GetCode())
            e1:SetReset(RESET_CHAIN)
            Duel.RegisterEffect(e1,tp)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_CANNOT_DISEFFECT)
            Duel.RegisterEffect(e2,tp)
        end
    end
end
function s.protect_target(e,ct)
    local p,te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT)
    return te:GetHandler():IsCode(e:GetLabel()) and te:IsHasCategory(CATEGORY_FLIP)
end

-- --- ② 效果：解放检索 ---
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsMainPhase()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function s.thfilter(c)
    -- 条件1：本家怪兽（包含仪式和下级）
    local is_monster = c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcc)
    -- 条件2：仪式魔法（不限字段）
    local is_ritual_spell = c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL)
    
    return (is_monster or is_ritual_spell) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end