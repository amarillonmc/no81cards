--缝合僵尸 无赖之伐他
local m=4865029
local cm=_G["c"..m]
function cm.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(cm.spcon)
    c:RegisterEffect(e1)
    --speical summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,m+1)
    e2:SetTarget(cm.tgtg)
    e2:SetOperation(cm.tgop)
    c:RegisterEffect(e2)
end
function cm.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x332b) and not c:IsCode(m)
end
function cm.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function cm.tgfilter(c)
    return c:IsSetCard(0x332b) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER)
end
function cm.sfilter(c,e,tp,mc)
    return c:IsSetCard(0x332b) and c:IsType(TYPE_SYNCHRO)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local clv=c:GetLevel()
    local lv=8-clv
    local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
    if chk==0 then return clv>0 and lv>0 and g:CheckWithSumEqual(Card.GetLevel,lv,1,99)
        and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local clv=c:GetLevel()
    local lv=8-clv
    if c:IsRelateToEffect(e) and not c:IsFacedown() and lv>0 then
        local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local tg=g:SelectWithSumEqual(tp,Card.GetLevel,lv,1,99)
        if #tg>0 then
            tg:AddCard(c)
            if Duel.SendtoGrave(tg,nil,REASON_EFFECT)>1 and tg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local sg=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
                if sg:GetCount()>0 then
                    Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
    return not c:IsSetCard(0x332b) and c:IsLocation(LOCATION_EXTRA)
end

