--稀世的魔女·久远寺有珠
function c1007007.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(1,0)
    e1:SetCondition(c1007007.sccon)
    e1:SetTarget(c1007007.splimit)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c1007007.thtg)
    e2:SetOperation(c1007007.thop)
    c:RegisterEffect(e2)
    --act
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCondition(c1007007.decon)
    e3:SetTarget(c1007007.detg)
    e3:SetOperation(c1007007.deop)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_EXTRA)
    e4:SetCountLimit(1,1770177)
    e4:SetCost(c1007007.spcost)
    e4:SetTarget(c1007007.sptg)
    e4:SetOperation(c1007007.spop)
    c:RegisterEffect(e4)
    --atk down
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCategory(CATEGORY_TOKEN)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e6:SetCode(EVENT_TO_GRAVE)
    e6:SetCondition(c1007007.tkcon)
    e6:SetTarget(c1007007.tktg)
    e6:SetOperation(c1007007.tkop)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EVENT_REMOVE)
    c:RegisterEffect(e7)
end
function c1007007.sccon(e)
    return not Duel.IsExistingMatchingCard(c1007007.ppfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c1007007.splimit(e,c)
    return not c:IsSetCard(0x20f)
end
function c1007007.thfilter(c)
    return c:IsSetCard(0xa20f) and not c:IsCode(1007007) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c1007007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
    if chk==0 then return Duel.IsExistingMatchingCard(c1007007.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetTargetCard(sc)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0)
end
function c1007007.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1007007,2))
        local g=Duel.SelectMatchingCard(tp,c1007007.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
        local tc=g:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
        end
    end
end
function c1007007.decon(e,tp,eg,ep,ev,re,r,rp)
    local st=e:GetHandler():GetSummonType()
    return (st>=(SUMMON_TYPE_SPECIAL+350) and st<(SUMMON_TYPE_SPECIAL+360)) or st==SUMMON_TYPE_PENDULUM 
end
function c1007007.filter(c,tp)
    return c:IsSetCard(0x320f) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:GetActivateEffect():IsActivatable(tp)
end
function c1007007.detg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c1007007.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c1007007.deop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1007006,3))
    local tc=Duel.SelectMatchingCard(tp,c1007007.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
    if tc and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local te=tc:GetActivateEffect()
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
        Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
    end
end
function c1007007.defilter3(c)
    return c:IsSetCard(0x20f) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c1007007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c1007007.defilter3,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c1007007.defilter3,tp,LOCATION_MZONE,0,2,2,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c1007007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,357,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1007007.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,357,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,357,tp,false,false) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
function c1007007.tkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
    and re:GetHandler():IsSetCard(0x20f)
        and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c1007007.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,1007023,0,0x4011,1000,1000,2,RACE_FIEND,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c1007007.tkop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,1007023,0,0x4011,1000,1000,2,RACE_FIEND,ATTRIBUTE_DARK) then
        local token=Duel.CreateToken(tp,1007023)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(aux.Stringid(50078320,0))
            e1:SetCategory(CATEGORY_DESTROY)
            e1:SetType(EFFECT_TYPE_IGNITION)
            e1:SetRange(LOCATION_MZONE)
            e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
            e1:SetCountLimit(1)
            e1:SetTarget(c1007007.regtg)
            e1:SetOperation(c1007007.regop)
            token:RegisterEffect(e1)
            Duel.SpecialSummonComplete()
        end
end
function c1007007.desfilter(c)
    return c:IsFaceup() and c:IsDestructable()
end
function c1007007.regtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c1007007.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c1007007.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c1007007.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c1007007.regop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        tc:RegisterFlagEffect(1007007,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(1007007,1))
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e1:SetCountLimit(1)
        e1:SetLabelObject(tc)
        e1:SetCondition(c1007007.descon)
        e1:SetOperation(c1007007.desop)
        e1:SetReset(RESET_PHASE+PHASE_END,2)
        Duel.RegisterEffect(e1,tp)
    end
end
function c1007007.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(1007007)~=0
end
function c1007007.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.Hint(HINT_CARD,0,1007023)
    Duel.Destroy(tc,REASON_EFFECT)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
    Duel.Damage(1-tp,1000,REASON_EFFECT)
end
