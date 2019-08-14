--连接姬 柏崎栞
local m=60152302
local cm=_G["c"..m]
function cm.initial_effect(c)
    --special summon
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(60152302,0))
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_HAND)
    e0:SetCondition(c60152302.e0con)
    c:RegisterEffect(e0)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152302,1))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,60152302)
    e1:SetTarget(c60152302.e1tg)
    e1:SetOperation(c60152302.e1op)
    c:RegisterEffect(e1)
    local e11=e1:Clone()
    e11:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e11)
    --spsum
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60152302,3))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,6012302)
    e2:SetCondition(c60152302.e2con)
    e2:SetTarget(c60152302.e2tg)
    e2:SetOperation(c60152302.e2op)
    c:RegisterEffect(e2)
end
function c60152302.e0confilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:GetCode()~=60152302
end
function c60152302.e0con(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.IsExistingMatchingCard(c60152302.e0confilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60152302.e1tgfilter(c,tp)
    local code=c:GetCode()
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER) 
        and Duel.IsExistingTarget(c60152302.e1tgfilter2,tp,LOCATION_MZONE,0,1,nil,code)
end
function c60152302.e1tgfilter2(c,code)
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER) and not c:IsCode(code)
end
function c60152302.e1tgfilter3(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c60152302.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60152302.e1tgfilter(chkc,tp) end
    if chk==0 then return Duel.IsExistingTarget(c60152302.e1tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) 
        and Duel.IsExistingTarget(c60152302.e1tgfilter3,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c60152302.e1tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    local g=Duel.GetMatchingGroup(c60152302.e1tgfilter3,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152302.e1op(e,tp,eg,ep,ev,re,r,rp)
    local tc0=Duel.GetFirstTarget()
    local code=tc0:GetCode()
    local g=Duel.GetMatchingGroup(c60152302.e1tgfilter3,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        local tc=sg:GetFirst()
        local atk=tc:GetAttack()
        if Duel.Destroy(tc,REASON_EFFECT)>0 then
            local g2=Duel.GetMatchingGroup(c60152302.e1tgfilter2,tp,LOCATION_MZONE,0,nil,code)
            if g2:GetCount()>0 then
                Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152302,2))
                local sg2=g2:Select(tp,1,1,nil)
                Duel.HintSelection(sg2)
                local tc2=sg2:GetFirst()
                if tc2:IsFaceup() then
                    local e1=Effect.CreateEffect(e:GetHandler())
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_UPDATE_ATTACK)
                    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                    e1:SetValue(math.ceil(atk/2))
                    tc2:RegisterEffect(e1)
                end
            end
        end
        if tc0:IsType(TYPE_XYZ) and e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsImmuneToEffect(e) 
            and tc0:IsLocation(LOCATION_MZONE) and tc0:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(60152301,4)) then
            Duel.Overlay(tc0,Group.FromCards(e:GetHandler()))
        end
    end
end
function c60152302.e2con(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60152302.e2tgfilter(c,e,tp)
    return c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(60152302)
end
function c60152302.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60152302.e2tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152302.e2op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60152302.e2tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        local tc2=g:GetFirst()
        Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
        if Duel.IsPlayerAffectedByEffect(tp,60152321) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_IMMUNE_EFFECT)
            e1:SetRange(LOCATION_MZONE)
            e1:SetValue(c60152302.e2opfilter)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_CHAIN)
            tc2:RegisterEffect(e1)
        end
    end
end
function c60152302.e2opfilter(e,re)
    return e:GetHandler()~=re:GetOwner()
end