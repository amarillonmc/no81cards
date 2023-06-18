--机械装甲捌
local m=91000408
local cm=c91000408
function c91000408.initial_effect(c)
     c:EnableReviveLimit()  
    aux.AddFusionProcFun2(c,(function(c) return c:IsLevel(10) end),(function(c) return c:IsType(TYPE_EQUIP) end),false) 
    aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD,0,Duel.SendtoGrave,REASON_COST)  
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_SET_CONTROL)
    e1:SetValue(cm.cval)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(cm.tg2)
    e2:SetOperation(cm.op2)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(cm.atkval)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1,m*2)
    e5:SetCondition(cm.negcon)
    e5:SetTarget(cm.negtg)
    e5:SetOperation(cm.negop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e6:SetCode(EVENT_LEAVE_FIELD)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetCountLimit(1,m*3)
    e6:SetOperation(cm.op6)
    c:RegisterEffect(e6)
    Duel.AddCustomActivityCounter(91000408,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
    return  c:IsLevel(10)
end
function cm.cval(e,c)
    return e:GetHandlerPlayer()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsFaceup()  and tc:IsRelateToEffect(e) then
        if not Duel.Equip(tp,c,tc) then return end
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_EQUIP_LIMIT)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetValue(1)
        c:RegisterEffect(e3)
    end
end
function cm.atkval(e,c)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(cm.fit,tp,LOCATION_ONFIELD,0,nil)*500
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
    return  e:GetHandler():GetEquipTarget()
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.thfilter2(c)
    return c:IsSetCard(0x9d2)and not c:IsForbidden()
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if  Duel.Draw(p,d,REASON_EFFECT)>0 then
    if Duel.SelectYesNo(tp,aux.Stringid(m,0)) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0  then   
        local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
        local sc=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
        Duel.Equip(tp,sc,tc)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(cm.eqlimit)
        e1:SetLabelObject(tc)
        sc:RegisterEffect(e1)
        end
       
        end
end
function cm.eqlimit(e,c)
    return e:GetLabelObject()==c
end

function cm.op6(e,tp,eg,ep,ev,re,r,rp)
    local e11=Effect.CreateEffect(e:GetHandler())
        e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e11:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
        e11:SetCountLimit(1)
        e11:SetCondition(cm.spcon)
        e11:SetOperation(cm.spop)
        if Duel.GetCurrentPhase()<=PHASE_BATTLE_START then
        e11:SetReset(RESET_PHASE+PHASE_BATTLE)
    else
        e11:SetReset(RESET_PHASE+PHASE_BATTLE)
    end
         Duel.RegisterEffect(e11,tp)
end
function cm.fit(c)
    return  c:IsSetCard(0x9d2)and not c:IsForbidden()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return   Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.fit),tp,LOCATION_GRAVE,0,1,nil,e) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
   local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
        local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.fit),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
        Duel.Equip(tp,sc,tc)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(cm.eqlimit)
        e1:SetLabelObject(tc)
        sc:RegisterEffect(e1)
end
function cm.eqlimit(e,c)
    return e:GetLabelObject()==c
end