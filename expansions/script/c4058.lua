--纳迦的存在
function c4058.initial_effect(c)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,4058)
    --fusion material
    aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x50),4,true)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c4058.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c4058.sprcon)
    e2:SetOperation(c4058.sprop)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_ONFIELD)
    e3:SetValue(c4058.efilter)
    c:RegisterEffect(e3)
    --atk
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
    e4:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e4)
    --sumlimit
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_SUMMON)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_ONFIELD)
    e5:SetTargetRange(1,0)
    e5:SetTarget(c4058.sumlimit)
    c:RegisterEffect(e5)
    --extra summon
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
    e6:SetRange(LOCATION_ONFIELD)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetTargetRange(1,0)
    e6:SetValue(3)
    e6:SetTarget(c4058.extg)
    c:RegisterEffect(e6)
    --Activate
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e7:SetRange(LOCATION_ONFIELD)
    e7:SetCode(EFFECT_SEND_REPLACE)
    e7:SetTarget(c4058.reptg)
    e7:SetValue(c4058.repval)
    c:RegisterEffect(e7)
    --triple tribute
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e8:SetRange(LOCATION_MZONE)
    e8:SetTargetRange(LOCATION_HAND,0)
    e8:SetCondition(c4058.ttcon)
    e8:SetTarget(c4058.extg2)
    e8:SetOperation(c4058.ttop)
    e8:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e8)
    --battle
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_ADJUST)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCondition(c4058.damcon2)
    e9:SetOperation(c4058.disop)
    c:RegisterEffect(e9)
    --battle
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e10:SetCode(EVENT_ADJUST)
    e10:SetRange(LOCATION_MZONE)
    e10:SetCondition(c4058.damcon)
    e10:SetOperation(c4058.disop2)
    c:RegisterEffect(e10)
    --triple tribute
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(LOCATION_HAND,0)
    e11:SetCondition(c4058.ttcon2)
    e11:SetTarget(c4058.extg3)
    e11:SetOperation(c4058.ttop2)
    e11:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e11)
    --battle
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetCode(EVENT_PHASE+PHASE_END)
    e12:SetRange(LOCATION_MZONE)
    e12:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e12:SetCountLimit(1)
    e12:SetCondition(c4058.damcon3)
    e12:SetOperation(c4058.disop3)
    c:RegisterEffect(e12)
    --Activate
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetRange(LOCATION_MZONE)
    e13:SetCode(EVENT_SUMMON_SUCCESS)
    e13:SetCondition(c4058.condition2)
    e13:SetTarget(c4058.target2)
    e13:SetOperation(c4058.operation2)
    c:RegisterEffect(e13)
    --battle
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e14:SetCode(EVENT_SUMMON)
    e14:SetRange(LOCATION_SZONE)
    e14:SetCondition(c4058.damcon4)
    e14:SetOperation(c4058.disop)
    c:RegisterEffect(e14)
    --Activate
    local e15=Effect.CreateEffect(c)
    e15:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e15:SetType(EFFECT_TYPE_ACTIVATE)
    e15:SetCode(EVENT_DESTROYED)
    e15:SetCountLimit(1,16067089)
    e15:SetRange(LOCATION_DECK)
    e15:SetCondition(c4058.condition4)
    e15:SetTarget(c4058.target4)
    e15:SetOperation(c4058.activate4)
    local e16=Effect.CreateEffect(c)
    e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e16:SetRange(LOCATION_ONFIELD)
    e16:SetTargetRange(LOCATION_DECK,0)
    e16:SetTarget(c4058.eftg)
    e16:SetLabelObject(e15)
    c:RegisterEffect(e16)
    --出场
    local e17=Effect.CreateEffect(c)
    e17:SetType(EFFECT_TYPE_FIELD)
    e17:SetCode(EFFECT_ACTIVATE_COST)
    e17:SetRange(LOCATION_DECK)
    e17:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e17:SetTargetRange(1,0)
    e17:SetTarget(c4058.actarget)
    e17:SetOperation(c4058.costop)
    local e18=Effect.CreateEffect(c)
    e18:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e18:SetRange(LOCATION_ONFIELD)
    e18:SetTargetRange(LOCATION_DECK,0)
    e18:SetTarget(c4058.eftg4)
    e18:SetLabelObject(e17)
    c:RegisterEffect(e18)
    --negate
    local e19=Effect.CreateEffect(c)
    e19:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e19:SetType(EFFECT_TYPE_ACTIVATE)
    e19:SetCode(EVENT_CHAINING)
    e19:SetRange(LOCATION_DECK)
    e19:SetCountLimit(1,80678380)
    e19:SetCondition(c4058.condition5)
    e19:SetCost(c4058.cost5)
    e19:SetTarget(c4058.target5)
    e19:SetOperation(c4058.activate5)
    local e20=Effect.CreateEffect(c)
    e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e20:SetRange(LOCATION_ONFIELD)
    e20:SetTargetRange(LOCATION_DECK,0)
    e20:SetTarget(c4058.eftg2)
    e20:SetLabelObject(e19)
    c:RegisterEffect(e20)
    --Activate
    local e21=Effect.CreateEffect(c)
    e21:SetCategory(CATEGORY_DESTROY)
    e21:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e21:SetType(EFFECT_TYPE_ACTIVATE)
    e21:SetCode(EVENT_FREE_CHAIN)
    e21:SetRange(LOCATION_DECK)
    e21:SetCountLimit(1,93217231)
    e21:SetHintTiming(0,0x1e0)
    e21:SetTarget(c4058.target6)
    e21:SetOperation(c4058.activate6)
    local e22=Effect.CreateEffect(c)
    e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e22:SetRange(LOCATION_ONFIELD)
    e22:SetTargetRange(LOCATION_DECK,0)
    e22:SetTarget(c4058.eftg3)
    e22:SetLabelObject(e21)
    c:RegisterEffect(e22)
    --activate from hand
    local e23=Effect.CreateEffect(c)
    e23:SetType(EFFECT_TYPE_FIELD)
    e23:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e23:SetRange(LOCATION_ONFIELD)
    e23:SetTarget(aux.TargetBoolFunction(Card.IsCode,93217231,80678380,16067089))
    e23:SetTargetRange(LOCATION_HAND,0)
    c:RegisterEffect(e23)
    --activate cost
    local e24=Effect.CreateEffect(c)
    e24:SetType(EFFECT_TYPE_FIELD)
    e24:SetCode(EFFECT_ACTIVATE_COST)
    e24:SetRange(LOCATION_ONFIELD)
    e24:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e24:SetTargetRange(1,0)
    e24:SetCost(c4058.costchk)
    e24:SetTarget(c4058.costtg)
    e24:SetOperation(c4058.costop2)
    c:RegisterEffect(e24)
    --special summon
    local e25=Effect.CreateEffect(c)
    e25:SetType(EFFECT_TYPE_FIELD)
    e25:SetCode(EFFECT_SPSUMMON_PROC_G)
    e25:SetRange(LOCATION_DECK)
    e25:SetCondition(c4058.spcon)
    local e26=Effect.CreateEffect(c)
    e26:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e26:SetRange(LOCATION_ONFIELD)
    e26:SetTargetRange(LOCATION_DECK,0)
    e26:SetTarget(c4058.eftg4)
    e26:SetLabelObject(e25)
    c:RegisterEffect(e26)
