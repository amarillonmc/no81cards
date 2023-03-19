--ゲーテの多元魔導書
function c119799730.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,119799730+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c119799730.condition)
    e1:SetTarget(c119799730.target)
    e1:SetOperation(c119799730.operation)
    c:RegisterEffect(e1)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    c:RegisterEffect(e2)
    --cannot set
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e3)
    --remove type
    local e4=Effect.CreateEffect(c)
    e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_REMOVE_TYPE)
    e4:SetValue(TYPE_QUICKPLAY)
    c:RegisterEffect(e4)
end

function c119799730.cfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c119799730.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c119799730.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c119799730.rfilter(c)
    return c:IsSetCard(0x306e) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c119799730.filter1(c)
    return c:IsFacedown() and c:IsAbleToHand()
end
function c119799730.filter2(c)
    return not c:IsPosition(POS_FACEUP_ATTACK) or c:IsCanTurnSet()
end
function c119799730.filter3(c)
    return c:IsAbleToRemove()
end
function c119799730.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(c119799730.rfilter,tp,LOCATION_GRAVE,0,1,nil) 
        and Duel.IsExistingMatchingCard(c119799730.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler())
    local b2=Duel.IsExistingMatchingCard(c119799730.rfilter,tp,LOCATION_GRAVE,0,2,nil)
        and Duel.IsExistingMatchingCard(c119799730.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
    local b3=Duel.IsExistingMatchingCard(c119799730.rfilter,tp,LOCATION_GRAVE,0,3,nil)
        and Duel.IsExistingMatchingCard(c119799730.filter3,tp,0,LOCATION_ONFIELD,1,nil)
    local op=3
    e:SetCategory(0)
    if chk==0 then return b1 or b2 or b3 end
    if b1 or b2 or b3 then
        if b1 and b2 and b3 then
            op=Duel.SelectOption(tp,aux.Stringid(119799730,0),aux.Stringid(119799730,1),aux.Stringid(119799730,2))
        elseif b1 and b2 and not b3 then
            op=Duel.SelectOption(tp,aux.Stringid(119799730,0),aux.Stringid(119799730,1))
        elseif b1 and not b2 and b3 then
            op=Duel.SelectOption(tp,aux.Stringid(119799730,0),aux.Stringid(119799730,2))
            if op==1 then op=2 end
        elseif not b1 and b2 and b3 then
            op=Duel.SelectOption(tp,aux.Stringid(119799730,1),aux.Stringid(119799730,2))+1
        elseif b1 and not (b2 and b3) then
            op=Duel.SelectOption(tp,aux.Stringid(119799730,0))
        elseif b2 and not (b1 and b3) then
            op=Duel.SelectOption(tp,aux.Stringid(119799730,1))+1
        else
            op=Duel.SelectOption(tp,aux.Stringid(119799730,2))+2
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=Duel.SelectMatchingCard(tp,c119799730.rfilter,tp,LOCATION_GRAVE,0,op+1,op+1,nil)
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        if op==0 then
            local g=Duel.GetMatchingGroup(c119799730.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,e:GetHandler())
            Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
        elseif op==1 then
            local g=Duel.GetMatchingGroup(c119799730.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
            Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
        else
            local g=Duel.GetMatchingGroup(c119799730.filter3,tp,0,LOCATION_ONFIELD,nil)
            Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
        end
    end
    e:SetLabel(op)
end
function c119799730.operation(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()==3 then return end
    if e:GetLabel()==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
        local g=Duel.SelectMatchingCard(tp,c119799730.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            Duel.SendtoHand(g,nil,REASON_EFFECT)
        end
    elseif e:GetLabel()==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
        local g=Duel.SelectMatchingCard(tp,c119799730.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.HintSelection(g)
            if tc:IsPosition(POS_FACEUP_ATTACK) then
                Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
            else
                local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
                Duel.ChangePosition(tc,pos)
            end
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=Duel.SelectMatchingCard(tp,c119799730.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        end
    end
end
