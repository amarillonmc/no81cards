--皇刑鬼-吸血鬼·布拉德
local m=89387020
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_ZOMBIE),3,4)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.destg)
    e1:SetOperation(cm.desop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,m+100000000)
    e2:SetTarget(cm.tgtg)
    e2:SetOperation(cm.tgop)
    c:RegisterEffect(e2)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
    local op=Duel.AnnounceType(tp)
    e:SetLabel(op)
    local ctype
    if op==0 then ctype=TYPE_MONSTER end
    if op==1 then ctype=TYPE_SPELL end
    if op==2 then ctype=TYPE_TRAP end
    Duel.SetChainLimit(cm.chlimit(ctype))
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
end
function cm.chlimit(ctype)
    return function(e,ep,tp)
        return tp==ep or e:GetHandler():GetOriginalType()&ctype==0
    end
end
function cm.desfilter(c,ty)
    return c:IsType(ty) and c:IsAbleToGrave()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local g
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
    if e:GetLabel()==0 then g=Duel.SelectMatchingCard(1-tp,cm.desfilter,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
    elseif e:GetLabel()==1 then g=Duel.SelectMatchingCard(1-tp,cm.desfilter,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL)
    else g=Duel.SelectMatchingCard(1-tp,cm.desfilter,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_TRAP) end
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    else
        Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_DECK))
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(0,1)
    if e:GetLabel()==0 then
        e1:SetDescription(aux.Stringid(m,2))
        e1:SetValue(cm.aclimit1)
    elseif e:GetLabel()==1 then
        e1:SetDescription(aux.Stringid(m,3))
        e1:SetValue(cm.aclimit2)
    else
        e1:SetDescription(aux.Stringid(m,4))
        e1:SetValue(cm.aclimit3)
    end
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.aclimit1(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER)
end
function cm.aclimit2(e,re,tp)
    return re:IsActiveType(TYPE_SPELL)
end
function cm.aclimit3(e,re,tp)
    return re:IsActiveType(TYPE_TRAP)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.setfilter(c,tp)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
        local zone=e:GetHandler():GetLinkedZone(tp)
        local b1=Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_GRAVE,1,nil,e,0,tp,false,false,POS_FACEUP,tp,zone)
        local b2=Duel.IsExistingMatchingCard(cm.setfilter,tp,0,LOCATION_GRAVE,1,nil,tp)
        local op=2
        if b1 and b2 then
            op=Duel.SelectOption(tp,aux.Stringid(m,5),aux.Stringid(m,6))
        elseif b1 then
            op=Duel.SelectOption(tp,aux.Stringid(m,5))
        elseif b2 then
            op=Duel.SelectOption(tp,aux.Stringid(m,6))+1
        end
        if op==0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,0,LOCATION_GRAVE,1,1,nil,e,0,tp,false,false,POS_FACEUP,tp,zone)
            if not g or g:GetCount()==0 then return end
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
        end
        if op==1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
            local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp)
            if not g or g:GetCount()==0 then return end
            Duel.SSet(tp,g)
        end
    end
end
