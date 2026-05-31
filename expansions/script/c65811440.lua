-- 愤怒风暴的狂野神碑
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
local s,id=GetID()
function s.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(id,2))
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    c:RegisterEffect(e0)

    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,2))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SSET)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(0xff)
    e2:SetTargetRange(1,1)
    e2:SetTarget(function(e,c) return c==e:GetHandler() end)
    c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp)
    return c:IsSetCard(0x17f) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct = Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
    local b1 = ct>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
    local b2 = Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
    if chk==0 then return b1 or b2 end
    local op = 0
    if b1 and b2 then
        op = Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
    elseif b1 then
        op = Duel.SelectOption(tp,aux.Stringid(id,0))
    else
        op = Duel.SelectOption(tp,aux.Stringid(id,1)) + 1
    end
    e:SetLabel(op)
    if op==0 then
        e:SetCategory(0)
    else
        e:SetCategory(CATEGORY_SPECIAL_SUMMON)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local op = e:GetLabel()
    if op==0 then
        local onfield_ct = Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
        local ct = math.min(onfield_ct, Duel.GetFieldGroupCount(tp,0,LOCATION_DECK))
        if ct>0 then
            Duel.DisableShuffleCheck()
            Duel.ConfirmDecktop(1-tp,ct)
            local dg=Duel.GetDecktopGroup(1-tp,ct)
            local exg=Group.CreateGroup()
            for dc in aux.Next(dg) do
                if not dc:IsImmuneToEffect(e) then exg:AddCard(dc) end
            end
            if #exg>0 then if KOISHI_CHECK then Duel.Exile(exg,REASON_EFFECT) else Duel.Remove(exg,POS_FACEDOWN,REASON_RULE,nil) end end
        end
        if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then
            Duel.Win(tp,0xa31)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
        if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
    end
end