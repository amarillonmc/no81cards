--街道的Sekai
local m=131000008
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c131000008.activate)
    c:RegisterEffect(e1)  
    --remove overlay replace
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(131000008,1))
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCondition(c131000008.rcon)
    e2:SetOperation(c131000008.rop)
    c:RegisterEffect(e2)
end
function c131000008.thfilter(c)
    return c:IsSetCard(0xacda) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c131000008.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local g=Duel.GetMatchingGroup(c131000008.thfilter,tp,LOCATION_EXTRA,0,nil)
    if g:GetCount()>0   and Duel.SelectYesNo(tp,aux.Stringid(131000008,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c131000008.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
        end
    end
end
function c131000008.cfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck() 
end
function c131000008.rcon(e,tp,eg,ep,ev,re,r,rp)
    return  bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
        and re:GetHandler():GetOverlayCount()>=ev-1 and re:GetHandler():IsSetCard(0xacda)
        and Duel.IsExistingMatchingCard(c131000008.cfilter,tp,LOCATION_EXTRA,0,3,nil)
end
function c131000008.rop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c131000008.cfilter,tp,LOCATION_EXTRA,0,3,3,e:GetHandler())
    return Duel.SendtoDeck(g,nil,2,REASON_COST)
end
