--魔弾の奏者マリア
function c117179181.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --pendulum effect
    --link summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(117179181,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_PZONE)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e1:SetCountLimit(1,117179181)
    e1:SetCost(c117179181.actcost)
    e1:SetTarget(c117179181.lktg)
    e1:SetOperation(c117179181.lkop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetOperation(aux.chainreg)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(117179181,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_CHAIN_SOLVING)
    e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1,117179182)
    e3:SetCondition(c117179181.spcon)
    e3:SetCost(c117179181.actcost)
    e3:SetTarget(c117179181.sptg)
    e3:SetOperation(c117179181.spop)
    c:RegisterEffect(e3)
    --monster effect
    --activate from hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(117179181,4))
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x108))
    e4:SetTargetRange(LOCATION_HAND,0)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    c:RegisterEffect(e5)
    --spsummon & pset
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(117179181,2))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE+LOCATION_HAND)
    e6:SetCountLimit(1,117179183)
    e6:SetCondition(c117179181.sscon)
    e6:SetCost(c117179181.actcost)
    e6:SetTarget(c117179181.sstg)
    e6:SetOperation(c117179181.ssop)
    c:RegisterEffect(e6)
    --atk gain
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(117179181,3))
    e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCode(EVENT_CHAIN_SOLVING)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1,117179184)
    e7:SetCondition(c117179181.atkcon)
    e7:SetCost(c117179181.actcost)
    e7:SetTarget(c117179181.atktg)
    e7:SetOperation(c117179181.atkop)
    c:RegisterEffect(e7)
    Duel.AddCustomActivityCounter(117179181,ACTIVITY_CHAIN,aux.FALSE)
end

--description
function c117179181.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

--link summon
function c117179181.matfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x108)
end
function c117179181.lkfilter(c,mg)
    return c:IsLinkSummonable(mg)
end
function c117179181.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetMatchingGroup(c117179181.matfilter,tp,LOCATION_MZONE,0,nil)
        return Duel.IsExistingMatchingCard(c117179181.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c117179181.lkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local mg=Duel.GetMatchingGroup(c117179181.matfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c117179181.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
    local tc=tg:GetFirst()
    if tc then
        Duel.LinkSummon(tp,tc,mg)
    end
end

--spsummon
function c117179181.spcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c117179181.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c117179181.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end

--spsummon & pset
function c117179181.sscon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 or Duel.GetCustomActivityCount(117179181,1-tp,ACTIVITY_CHAIN)>0
end
function c117179181.ssfilter(c,e,tp)
    return c:IsSetCard(0x108) and not c:IsCode(117179181) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c117179181.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c117179181.ssfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
        and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
        and not e:GetHandler():IsForbidden() end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c117179181.ssop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=Duel.SelectMatchingCard(tp,c117179181.ssfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
    if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end

--atk gain
function c117179181.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():GetColumnGroup():IsContains(re:GetHandler())
end
function c117179181.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x108) and (c:GetAttack()>0 or c:GetDefense()>0)
end
function c117179181.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c117179181.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c117179181.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectMatchingCard(tp,c117179181.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        local tc=g:GetFirst()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(tc:GetAttack())
        e1:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(tc:GetDefense())
        c:RegisterEffect(e2)
    end
end
