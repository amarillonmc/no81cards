--青眼の幻白龍
function c118817732.initial_effect(c)
    aux.AddXyzProcedure(c,nil,8,2)
    c:EnableReviveLimit()
    --xyz summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(118817732,0))
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c118817732.xyzcon)
    e1:SetOperation(c118817732.xyzop)
    e1:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e1)
    --cannot be target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
    e2:SetCondition(c118817732.tgcon)
    e2:SetTarget(c118817732.tgtg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(c118817732.efilter)
    c:RegisterEffect(e3)
    --tohand or spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(c118817732.spcost)
    e4:SetTarget(c118817732.sptg)
    e4:SetOperation(c118817732.spop)
    c:RegisterEffect(e4)
    --destroy
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_ATTACK_ANNOUNCE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c118817732.descon)
    e5:SetTarget(c118817732.destg)
    e5:SetOperation(c118817732.desop)
    c:RegisterEffect(e5)
end

function c118817732.mfilter(c,xyzc)
    return c:IsRace(RACE_DRAGON) and c:IsCanBeXyzMaterial(xyzc)
end
function c118817732.xyzcon(e,c,og,min,max)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and (not min or min<=2 and max>=2)
        and Duel.IsExistingMatchingCard(c118817732.mfilter,tp,LOCATION_HAND,0,2,nil,c)
        and Duel.GetFlagEffect(tp,118817732)==0
        and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c118817732.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
    local xyzg=Group.CreateGroup()
    if og and not min then
        g=og
        local tc=og:GetFirst()
        while tc do
            sg:Merge(tc:GetOverlayGroup())
            tc=og:GetNext()
        end
    else
        local mg=nil
        if og then
            mg=og:Filter(c118817732.mfilter,nil,c)
        else
            mg=Duel.GetMatchingGroup(c118817732.mfilter,tp,LOCATION_HAND,0,nil,c)
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
        local mtg=mg:Select(tp,2,2,nil)
        xyzg:Merge(mtg)
    end
    Duel.ConfirmCards(1-c:GetControler(),c)
    Duel.RegisterFlagEffect(c:GetControler(),118817732,RESET_PHASE+PHASE_END,0,1)
    Duel.Hint(HINT_OPSELECTED,1-c:GetControler(),aux.Stringid(118817732,0))
    c:SetMaterial(xyzg)
    Duel.Overlay(c,xyzg)
end

function c118817732.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()~=0
end
function c118817732.tgtg(e,c)
    return c:IsRace(RACE_DRAGON)
end
function c118817732.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
        and te:IsActiveType(TYPE_MONSTER)
end

function c118817732.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c118817732.spfilter(c,ft,e,tp)
    return c:IsSetCard(0xdd) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c118817732.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return Duel.IsExistingMatchingCard(c118817732.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,ft,e,tp)
    end
end
function c118817732.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectMatchingCard(tp,c118817732.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,ft,e,tp)
    if g:GetCount()>0 then
        local th=g:GetFirst():IsAbleToHand()
        local sp=ft>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
        local op=0
        if th and sp then op=Duel.SelectOption(tp,aux.Stringid(118817732,2),aux.Stringid(118817732,3))
        elseif th then op=0
        else op=1 end
        if op==0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        else
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end

function c118817732.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    return tc:IsType(TYPE_NORMAL)
end
function c118817732.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c118817732.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    if Duel.Destroy(g,REASON_EFFECT)~=0 then
        Duel.NegateAttack()
    end
end
