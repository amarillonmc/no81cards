--霊術使いヒダウアラエ
function c84610035.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,2,c84610035.lcheck)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SPSUMMON)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c84610035.sptg)
    e1:SetOperation(c84610035.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(c84610035.valcheck)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    --summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(84610035,0))
    e3:SetCategory(CATEGORY_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O) 
    e3:SetCode(EVENT_FREE_CHAIN)    
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1) 
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e3:SetTarget(c84610035.sumtg)
    e3:SetOperation(c84610035.sumop)
    c:RegisterEffect(e3)
    --spsummon
    local e4=e3:Clone()
    e4:SetDescription(aux.Stringid(84610035,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetTarget(c84610035.sptg2)
    e4:SetOperation(c84610035.spop2)
    c:RegisterEffect(e4)
    --change pos
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(84610035,2))
    e5:SetCategory(CATEGORY_POSITION)
    e5:SetType(EFFECT_TYPE_QUICK_O) 
    e5:SetCode(EVENT_FREE_CHAIN)    
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1) 
    e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e5:SetTarget(c84610035.chtg)
    e5:SetOperation(c84610035.chop)
    c:RegisterEffect(e5)
    --atk up
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c84610035.atkcon)
    e5:SetOperation(c84610035.atkop)
    c:RegisterEffect(e5)
