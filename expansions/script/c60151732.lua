--天空的水晶部队 魔物召唤师
function c60151732.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3b26),4,2)
    c:EnableReviveLimit()
    --attach
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151732,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c60151732.target)
    e1:SetOperation(c60151732.operation)
    c:RegisterEffect(e1)
    --token
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151732,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,60151732)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,0x1e0)
    e2:SetCost(c60151732.thcost)
    e2:SetTarget(c60151732.destg)
    e2:SetOperation(c60151732.desop)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151732,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,6011732)
    e3:SetTarget(c60151732.target2)
    e3:SetOperation(c60151732.operation2)
    c:RegisterEffect(e3)
end
function c60151732.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsType(TYPE_MONSTER) end
    if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_MONSTER)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c60151732.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
        Duel.Overlay(c,Group.FromCards(tc))
    end
end
function c60151732.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60151732.mfilter(c)
    return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_XYZ)
end
function c60151732.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151732.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsPlayerCanSpecialSummonMonster(tp,60151784,0,0x4011,-2,-2,-2,RACE_SPELLCASTER,ATTRIBUTE_WIND) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c60151732.desop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,60151784,0,0x4011,-2,-2,-2,RACE_SPELLCASTER,ATTRIBUTE_WIND) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectMatchingCard(tp,c60151732.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        local tc=g:GetFirst()
        local atk=tc:GetBaseAttack()
        local def=tc:GetBaseDefense()
        local lv=tc:GetLevel()
        local token=Duel.CreateToken(tp,60151784)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(atk)
        token:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_DEFENSE)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetValue(def)
        token:RegisterEffect(e2,true)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CHANGE_LEVEL)
        e3:SetReset(RESET_EVENT+0x1fe0000)
        e3:SetValue(lv)
        token:RegisterEffect(e3,true)
    end
end
function c60151732.filter(c,e,tp)
    return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151732.filter2(c,ft)
    if ft==0 then
        return c:IsType(TYPE_MONSTER) and c:IsDestructable()
            and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
    else
        return c:IsType(TYPE_MONSTER) and c:IsDestructable()
            and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
    end
end
function c60151732.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151732.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,ft)
        and Duel.IsExistingTarget(c60151732.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c60151732.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    local g2=Duel.GetMatchingGroup(c60151732.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,ft)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c60151732.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,c60151732.filter2,tp,LOCATION_MZONE,0,1,1,nil,ft)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            if Duel.Destroy(g,REASON_EFFECT)~=0 then
                if tc:IsRelateToEffect(e) then
                    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,c60151732.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,ft)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            if Duel.Destroy(g,REASON_EFFECT)~=0 then
                if tc:IsRelateToEffect(e) then
                    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
end
