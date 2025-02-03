local s,id=GetID()

function s.initial_effect(c)

    -- 效果①：召唤成功时
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.extg)
    e1:SetOperation(s.exop)
    c:RegisterEffect(e1)
    
    -- 效果①：特殊召唤成功时
    local e1x=e1:Clone()
    e1x:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e1x)

    -- 效果②：战斗破坏怪兽时造成伤害并特殊召唤
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetCondition(s.damcon)
    e2:SetTarget(s.damtg)
    e2:SetOperation(s.damop)
    c:RegisterEffect(e2)
end

-- 效果①：从额外卡组送墓
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end

function s.exfilter(c)
    return c:IsSetCard(0x9008) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

function s.exop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
        local c=e:GetHandler()
        local lv=g:GetFirst():GetLevel()
        if c:IsRelateToEffect(e) and c:IsFaceup() then
            -- 攻击力提升
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(lv*200)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
            c:RegisterEffect(e1)
        end
    end
end

-- 效果②：战斗破坏处理
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE)
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local bc=e:GetHandler():GetBattleTarget()
    local dam=bc:GetBaseAttack()
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end

function s.spfilter(c,e,tp)
    return c:IsSetCard(0x9008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Damage(p,d,REASON_EFFECT)~=0 then
        local c=e:GetHandler()
        -- 解放自身特召
        if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
            and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
            Duel.BreakEffect()
            if Duel.Release(c,REASON_EFFECT)~=0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
                if #g>0 then
                    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
end