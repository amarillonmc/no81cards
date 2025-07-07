--神威骑士堡右护炮（未解限）
function c24501078.initial_effect(c)
	-- Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    -- 特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(24501078,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,24501078)
    e1:SetTarget(c24501078.tg1)
    e1:SetOperation(c24501078.op1)
    c:RegisterEffect(e1)
    -- 效果伤害
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(24501078,1))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,24501079)
    e2:SetCondition(c24501078.con2)
    e2:SetTarget(c24501078.tg2)
    e2:SetOperation(c24501078.op2)
    c:RegisterEffect(e2)
end
-- 1
function c24501078.filter1(c,e,tp)
    return c:IsSetCard(0x501) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24501078.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c24501078.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c24501078.op1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c24501078.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
        if dg:GetCount()>0 then
            Duel.Destroy(dg,REASON_EFFECT)
        end
    end
end
-- 2
function c24501078.con2(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
        and re:GetHandler():IsSetCard(0x501)
        and re:GetHandler()~=e:GetHandler()
end
function c24501078.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c24501078.op2(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