end
function c4058.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c4058.spfilter(c)
    return c:IsFusionSetCard(0x50) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c4058.fselect(c,tp,mg,sg,tc)
    sg:AddCard(c)
    local res=false
    if sg:GetClassCount(Card.GetCode)<4 then
        res=mg:IsExists(c4058.fselect,1,sg,tp,mg,sg,tc)
    else
        res=Duel.GetLocationCountFromEx(tp,tp,sg,tc)>0
    end
    sg:RemoveCard(c)
    return res
end
function c4058.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c4058.spfilter,tp,LOCATION_DECK,0,nil)
    local sg=Group.CreateGroup()
    return mg:IsExists(c4058.fselect,1,nil,tp,mg,sg,c)
end
function c4058.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c4058.spfilter,tp,LOCATION_DECK,0,nil)
    local sg=Group.CreateGroup()
    while sg:GetClassCount(Card.GetCode)<4 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=mg:FilterSelect(tp,c4058.fselect,1,1,sg,tp,mg,sg)
        mg:Remove(Card.IsCode,nil,g:GetFirst():GetCode())
        sg:Merge(g)
    end
    Duel.SendtoGrave(sg,nil,2,REASON_EFFECT+REASON_MATERIAL)
end
function c4058.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c4058.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x50)
end
function c4058.sumlimit(e,c)
    return not c:IsRace(RACE_REPTILE)
end
function c4058.extg(e,c)
    return c:IsRace(RACE_REPTILE)
end
function c4058.extg2(e,c)
    return c:IsRace(RACE_REPTILE) and c:IsLevelAbove(5) and c:IsLevelBelow(6)
end
function c4058.extg3(e,c)
    return c:IsRace(RACE_REPTILE) and c:IsLevelAbove(7)
end
function c4058.ttfilter(c)
    return c:IsSetCard(0x50) and c:IsType(TYPE_MONSTER) or c:IsLocation(LOCATION_MZONE)
