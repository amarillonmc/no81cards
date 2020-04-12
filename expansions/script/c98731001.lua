function c98731001.initial_effect(c)
    c:EnableReviveLimit()
    aux.EnablePendulumAttribute(c,false)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCondition(c98731001.spcon)
    e1:SetOperation(c98731001.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(c98731001.efilter)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_ADD_ATTRIBUTE)
    e3:SetRange(LOCATION_PZONE)
    e3:SetValue(0xf)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e4:SetRange(LOCATION_PZONE)
    e4:SetTargetRange(0xff,0)
    e4:SetTarget(c98731001.etarget)
    e4:SetValue(c98731001.efilter2)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
    e5:SetRange(0x7f)
    e5:SetCondition(c98731001.condition)
    e5:SetOperation(c98731001.operation)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e6:SetCode(EVENT_CHAIN_SOLVING)
    e6:SetRange(LOCATION_MZONE)
    e6:SetOperation(c98731001.chop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_UPDATE_ATTACK)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetValue(c98731001.atkval)
    c:RegisterEffect(e7)
    local e8=e7:Clone()
    e8:SetCode(EFFECT_UPDATE_DEFENSE)
    e8:SetValue(c98731001.defval)
    c:RegisterEffect(e8)
    local e9=e7:Clone()
    e9:SetCode(EFFECT_ADD_ATTRIBUTE)
    e9:SetValue(c98731001.attrval)
    c:RegisterEffect(e9)
    local e10=e7:Clone()
    e10:SetCode(EFFECT_EXTRA_ATTACK)
    e10:SetValue(c98731001.mulval)
    c:RegisterEffect(e10)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e11:SetCode(EVENT_SPSUMMON_SUCCESS)
    e11:SetTarget(c98731001.tgtg)
    e11:SetOperation(c98731001.tgop)
    c:RegisterEffect(e11)
end
function c98731001.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c98731001.etarget(e,c)
    return c:IsSetCard(0xe6e)
end
function c98731001.efilter2(e,re)
    return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function c98731001.cfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(0xf) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:GetLevel()==7 and c:IsAbleToRemoveAsCost()
end
function c98731001.fcheck(c,sg,g,code,...)
    if not c:IsAttribute(code) then return false end
    if ... then
        g:AddCard(c)
        local res=sg:IsExists(c98731001.fcheck,1,g,sg,g,...)
        g:RemoveCard(c)
        return res
    else return true end
end
function c98731001.fselect(c,tp,mg,sg,...)
    sg:AddCard(c)
    local res=false
    if sg:GetCount()<4 then
        res=mg:IsExists(c98731001.fselect,1,sg,tp,mg,sg,...)
    else
        local g=Group.CreateGroup()
        res=sg:IsExists(c98731001.fcheck,1,nil,sg,g,...)
    end
    sg:RemoveCard(c)
    return res
end
function c98731001.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c98731001.cfilter,tp,LOCATION_ONFIELD,0,c)
    local sg=Group.CreateGroup()
    return mg:IsExists(c98731001.fselect,1,nil,tp,mg,sg,ATTRIBUTE_FIRE,ATTRIBUTE_WATER,ATTRIBUTE_WIND,ATTRIBUTE_EARTH)
end
function c98731001.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c98731001.cfilter,tp,LOCATION_ONFIELD,0,c)
    local sg=Group.CreateGroup()
    while sg:GetCount()<4 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=mg:FilterSelect(tp,c98731001.fselect,1,1,sg,tp,mg,sg,ATTRIBUTE_FIRE,ATTRIBUTE_WATER,ATTRIBUTE_WIND,ATTRIBUTE_EARTH)
        sg:Merge(g)
    end
    Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c98731001.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return not c:IsLocation(LOCATION_PZONE) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.GetTurnPlayer()==tp
end
function c98731001.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetFlagEffect(tp,98731001)==0 and Duel.SelectYesNo(tp,aux.Stringid(98731001,0)) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        c:RegisterFlagEffect(98731001,RESET_EVENT+RESETS_STANDARD,0,1)
    end
end
function c98731001.chop(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsCode(98731001) then return end
    local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,c98731001.repop)
end
function c98731001.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsType(TYPE_SPELL+TYPE_TRAP) then
        c:CancelToGrave()
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,98731001)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        local sg=c:GetOverlayGroup()
        if sg:GetCount()>0 then Duel.SendtoGrave(sg,REASON_RULE) end
        local tc=g:GetFirst()
        Duel.Overlay(tc,c)
        Duel.BreakEffect()
        tc:CopyEffect(c:GetCode(),RESET_EVENT+RESETS_STANDARD,1)
    end
end
function c98731001.atkval(e,c)
    local g=e:GetHandler():GetOverlayGroup()
    if e:GetHandler():GetEquipCount()>0 then g:Merge(e:GetHandler():GetEquipGroup()) end
    return g:GetSum(Card.GetAttack)
end
function c98731001.defval(e,c)
    local g=e:GetHandler():GetOverlayGroup()
    if e:GetHandler():GetEquipCount()>0 then g:Merge(e:GetHandler():GetEquipGroup()) end
    return g:GetSum(Card.GetDefense)
end
function c98731001.attrval(e,c)
    local g=e:GetHandler():GetOverlayGroup()
    if e:GetHandler():GetEquipCount()>0 then g:Merge(e:GetHandler():GetEquipGroup()) end
    return g:GetSum(Card.GetAttribute)
end
function c98731001.mulval(e,c)
    local g=e:GetHandler():GetOverlayGroup()
    if e:GetHandler():GetEquipCount()>0 then g:Merge(e:GetHandler():GetEquipGroup()) end
    return g:GetCount()
end
function c98731001.tgfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_PENDULUM) and c:GetLevel()==7
end
function c98731001.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c98731001.tgfilter,tp,LOCATION_REMOVED,0,4,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=4 end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_REMOVED)
end
function c98731001.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,c98731001.tgfilter,tp,LOCATION_REMOVED,0,4,4,nil)
    local c=e:GetHandler()
    for tc in aux.Next(g) do
        if Duel.Equip(tp,tc,c,false) then 
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(c98731001.eqlimit)
            tc:RegisterEffect(e1)
        end
    end
end
function c98731001.eqlimit(e,c)
    return e:GetOwner()==c
end