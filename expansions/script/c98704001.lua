--真帝机 天从
local m=98704001
local cm=_G["c"..m]
if not MQTVal then
    MQTVal=MQTVal or {}
    mqt=MQTVal
    function mqt.ismqt(c)
        local n=_G["c"..c:GetCode()]
        return n and n.mqt
    end
    function mqt.ispreviousmqt(c)
        local n=_G["c"..c:GetPreviousCodeOnField()]
        return n and n.mqt
    end
    function mqt.SummonWithNoTributeEffect(c)
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(m,2))
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SUMMON_PROC)
        e2:SetCondition(mqt.ntcon)
        c:RegisterEffect(e2)
    end
    function mqt.ntcon(e,c,minc)
        if c==nil then return true end
        return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
    end
    function mqt.SummonWithDoubledTributeEffect(c)
        local e3=Effect.CreateEffect(c)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e3:SetType(EFFECT_TYPE_FIELD)
        e3:SetCode(EFFECT_DOUBLE_TRIBUTE)
        e3:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
        e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
        e3:SetValue(function(e,c) return c==e:GetHandler() end)
        e3:SetTarget(function(e,c) return c:IsSummonType(SUMMON_TYPE_ADVANCE) end)
        c:RegisterEffect(e3)
    end
    function mqt.SummonWithExtraTributeEffect(c)
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e4:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
        e4:SetTargetRange(LOCATION_SZONE,0)
        e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
        e4:SetValue(POS_FACEUP_ATTACK)
        c:RegisterEffect(e4)
    end
    function mqt.SummonWithThreeTributeEffect(c)
        local e6=Effect.CreateEffect(c)
        e6:SetDescription(aux.Stringid(m,3))
        e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e6:SetType(EFFECT_TYPE_SINGLE)
        e6:SetCode(EFFECT_SUMMON_PROC)
        e6:SetValue(SUMMON_TYPE_ADVANCE+1)
        e6:SetCondition(mqt.ttcon)
        e6:SetOperation(mqt.ttop)
        c:RegisterEffect(e6)
    end
    function mqt.ttcon(e,c,minc)
        if c==nil then return true end
        return minc<=3 and Duel.CheckTribute(c,3)
    end
    function mqt.ttop(e,tp,eg,ep,ev,re,r,rp,c)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local g=Duel.SelectTribute(tp,c,3,3)
        c:SetMaterial(g)
        Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
    end
    function mqt.ChangeLevelEffect(c)
        local e7=Effect.CreateEffect(c)
        e7:SetType(EFFECT_TYPE_SINGLE)
        e7:SetCode(EFFECT_SUMMON_COST)
        e7:SetOperation(mqt.lvop)
        c:RegisterEffect(e7)
        local e8=Effect.CreateEffect(c)
        e8:SetType(EFFECT_TYPE_SINGLE)
        e8:SetCode(EFFECT_SPSUMMON_COST)
        e8:SetOperation(mqt.lvop2)
        c:RegisterEffect(e8)
    end
    function mqt.lvcon(e)
        return e:GetHandler():GetMaterialCount()==0
    end
    function mqt.lvop(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCondition(mqt.lvcon)
        e1:SetValue(4)
        e1:SetReset(RESET_EVENT+0xff0000)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_BASE_ATTACK)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCondition(mqt.lvcon)
        e2:SetValue(1800)
        e2:SetReset(RESET_EVENT+0xff0000)
        c:RegisterEffect(e2)
    end
    function mqt.lvop2(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetValue(4)
        e1:SetReset(RESET_EVENT+0x7f0000)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_BASE_ATTACK)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetValue(1800)
        e2:SetReset(RESET_EVENT+0x7f0000)
        c:RegisterEffect(e2)
    end
    function mqt.ResistanceEffect(c)
        local e9=Effect.CreateEffect(c)
        e9:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
        e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e9:SetCode(EVENT_SUMMON_SUCCESS)
        e9:SetCondition(mqt.immcon)
        e9:SetOperation(mqt.immop)
        c:RegisterEffect(e9)
    end
    function mqt.immcon(e)
        return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
    end
    function mqt.immop(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetRange(LOCATION_MZONE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(mqt.immfilter)
        c:RegisterEffect(e1)
        if c:GetSummonType()==SUMMON_TYPE_ADVANCE+1 then
            c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
        end
    end
    function mqt.immfilter(e,te)
        local c=e:GetHandler()
        local lv=c:GetLevel()
        local ec=te:GetOwner()
        return te:IsActivated() and ((te:IsActiveType(TYPE_MONSTER) and ((ec:IsType(TYPE_LINK) and ec:GetLink()<=4 and c:GetSummonType()==SUMMON_TYPE_ADVANCE+1) or (ec:IsType(TYPE_XYZ) and ec:GetOriginalRank()<lv) or ec:GetOriginalLevel()<lv)) or (te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and c:GetSummonType()==SUMMON_TYPE_ADVANCE+1))
    end
    function mqt.SummonSuccessEffect(c,category,operation)
        local e10=Effect.CreateEffect(c)
        e10:SetDescription(aux.Stringid(m,5))
        e10:SetCategory(category)
        e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e10:SetCode(EVENT_SUMMON_SUCCESS)
        e10:SetProperty(EFFECT_FLAG_DELAY)
        e10:SetTarget(mqt.sstg)
        e10:SetOperation(operation)
        c:RegisterEffect(e10)
    end
    function mqt.ssfilter(c)
        return mqt.ismqt(c) and c:IsAbleToGrave()
    end
    function mqt.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then
            local g=Duel.GetMatchingGroup(mqt.ssfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
            return g:GetClassCount(Card.GetCode)>1
        end
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
        if e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) then e:SetLabel(1) end
    end
    function mqt.SearchEffect(c,description)
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(m,6))
        e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
        e2:SetType(EFFECT_TYPE_QUICK_O)
        e2:SetCode(EVENT_CHAINING)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCountLimit(1)
        e2:SetCondition(mqt.thcon)
        e2:SetTarget(mqt.thtg)
        e2:SetOperation(mqt.thop)
        c:RegisterEffect(e2)
    end
    function mqt.thcon(e,tp,eg,ep,ev,re,r,rp)
        return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and rp==1-tp
    end
    function mqt.thfilter(c,tp)
        return mqt.ismqt(c) and (c:IsAbleToHand() or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetActivateEffect():IsActivatable(tp)))
    end
    function mqt.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then return Duel.IsExistingMatchingCard(mqt.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
        e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        Duel.SetTargetCard(Group.CreateGroup())
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    end
    function mqt.thop(e,tp,eg,ep,ev,re,r,rp)
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,7))
        local g=Duel.SelectMatchingCard(tp,mqt.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
        local tc=g:GetFirst()
        if tc then
            local te,code,condition,cost,target,operation
            if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
                te=tc:GetActivateEffect()
                code=te:GetCode()
                condition=te:GetCondition()
                cost=te:GetCost()
                target=te:GetTarget()
                operation=te:GetOperation()
            end
            local b1=tc:IsAbleToHand()
            local b2=te and code==EVENT_FREE_CHAIN and te:IsActivatable(tp)
                and (not condition or condition(te,tp,eg,ep,ev,re,r,rp))
                and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0))
                and (not target or target(te,tp,eg,ep,ev,re,r,rp,0))
            if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
                Duel.SendtoHand(tc,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,tc)
            else
                if tc:IsType(TYPE_FIELD) then
                    local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
                    if fc then
                        Duel.SendtoGrave(fc,REASON_RULE)
                        Duel.BreakEffect()
                    end
                    Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
                else
                    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
                end
                Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
                if te:GetActiveType()==TYPE_SPELL or te:GetActiveType()==TYPE_TRAP then
                    tc:CancelToGrave(false)
                end
                tc:CreateEffectRelation(te)
                if cost then cost(te,tp,eg,ep,ev,re,r,rp,1) end
                if target then target(te,tp,eg,ep,ev,re,r,rp,1) end
                e:SetProperty(te:GetProperty())
                local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
                local tg=nil
                if g then
                    tg=g:GetFirst()
                    while tg do
                        tg:CreateEffectRelation(te)
                        tg=g:GetNext()
                    end
                end
                tc:SetStatus(STATUS_ACTIVATED,true)
                if operation then operation(te,tp,eg,ep,ev,re,r,rp) end
                te:UseCountLimit(tp,1,true)
                tc:ReleaseEffectRelation(te)
                if g then
                    tg=g:GetFirst()
                    while tg do
                        tg:ReleaseEffectRelation(te)
                        tg=g:GetNext()
                    end
                end
                if tc:IsType(TYPE_FIELD) then
                    Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
                end
            end
        end
    end
    function mqt.ReleaseEffect(c,category,target,operation)
        local code=c:GetOriginalCode()
        local e12=Effect.CreateEffect(c)
        e12:SetDescription(aux.Stringid(code,0))
        e12:SetCategory(category)
        e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e12:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
        e12:SetCode(EVENT_RELEASE)
        e12:SetCountLimit(1,code+100)
        e12:SetTarget(target)
        e12:SetOperation(operation)
        c:RegisterEffect(e12)
    end
end
if cm then
cm.mqt=true
function cm.initial_effect(c)
    mqt.SummonWithNoTributeEffect(c)
    mqt.SummonWithExtraTributeEffect(c)
    mqt.ChangeLevelEffect(c)
    mqt.ResistanceEffect(c)
    --spsummon self
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,m)
    e1:SetHintTiming(TIMING_END_PHASE)
    e1:SetCost(cm.spcost)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
    --spsummon from deck&grave
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,m+100)
    e2:SetCost(cm.cost)
    e2:SetTarget(cm.tg)
    e2:SetOperation(cm.op)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
    return c:IsSummonableCard()
end
function cm.cfilter(c)
    return mqt.ismqt(c) and c:IsAbleToRemoveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0
        and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,c)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSummonableCard()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    Duel.RegisterEffect(e1,tp)
end
function cm.filter(c,e,tp)
    return mqt.ismqt(c) and not c:IsCode(m) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
        end
    end
end
end
