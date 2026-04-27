--你要集结吗？
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    
    --Special Summon and send to grave
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCondition(s.spcon)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
end

function s.cfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    local p1_satisfied = false
    local p2_satisfied = false

    -- Check if player tp satisfies the condition
    if eg:IsExists(s.cfilter,1,nil,tp) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
        p1_satisfied = true
    end
    -- Check if player 1-tp satisfies the condition
    if eg:IsExists(s.cfilter,1,nil,1-tp) and Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)==0 then
        p2_satisfied = true
    end

    if p1_satisfied and p2_satisfied then
        -- If both satisfy, priority goes to the turn player.
        local turn_player = Duel.GetTurnPlayer()
        e:SetLabel(turn_player)
        return true
    elseif p1_satisfied then
        e:SetLabel(tp)
        return true
    elseif p2_satisfied then
        e:SetLabel(1-tp)
        return true
    end
    return false
end

function s.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local target_player = e:GetLabel()
    if not (Duel.GetLocationCount(target_player,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,target_player,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,target_player) and Duel.SelectYesNo(target_player,aux.Stringid(id,0))) then return end
    
    -- Declaration hint
    Duel.Hint(HINT_CARD,0,id)
    Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(id,1))
    Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(id,1))

    local ft = Duel.GetLocationCount(target_player,LOCATION_MZONE)
    if ft<=0 then return end

    -- 青眼精灵龙限制检测（卡号59822133）
    if Duel.IsPlayerAffectedByEffect(target_player, 59822133) then
        ft = 1
    end

    Duel.Hint(HINT_SELECTMSG,target_player,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(target_player,s.spfilter,target_player,LOCATION_HAND+LOCATION_GRAVE,0,1,ft,nil,e,target_player)
    if #g==0 then return end
    
    local sp_count = 0
    for tc in aux.Next(g) do
        if Duel.SpecialSummonStep(tc,0,target_player,target_player,false,false,POS_FACEUP) then
            sp_count = sp_count + 1
            -- Redirect when leaving field
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
            e1:SetValue(LOCATION_REMOVED)
            tc:RegisterEffect(e1,true)
        end
    end
    Duel.SpecialSummonComplete()
    
    if sp_count > 0 then
        Duel.BreakEffect()
        Duel.DiscardDeck(target_player,sp_count,REASON_EFFECT)
        
        -- Summon restriction
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_CANNOT_SUMMON)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e2:SetTargetRange(1,0)
        e2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e2,target_player)
        local e3=e2:Clone()
        e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        Duel.RegisterEffect(e3,target_player)
    end
end