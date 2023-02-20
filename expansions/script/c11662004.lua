--炎星祖-オウリン
function c11662004.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c11662004.matfilter,1,1)
    --set & spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(11662004,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,11662004)
    e1:SetCondition(c11662004.setcon)
    e1:SetTarget(c11662004.settg)
    e1:SetOperation(c11662004.setop)
    c:RegisterEffect(e1)
    --level
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(11662004,2))
    e2:SetCategory(CATEGORY_LVCHANGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c11662004.lvtg)
    e2:SetOperation(c11662004.lvop)
    c:RegisterEffect(e2)
    --nagate
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_CHAIN_SOLVING)
    e3:SetCondition(c11662004.discon)
    e3:SetOperation(c11662004.disop)
    c:RegisterEffect(e3)
    --xyz
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(11662004)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,1)
    c:RegisterEffect(e4)
end

--link summon
function c11662004.matfilter(c)
    return c:IsLinkSetCard(0x79)
end

--set & spsummon
function c11662004.setcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11662004.setfilter(c)
    return c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c11662004.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c11662004.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c11662004.tgfilter(c)
    return (c:IsSetCard(0x79) or c:IsSetCard(0x7c)) and c:IsAbleToGrave()
end
function c11662004.spfilter(c,e,tp)
    return c:IsSetCard(0x79) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11662004.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local sg=Duel.SelectMatchingCard(tp,c11662004.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    if sg:GetCount()==0 then return end
    Duel.SSet(tp,sg:GetFirst())
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c11662004.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(c11662004.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
        and Duel.SelectYesNo(tp,aux.Stringid(11662004,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local tg=Duel.SelectMatchingCard(tp,c11662004.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
        if tg:GetCount()~=0 and Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local spg=Duel.SelectMatchingCard(tp,c11662004.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
            Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end

--lv
function c11662004.lvfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x79) and c:IsLevelAbove(1)
end
function c11662004.lvfilter1(c,tp)
    return c11662004.lvfilter(c) and Duel.IsExistingMatchingCard(c11662004.lvfilter2,tp,LOCATION_MZONE,0,1,c,c:GetLevel())
end
function c11662004.lvfilter2(c,lv)
    return c11662004.lvfilter(c) and not c:IsLevel(lv)
end
function c11662004.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11662004.lvfilter1(chkc,tp) end
    if chk==0 then return Duel.IsExistingTarget(c11662004.lvfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c11662004.lvfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c11662004.lvop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
    local lv=tc:GetLevel()
    local g=Duel.GetMatchingGroup(c11662004.lvfilter,tp,LOCATION_MZONE,0,nil)
    local lc=g:GetFirst()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_LEVEL)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetValue(lv)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end

--nagate
function c11662004.stfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c11662004.indfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x79)
end
function c11662004.discon(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) and ep~=tp and rc:IsRelateToEffect(re)
        and Duel.IsExistingMatchingCard(c11662004.indfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11662004.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c11662004.stfilter,ep,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(ep,aux.Stringid(11662004,3)) then
        Duel.Hint(HINT_SELECTMSG,ep,HINTMSG_TOGRAVE)
        local tg=g:Select(ep,1,1,nil)
        Duel.HintSelection(tg)
        if Duel.SendtoGrave(tg,REASON_EFFECT)==0 then
            Duel.NegateEffect(ev)
        end
    else
        Duel.NegateEffect(ev)
    end
end

-- change script
local sc=Effect.SetCountLimit
Effect.SetCountLimit=function(e,v,code)
    if e:GetDescription() == aux.Stringid(96381979,1) --魁炎星王－ソウコ
        or e:GetDescription() == aux.Stringid(37057743,0) --炎星皇－チョウライオ
    then
        return sc(e,v,EFFECT_COUNT_CODE_SINGLE)
    else
        return sc(e,v,code)
    end
end

local re=Card.RegisterEffect
Card.RegisterEffect=function(c,e)
    if (e:GetDescription() == aux.Stringid(96381979,1) --魁炎星王－ソウコ
        or e:GetDescription() == aux.Stringid(58504745,0) --間炎星－コウカンショウ
        or e:GetDescription() == aux.Stringid(37057743,0)) --炎星皇－チョウライオ
        and e:GetDescription() ~= aux.Stringid(11662004,4)
    then
        local ec=e:Clone()
        ec:SetDescription(aux.Stringid(11662004,4))
        ec:SetCode(EVENT_FREE_CHAIN)
        ec:SetType(EFFECT_TYPE_QUICK_O)
        ec:SetCondition(c11662004.con)
        c:RegisterEffect(ec)
    end
    return re(c,e)
end
function c11662004.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsPlayerAffectedByEffect(tp,11662004)
end