end
function c84610035.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610035.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetLabel()==1
        and Duel.IsExistingMatchingCard(c84610035.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c84610035.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610035.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c84610035.lcheck(g,lc)
    return g:IsExists(Card.IsLinkRace,1,nil,RACE_SPELLCASTER)
end
function c84610035.valcheck(e,c)
    local g=c:GetMaterial()
    local tc1=g:GetFirst()
    local tc2=g:GetNext()
    if tc1:GetOwner()~=e:GetHandlerPlayer() or tc2:GetOwner()~=e:GetHandlerPlayer() then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end
function c84610035.tfilter(c,att,e,tp,tc)
    return c:IsSetCard(0xbf) and not c:IsAttribute(att) and c:IsSummonable(true,nil)
end
function c84610035.sumfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and not c:IsPublic() and Duel.IsExistingMatchingCard(c84610035.tfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,c:GetAttribute(),e,tp,c)
end
function c84610035.f(c,att)
    return not c:IsPublic() and not (c:GetAttribute()&att)==att
end
function c84610035.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(846100351)==0
        and Duel.IsExistingTarget(c84610035.sumfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectTarget(tp,c84610035.sumfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
    e:SetLabel(g:GetFirst():GetAttribute())
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    e:GetHandler():RegisterFlagEffect(846100351,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c84610035.sumop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local att=tc:GetAttribute()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c84610035.tfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,att,e,tp,nil)
    local sc=g:GetFirst()
    if sc then
        Duel.Summon(tp,sc,true,nil)
    end
end
function c84610035.tfilter2(c,att,e,tp,tc)
    return c:IsSetCard(0xbf) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c84610035.spfilter2(c,e,tp)
    return c:IsType(TYPE_MONSTER) and not c:IsPublic() and Duel.IsExistingMatchingCard(c84610035.tfilter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,c:GetAttribute(),e,tp,c)
end
function c84610035.chkfilter2(c,att)
    return not c:IsPublic() and no (c:GetAttribute()&att)==att
end
function c84610035.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(846100351)==0
        and Duel.IsExistingTarget(c84610035.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectTarget(tp,c84610035.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
    e:SetLabel(g:GetFirst():GetAttribute())
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    e:GetHandler():RegisterFlagEffect(846100351,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c84610035.spop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local att=tc:GetAttribute()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610035.tfilter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,att,e,tp,nil)
    local sc=g:GetFirst()
    if sc then
        Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
        Duel.ConfirmCards(1-tp,sc)
    end
end
function c84610035.chfilter(c)
    return (not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()) or c:IsCanTurnSet() and c:IsLocation(LOCATION_MZONE)
end
function c84610035.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c84610035.chfilter,tp,LOCATION_MZONE,0,1,nil) end
    if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectTarget(tp,c84610035.chfilter,tp,LOCATION_MZONE,0,1,99,nil)
    e:SetLabelObject(g)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c84610035.cmfilter(c)
    return c:IsFaceup() and (c:IsSetCard(0xbf) or c:IsSetCard(0x10c0))
end
function c84610035.sfilter(c,tp)
    return (c:IsCode(38057522) and c:GetActivateEffect():IsActivatable(tp,true,true))
        or (c:IsCode(62256492,25704359) and c:GetActivateEffect():IsActivatable(tp))
        or (c:IsCode(5037726,6540606,38167722,42945701,70156997,79333300,91530236,65046521) and c:IsSSetable())
end
function c84610035.scheck(g)
    return g:GetClassCount(Card.GetCode)==#g
end
function c84610035.chop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c84610035.chfilter,nil,e,tp)
    local sc=e:GetLabelObject()
    if tg:GetCount()==0 and tg:GetCount()~=sc:GetCount() then return false end
    local tc=tg:GetFirst()
    local sumcount=0
    while tc do
        if tc:IsAttackPos() then
            local pos=0
            if tc:IsCanTurnSet() then
                pos=Duel.SelectPosition(tp,tc,POS_DEFENSE)
            else
                pos=Duel.SelectPosition(tp,tc,POS_FACEUP_DEFENSE)
            end
            count=Duel.ChangePosition(tc,pos)
        else
            count=Duel.ChangePosition(tc,0,0,POS_FACEDOWN_DEFENSE,POS_FACEUP_DEFENSE)
        end
        tc=tg:GetNext()
        sumcount=sumcount+count
    end
    local g1=Duel.GetMatchingGroup(c84610035.cmfilter,tp,LOCATION_MZONE,0,nil)
    local g2=Duel.GetMatchingGroup(c84610035.sfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,tp)
    local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)+1
    ct=math.min(ct,g1:GetCount())
    if ct>0 and g2:GetCount()>0 and sumcount>0
        and Duel.GetFlagEffect(tp,84610035)==0 and Duel.SelectYesNo(tp,aux.Stringid(84610035,3)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(84610035,4))
        if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
        local se=g2:SelectSubGroup(tp,c84610035.scheck,false,1,ct)
        Duel.ResetFlagEffect(tp,15248873)
        local sel=se:GetFirst()
        while sel do
            if sel:GetType()==0x80002 then
                local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
                if fc then
                    Duel.SendtoGrave(fc,REASON_RULE)
                    Duel.BreakEffect()
                end
                Duel.MoveToField(sel,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
                local te=sel:GetActivateEffect()
                te:UseCountLimit(tp,1,true)
                local tep=sel:GetControler()
                local cost=te:GetCost()
                if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
                Duel.RaiseEvent(sel,4179255,te,0,tp,tp,Duel.GetCurrentChain())
            end
            if sel:GetType()==0x20002 or sel:GetType()==0x20004 then
                Duel.MoveToField(sel,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
                local te=sel:GetActivateEffect()
                local tep=sel:GetControler()
                local cost=te:GetCost()
                if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
            end
            if sel:GetType()==0x4 then
                Duel.SSet(tp,sel)
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
                e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                sel:RegisterEffect(e1)
            end
            if sel:GetType()==0x10002 then
                Duel.SSet(tp,sel)
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
                e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                sel:RegisterEffect(e1)
            end
            sel=se:GetNext()
        end
        Duel.RegisterFlagEffect(tp,84610035,RESET_PHASE+PHASE_END,0,1)
    end
end
function c84610035.egfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x10c0) and c:IsPreviousLocation(LOCATION_DECK)
end
function c84610035.atkfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c84610035.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c84610035.egfilter,1,nil)
end
function c84610035.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetMatchingGroup(c84610035.atkfilter,tp,LOCATION_MZONE,0,nil)
    local tc=tg:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(tc:GetAttack()*2)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc=tg:GetNext()
    end
end
