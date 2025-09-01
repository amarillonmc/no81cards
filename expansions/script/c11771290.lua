-- 生死的命数 阿忒洛波斯
function c11771290.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2,c11771290.ovfilter,aux.Stringid(11771290,0),99)
	c:EnableReviveLimit()
    -- 骰子效果
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(11771290,1))
    e1:SetCategory(CATEGORY_DICE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,11771290)
    e1:SetCost(c11771290.cost1)
    e1:SetTarget(c11771290.tg1)
    e1:SetOperation(c11771290.op1)
    c:RegisterEffect(e1)
    -- 获取素材
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(11771290,2))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,11771291)
    e2:SetCondition(c11771290.con2)
    e2:SetTarget(c11771290.tg2)
    e2:SetOperation(c11771290.op2)
    c:RegisterEffect(e2)
    -- 记录怪兽效果发动
    local function record_activated_effects()
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_CHAIN_SOLVED)
        ge1:SetOperation(c11771290.check_op)
        Duel.RegisterEffect(ge1,0)
    end
    record_activated_effects()
end
function c11771290.check_op(e,tp,eg,ep,ev,re,r,rp)
    if re and re:IsActiveType(TYPE_MONSTER) and re:IsActivated() then
        local rc=re:GetHandler()
        if rc:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE)) then
            rc:RegisterFlagEffect(11771290+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
        end
    end
end
-- xyz summon
function c11771290.ovfilter(c)
    return c:IsFaceup() and c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE)) and c:GetFlagEffect(11771290+100)>0
end
-- 1
function c11771290.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11771290.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c11771290.op1(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.TossDice(tp,1)
    if d==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
        local g1=Duel.GetMatchingGroup(Card.IsAbleToChangeControler,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
        if #g1>0 then
            local sg=g1:Select(tp,1,1,nil)
            Duel.Overlay(e:GetHandler(),sg)
        end
    elseif d==2 then
        if Duel.Draw(1-tp,1,REASON_EFFECT)~=0 then
            Duel.ShuffleHand(1-tp)
            Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
            local g2=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,2,2,nil)
            if #g2>0 then
                Duel.SendtoGrave(g2,REASON_EFFECT+REASON_DISCARD)
            end
        end
    elseif d==3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g3=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
        if #g3>0 then
            Duel.SendtoGrave(g3,REASON_EFFECT)
        end
    elseif d==4 then
        local g4=Duel.GetMatchingGroup(Card.IsLevelAbove,tp,0,LOCATION_DECK,nil,10)
        if #g4>0 then
            Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
            local sg=g4:Select(1-tp,1,1,nil)
            if #sg>0 then
                Duel.SendtoHand(sg,nil,REASON_EFFECT)
                Duel.ConfirmCards(tp,sg)
            end
        end
    elseif d==5 then
        local g5=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
        for tc in aux.Next(g5) do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e2)
        end
    elseif d==6 then
        local g6=Duel.GetMatchingGroup(c11771290.filter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
        if #g6>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=g6:Select(tp,1,1,nil)
            if #sg>0 then
                Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
            end
        end
    end
end
function c11771290.filter1(c)
    return c:IsRace(RACE_ZOMBIE) and c:IsLevel(10)
end
-- 2
function c11771290.con2(e,tp,eg,ep,ev,re,r,rp)
    return re and (re:IsHasType(EFFECT_TYPE_DICE) or re:IsHasCategory(CATEGORY_DICE)) and re:GetHandler()~=e:GetHandler()
end
function c11771290.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c11771290.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e))
    if #g>0 then
        local sg=Group.CreateGroup()
        sg:AddCard(g:GetFirst())
        Duel.BreakEffect()
        for tc in aux.Next(sg) do
            local og=tc:GetOverlayGroup()
            if og:GetCount()>0 then
                Duel.SendtoGrave(og,REASON_RULE)
            end
        end
        Duel.Overlay(c,sg)
    end
end
