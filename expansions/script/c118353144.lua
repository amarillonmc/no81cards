function c118353144.initial_effect(c)
    c:SetSPSummonOnce(118353144)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c118353144.spcon)
    e1:SetOperation(c118353144.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(118353144,2))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1+EFFECT_COUNT_CODE_SINGLE)
    e2:SetCondition(aux.NOT(c118353144.condition))
    e2:SetCost(c118353144.tgcost)
    e2:SetTarget(c118353144.tgtg)
    e2:SetOperation(c118353144.tgop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCondition(c118353144.condition)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(c118353144.destg)
    e4:SetOperation(c118353144.desop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetOperation(c118353144.damop1)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_CHAINING)
    e6:SetRange(LOCATION_GRAVE)
    e6:SetOperation(c118353144.damop2)
    c:RegisterEffect(e6)
end
function c118353144.xyzfilter(c,tp,xyzc)
    return c118353144.mfilter(c,xyzc) and c:IsControler(tp) and c:IsFaceup() and c:IsPreviousLocation(LOCATION_ONFIELD) and not c:IsType(TYPE_XYZ) and c:IsSetCard(0xb1)
end
function c118353144.mfilter(c,xyzc)
    return c:IsCanBeXyzMaterial(xyzc)
end
function c118353144.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local mg=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
    return mg:IsExists(c118353144.xyzfilter,1,nil,tp,c) and not mg:IsExists(aux.NOT(c118353144.mfilter),1,nil,c) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c118353144.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.SelectYesNo(tp,aux.Stringid(118353144,0)) then
        local mg=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
        local sg=Group.CreateGroup()
        for tc in aux.Next(mg) do
            tc:CancelToGrave()
            sg:Merge(tc:GetOverlayGroup())
        end
        Duel.SendtoGrave(sg,REASON_RULE)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_SPSUMMON_PROC)
        e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
        e1:SetRange(LOCATION_EXTRA)
        e1:SetValue(SUMMON_TYPE_XYZ)
        c:RegisterEffect(e1)
        c:SetMaterial(mg)
        Duel.Overlay(c,mg)
        Duel.XyzSummon(tp,c,nil)
        e1:Reset()
    end
end
function c118353144.tgcostfilter(c)
    return c:IsSetCard(0xb1) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c118353144.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,118353144)==0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c118353144.tgcostfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.RegisterFlagEffect(tp,118353144,RESET_PHASE+PHASE_END,0,1)
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c118353144.tgcostfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c118353144.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function c118353144.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function c118353144.desfilter(c)
    return c:IsSetCard(0xb1) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c118353144.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local n=eg:Filter(Card.IsControler,nil,tp):FilterCount(Card.IsPreviousLocation,nil,LOCATION_DECK)
    if chk==0 then return n>0 and eg:Filter(Card.IsControler,nil,tp):IsExists(Card.IsAbleToDeck,n,nil) and Duel.GetMatchingGroup(c118353144.desfilter,tp,LOCATION_DECK,0,nil):GetCount()>=n and c:GetFlagEffect(118353145)==0 end
    e:SetLabel(n)
end
function c118353144.desop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectYesNo(tp,aux.Stringid(118353144,3)) then
        Duel.Hint(HINT_CARD,0,118353144)
        c:RegisterFlagEffect(118353145,RESET_PHASE+PHASE_END,0,1)
        local n=e:GetLabel()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c118353144.desfilter,tp,LOCATION_DECK,0,n,n,nil)
        if g:GetCount()>0 then
            Duel.SendtoGrave(g,REASON_EFFECT)
            Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
        end
    end
end
function c118353144.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():Filter(Card.IsSetCard,nil,0xb1):GetClassCount(Card.GetCode)>1
end
function c118353144.damfilter(c)
    return c:IsSetCard(0xb1) and c:IsType(TYPE_MONSTER) and c:GetBaseDefense()>0 and c:IsAbleToDeck()
end
function c118353144.damop1(e,tp,eg,ep,ev,re,r,rp)
    local val=Duel.GetBattleDamage(tp)
    local g=Duel.GetMatchingGroup(c118353144.damfilter,tp,LOCATION_GRAVE,0,nil)
    if g:GetSum(Card.GetBaseDefense)>val then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local tg=g:SelectWithSumGreater(tp,Card.GetBaseDefense,val)
        if tg:GetCount()>0 then
            Duel.Hint(HINT_CARD,0,118353144)
            Duel.SendtoDeck(tg,nil,nil,REASON_REPLACE)
            Duel.ShuffleDeck(tp)
            Duel.ChangeBattleDamage(tp,0)
        end
    end
end
function c118353144.damop2(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.GlobalEffect()
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetLabel(Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID))
    e1:SetValue(c118353144.damval)
    e1:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    Duel.RegisterEffect(e2,tp)
end
function c118353144.damval(e,re,val,r,rp,rc)
    local tp=e:GetHandlerPlayer()
    local g=Duel.GetMatchingGroup(c118353144.damfilter,tp,LOCATION_GRAVE,0,nil)
    if Duel.GetCurrentChain()~=0 and bit.band(r,REASON_EFFECT)~=0 and Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)==e:GetLabel() and g:GetSum(Card.GetBaseDefense)>=val then
        local e1=Effect.GlobalEffect()
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_CHAIN_SOLVED)
        e1:SetLabel(val)
        e1:SetOperation(c118353144.damop3)
        e1:SetReset(RESET_CHAIN)
        Duel.RegisterEffect(e1,tp)
        return 0
    end
    return val
end
function c118353144.damop3(e,tp,eg,ep,ev,re,r,rp)
    local val=e:GetLabel()
    local g=Duel.GetMatchingGroup(c118353144.damfilter,tp,LOCATION_GRAVE,0,nil)
    if g:GetSum(Card.GetBaseDefense)>=val then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local tg=g:SelectWithSumGreater(tp,Card.GetBaseDefense,val)
        if tg:GetCount()>0 then
            Duel.Hint(HINT_CARD,0,118353144)
            Duel.SendtoDeck(tg,nil,nil,REASON_REPLACE)
            Duel.ShuffleDeck(tp)
        end
    end
end