--青子的师傅·久远寺有珠
function c1007016.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x20f),3,2)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(1,0)
    e1:SetCondition(c1007016.sccon)
    e1:SetTarget(c1007016.splimit)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(1007016,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c1007016.sscost)
    e2:SetTarget(c1007016.target)
    e2:SetOperation(c1007016.activate)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(1007016,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCondition(c1007016.spccon)
    e3:SetTarget(c1007016.sptg)
    e3:SetOperation(c1007016.spop)
    c:RegisterEffect(e3)
    --move
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCondition(c1007016.descon)
    e5:SetTarget(c1007016.destg)
    e5:SetOperation(c1007016.desop)
    c:RegisterEffect(e5)
    --pos change
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(1007016,2))
    e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c1007016.tkcost)
    e1:SetTarget(c1007016.tktg)
    e1:SetOperation(c1007016.tkop)
    c:RegisterEffect(e1)
end
c1007016.pendulum_level=3
function c1007016.sccon(e)
    return not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x20f)
end
function c1007016.splimit(e,c)
    return not c:IsSetCard(0x20f)
end
function c1007016.ppxfilter(c)
    return c:IsSetCard(0x20f)
end
function c1007016.spccon(e)
    return Duel.IsExistingMatchingCard(c1007016.ppxfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c1007016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1007016.drfilter(c,e)
    return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler()) and not c:IsImmuneToEffect(e)
end
function c1007016.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c1007016.drfilter,0,LOCATION_GRAVE,0,1,c,e) then
        if Duel.SelectYesNo(tp,aux.Stringid(1007016,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
            local g=Duel.SelectMatchingCard(tp,c1007016.drfilter,tp,LOCATION_GRAVE,0,1,1,c,e)
            if g:GetCount()>0 then
                Duel.HintSelection(g)
                local dc=g:GetFirst()
                local og=dc:GetOverlayGroup()
                if og:GetCount()>0 then
                    Duel.SendtoGrave(og,REASON_RULE)
                end
                Duel.Overlay(c,Group.FromCards(dc))
            end
        end
    end
end
function c1007016.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c1007016.filter(c,tp)
    return c:IsSetCard(0x320f) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:GetActivateEffect():IsActivatable(tp)
end
function c1007016.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c1007016.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c1007016.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1007016,3))
    local tc=Duel.SelectMatchingCard(tp,c1007016.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
    if tc and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local te=tc:GetActivateEffect()
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
        Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
    end
end
function c1007016.descon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE)
end
function c1007016.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 end
    local g=Duel.GetFieldGroup(tp,LOCATION_SZONE,LOCATION_SZONE)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c1007016.desop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE,tp)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,1007026,0,0x4011,300,300,1,RACE_WINDBEAST,ATTRIBUTE_DARK,POS_FACEUP,tp) then
        local token=Duel.CreateToken(tp,1007026)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DESTROY_REPLACE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetTarget(c1007016.reptg)
        e1:SetValue(c1007016.repval)
        e1:SetOperation(c1007016.repop)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        token:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetDescription(aux.Stringid(1007016,0))
        e2:SetCategory(CATEGORY_RECOVER)
        e2:SetType(EFFECT_TYPE_IGNITION)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCost(c1007016.recost)
        e2:SetTarget(c1007016.rectg)
        e2:SetOperation(c1007016.recop)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        token:RegisterEffect(e2)
        Duel.SpecialSummonComplete()
    end
    local g=Duel.GetFieldGroup(tp,LOCATION_SZONE,LOCATION_SZONE)
    if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c1007016.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x20f)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
end
function c1007016.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c1007016.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(1007026,3))
end
function c1007016.repval(e,c)
    return c1007016.repfilter(c,e:GetHandlerPlayer())
end
function c1007016.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c1007016.recost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c1007016.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c1007016.recop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
function c1007016.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
    local tc=c:GetOverlayCount()
    e:SetLabel(tc)
    e:GetHandler():RemoveOverlayCard(tp,tc,tc,REASON_COST)
end
function c1007016.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,1007030,0,0x4011,2800,2800,8,RACE_BEAST,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c1007016.tkop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,1007030,0,0x4011,2800,2800,8,RACE_BEAST,ATTRIBUTE_DARK) then
        local token=Duel.CreateToken(tp,1007030)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
            token:RegisterEffect(e1)
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e2:SetRange(LOCATION_MZONE)
            e2:SetCode(EFFECT_IMMUNE_EFFECT)
            e2:SetValue(c1007016.efilter)
            e2:SetReset(RESET_EVENT+0x1fe0000)
            token:RegisterEffect(e2)
            local e3=Effect.CreateEffect(e:GetHandler())
            e3:SetDescription(aux.Stringid(26593852,0))
            e3:SetCategory(CATEGORY_DESTROY)
            e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
            e3:SetCode(EVENT_BATTLE_START)
            e3:SetTarget(c1007016.destg)
            e3:SetOperation(c1007016.desop)
            token:RegisterEffect(e3)
            Duel.SpecialSummonComplete()
        end
end
function c1007016.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c1007016.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if chk==0 then return tc and tc:IsFaceup() end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c1007016.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end
