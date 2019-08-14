--最后的魔女·久远寺有珠
function c1007008.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x20f),10,2)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(1,0)
    e1:SetCondition(c1007008.sccon)
    e1:SetTarget(c1007008.splimit)
    c:RegisterEffect(e1)
    --change
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c1007008.tg)
    e3:SetOperation(c1007008.op)
    c:RegisterEffect(e3)
    --act
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e4:SetCondition(c1007008.thcon)
    e4:SetTarget(c1007008.detg)
    e4:SetOperation(c1007008.deop)
    c:RegisterEffect(e4)
    --move
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCondition(c1007008.descon)
    e5:SetTarget(c1007008.destg)
    e5:SetOperation(c1007008.desop)
    c:RegisterEffect(e5)
    --spsummon
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(1007008,2))
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EVENT_FREE_CHAIN)
    e7:SetCountLimit(1,107082)
    e7:SetCost(c1007008.setcost)
    e7:SetTarget(c1007008.target)
    e7:SetOperation(c1007008.operation)
    c:RegisterEffect(e7)
end
c1007008.pendulum_level=10
function c1007008.sccon(e)
    return not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x20f)
end
function c1007008.splimit(e,c)
    return not c:IsSetCard(0x20f)
end
function c1007008.filter(c,e,tp,ft)
    return c:IsFaceup() and c:IsSetCard(0x20f) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,357,tp,false,false)))
end
function c1007008.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return Duel.IsExistingMatchingCard(c1007008.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,ft) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c1007008.op(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c1007008.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
    local tc=g:GetFirst()
    if tc then
        if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
            and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(1000504,1))) then
            Duel.SpecialSummon(tc,357,tp,tp,false,false,POS_FACEUP)
        else
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        end
    end
end
function c1007008.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()~=SUMMON_TYPE_PENDULUM or e:GetHandler():GetSummonType()~=SUMMON_TYPE_XYZ 
end
function c1007008.filter1(c)
    return c:IsSetCard(0x20f) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1007008.detg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c1007008.filter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1007008.deop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c1007008.filter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c1007008.descon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE)
end
function c1007008.dfilter(c)
    return c:IsDestructable()
end
function c1007008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 end
    local g=Duel.GetFieldGroup(tp,LOCATION_SZONE,LOCATION_SZONE)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c1007008.desop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE,tp)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,1007024,0,0x4011,1900,1000,3,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,1007025,0,0x4011,1000,190,3,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp) then
        local token=Duel.CreateToken(tp,1007024)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        token:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetCategory(CATEGORY_DISABLE)
        e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e2:SetCode(EVENT_DAMAGE_STEP_END)
        e2:SetTarget(c1007008.cttg)
        e2:SetOperation(c1007008.ctop)
        token:RegisterEffect(e2)
        Duel.SpecialSummonComplete()
        local token=Duel.CreateToken(tp,1007025)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        token:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetCategory(CATEGORY_DISABLE)
        e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e2:SetCode(EVENT_DAMAGE_STEP_END)
        e2:SetTarget(c1007008.cttg)
        e2:SetOperation(c1007008.ctop)
        token:RegisterEffect(e2)
        Duel.SpecialSummonComplete()
    end
    local g=Duel.GetFieldGroup(tp,LOCATION_SZONE,LOCATION_SZONE)
    if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c1007008.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetHandler():GetBattleTarget()
    if chk==0 then return tc and tc:IsRelateToBattle() end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
end
function c1007008.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e2)
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SET_ATTACK_FINAL)
    e3:SetReset(RESET_EVENT+0x1fe0000)
    e3:SetValue(0)
    tc:RegisterEffect(e3)
    local e4=Effect.CreateEffect(e:GetHandler())
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
    e4:SetReset(RESET_EVENT+0x1fe0000)
    e4:SetValue(0)
    tc:RegisterEffect(e4)
end
function c1007008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1007008.filter3(c,tp)
    return c:IsSetCard(0x320f) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:GetActivateEffect():IsActivatable(tp)
end
function c1007008.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c1007008.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c1007008.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1007006,3))
    local tc=Duel.SelectMatchingCard(tp,c1007008.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
    if tc and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local te=tc:GetActivateEffect()
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
        Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
    end
end
function c1007008.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
