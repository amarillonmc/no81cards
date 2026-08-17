-- 凄陌寒昼·雪消冰释
local s,id,o=GetID()
function s.initial_effect(c)
    -- ① 发动时可选从卡组特召本家怪兽
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

    -- ② 自己场上怪兽攻击力·守备力上升
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TRUE)
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)

    -- ③ 被解放时在自己魔陷区表侧放置
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_RELEASE)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetTarget(s.reltg)
    e4:SetOperation(s.relop)
    c:RegisterEffect(e4)

    -- 全局解放计数
    if not s.global_check then
        s.global_check=true
        s.release_count=0
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_RELEASE)
        ge1:SetOperation(s.countop)
        Duel.RegisterEffect(ge1,0)
    end
end

-- 攻击力/守备力上升值
function s.atkval(e,c)
    return s.release_count*200
end

-- 解放计数
function s.countop(e,tp,eg,ep,ev,re,r,rp)
    s.release_count=s.release_count+1
end

-- ① 可选特召
function s.spfilter(c,e,tp)
    return c:IsSetCard(0x3f15) and c:IsType(TYPE_MONSTER)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if not Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
    if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

function s.reltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.relop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end