end
function c4058.ttcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    return c:GetLevel()>4 and minc<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c4058.ttfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil)
end
function c4058.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local sg=Duel.SelectMatchingCard(tp,c4058.ttfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil)
    c:SetMaterial(sg)
    Duel.SendtoGrave(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c4058.ttcon2(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    return c:GetLevel()>4 and minc<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c4058.ttfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,2,nil)
end
function c4058.ttop2(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local sg=Duel.SelectMatchingCard(tp,c4058.ttfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,2,2,nil)
    c:SetMaterial(sg)
    Duel.SendtoGrave(sg,REASON_SUMMON+REASON_MATERIAL+REASON_COST)
end
function c4058.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsCode(8062132) and c:IsFaceup()
end
function c4058.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return eg:IsExists(c4058.repfilter,1,nil,tp) and c:IsAbleToGrave() end
    if Duel.SelectEffectYesNo(tp,c,96) then
        Duel.SendtoGrave(c,REASON_REPLACE)
        return true
    end
    return false
end
function c4058.repval(e,c)
    return c4058.repfilter(c,e:GetHandlerPlayer())
end
function c4058.damcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c4058.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c4058.disop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
    c:RegisterFlagEffect(4058,RESET_EVENT+0x1fc0000,0,1)
end
function c4058.damcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c4058.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) 
end
function c4058.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
end
function c4058.cfilter(c)
    return c:IsCode(8062132)
end
function c4058.damcon3(e,tp,eg,ep,ev,re,r,rp)
    if c==nil then return true end
    return Duel.IsExistingMatchingCard(c4058.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c4058.disop3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local g=Duel.SelectMatchingCard(tp,c4058.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
    local tc=g:GetFirst()
    while tc do
        tc:AddCounter(0x11,1,REASON_EFFECT)
        tc=g:GetNext()
    end
end
function c4058.condition2(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    local lv=tc:GetLevel()
    return eg:GetCount()==1 and tc:IsRace(RACE_REPTILE) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function c4058.filter3(c,e,tp,lv)
    return (c:GetLevel()==lv or c:GetRank()==lv) and c:IsRace(RACE_REPTILE) and c:IsCanBeSpecialSummoned(e,nil,tp,false,false,POS_FACEUP)
end
function c4058.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4058.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,eg:GetFirst():GetLevel()) and Duel.GetLocationCountFromEx(tp)>0 end
    e:SetLabel(eg:GetFirst():GetLevel())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c4058.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetFlagEffect(tp,4058)==0 and Duel.SelectYesNo(tp,aux.Stringid(4058,1)) then
    Duel.RegisterFlagEffect(tp,4058,RESET_CHAIN,0,1)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c4058.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel())
    if g:GetCount()~=0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function c4058.cfilter2(c)
    return (c:GetSummonType()==SUMMON_TYPE_ADVANCE or c:GetSummonType()==SUMMON_TYPE_NORMAL) and c:IsSetCard(0x50)
end
function c4058.damcon4(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c4058.cfilter2,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function c4058.cfilter3(c,tp)
    return c:IsCode(72677437) and c:GetPreviousControler()==tp
        and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c4058.condition4(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c4058.cfilter3,1,nil,tp)
end
function c4058.filter4(c,e,tp)
    return c:IsCode(8062132) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c4058.target4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c4058.filter4,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c4058.activate4(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c4058.filter4,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function c4058.eftg(e,c)
    return c:IsCode(16067089) 
end
function c4058.eftg2(e,c)
    return c:IsCode(80678380) 
end
function c4058.eftg3(e,c)
    return c:IsCode(93217231) 
end
function c4058.eftg4(e,c)
    return c:IsCode(16067089,80678380,93217231) 
end
function c4058.actarget(e,te,tp) 
    return te:GetHandler()==e:GetHandler()
end
function c4058.costop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    --oath effects
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(1,0)
    e1:SetValue(c4058.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c4058.condition5(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c4058.cfilter4(c)
    return c:IsSetCard(0x50) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c4058.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4058.cfilter4,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c4058.cfilter4,tp,LOCATION_HAND,0,1,1,nil)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
end
function c4058.target5(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c4058.activate5(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c4058.filter5(c)
    return c:IsFaceup() and c:IsRace(RACE_REPTILE)
end
function c4058.target6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c4058.filter5,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,c4058.filter5,tp,LOCATION_MZONE,0,1,1,nil) 
    e:SetLabelObject(g1:GetFirst())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,2,2,nil)g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c4058.activate6(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    local sc=e:GetLabelObject()
    if sg:GetCount()~=3 or sc:IsFacedown() or not sc:IsRace(RACE_REPTILE) or sc:IsControler(1-tp) then return end
    Duel.Destroy(sg,REASON_EFFECT)
end
function c4058.costtg(e,te,tp)
    local tc=te:GetHandler()
    return tc:IsLocation(LOCATION_HAND)
end
function c4058.costchk(e,te_or_c,tp)
    return Duel.GetFlagEffect(tp,16067089)==0
end
function c4058.costop2(e,tp,eg,ep,ev,re,r,rp)
    --oath effects
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(1,0)
    e1:SetValue(c4058.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c4058.aclimit(e,re,tp)
    return re:GetHandler():IsLocation(LOCATION_HAND+LOCATION_DECK) and re:GetHandler():IsCode(e:GetHandler():GetCode())
end
function c4058.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return not c:IsPublic()
end