-- 画笔的重量
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

--假设选择的场上的卡拥有字段A、B，这张卡可以选择从卡组加入手卡的卡包括情况：拥有字段A，拥有字段B，同时拥有字段A、B，同时拥有字段A、C或字段B、C，
--直到这个回合结束，自己不是拥有字段A、B的怪兽不能特殊召唤，不能把拥有字段A、B的卡以外的卡的效果发动。

-- 判断一张卡是否拥有字段
function s.has_setcode(c)
    for code=0x1,0xFFFF do
        if c:IsFaceup() and c:IsSetCard(code) then return true end
    end
    return false
end

-- 获取一张卡的所有字段
function s.get_setcodes(c)
    local setcodes={}
    for code=0x1,0xFFFF do
        if c:IsSetCard(code) then table.insert(setcodes,code) end
    end
    return setcodes
end

-- 检查一张卡是否与给定的字段集合有交集
function s.has_shared_set(c, setcodes)
    for _,code in ipairs(setcodes) do
        if c:IsSetCard(code) then return true end
    end
    return false
end

-- 自肃：只能特殊召唤拥有共享字段的怪兽
function s.splimit(e,c)
    local setcodes=e:GetLabelObject()
    return not s.has_shared_set(c,setcodes)
end

-- 自肃：只能发动拥有共享字段的卡的效果
function s.actlimit(e,re,tp)
    local setcodes=e:GetLabelObject()
    return not s.has_shared_set(re:GetHandler(),setcodes)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and s.has_setcode(chkc) end
    if chk==0 then
        return Duel.IsExistingTarget(s.has_setcode,tp,LOCATION_ONFIELD,0,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,s.has_setcode,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local setcodesA=s.get_setcodes(tc)
    if #setcodesA==0 then return end

    -- 从卡组过滤出拥有至少一个相同字段的卡
    local deck_g=Duel.GetMatchingGroup(function(c)
        return c:IsAbleToHand() and s.has_shared_set(c,setcodesA)
    end,tp,LOCATION_DECK,0,nil)

    if #deck_g==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=deck_g:Select(tp,1,1,nil)
    if #sg==0 then return end
    local selected=sg:GetFirst()
    Duel.SendtoHand(selected,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sg)

    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(function(e,c)
        return not s.has_shared_set(c,setcodesA)
    end)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetTargetRange(1,0)
    e2:SetValue(function(e,re,tp)
        return not s.has_shared_set(re:GetHandler(),setcodesA)
    end)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end