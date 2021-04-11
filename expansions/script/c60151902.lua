--魔法少女 巴麻美
local m=60151902
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,60151902)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),5,2,c60151902.ovfilter,aux.Stringid(60151902,0),2,c60151902.xyzop)
    c:EnableReviveLimit()
    --destroy replace
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c60151902.e1tg)
    c:RegisterEffect(e1)
    --pendulum set
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151902,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c60151902.e2tg)
    e2:SetOperation(c60151902.e2op)
    c:RegisterEffect(e2)
    --SEARCH
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151902,3))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c60151902.e3tg)
    e3:SetOperation(c60151902.e3op)
    c:RegisterEffect(e3)
    if not c60151902.global_check then
        c60151902.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge1:SetOperation(c60151902.checkop)
        Duel.RegisterEffect(ge1,0)
    end
end
function c60151902.ovfilter(c)
    return c:IsFaceup() and c:IsCode(60151901)
end
function c60151902.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,60151902)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c60151902.sumlimit)
    Duel.RegisterEffect(e1,tp)
end
function c60151902.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsCode(60151902)
end
function c60151902.checkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    local p1=false
    local p2=false
    while tc do
        if not tc:IsCode(60151902) and tc:GetSummonLocation()==LOCATION_EXTRA then
            if tc:GetSummonPlayer()==0 then p1=true else p2=true end
        end
        tc=eg:GetNext()
    end
    if p1 then Duel.RegisterFlagEffect(0,60151902,RESET_PHASE+PHASE_END,0,1) end
    if p2 then Duel.RegisterFlagEffect(1,60151902,RESET_PHASE+PHASE_END,0,1) end
end
function c60151902.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tp=e:GetHandlerPlayer()
    local c=e:GetHandler()
    local dam=Duel.GetBattleDamage(tp)
    if chk==0 then return c:IsFaceup() and c:IsReason(REASON_BATTLE) and c:IsAttackPos() 
        and not c:IsReason(REASON_REPLACE) end
    if dam>=0 then
        Duel.Hint(HINT_CARD,0,60151902)
        Duel.SetLP(tp,Duel.GetLP(tp)-dam)
        return true
    else return false end
end
function c60151902.rpfilter(c)
    return c:IsSetCard(0xab26) and not c:IsForbidden()
end
function c60151902.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) 
        and Duel.IsExistingMatchingCard(c60151902.rpfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151902.e2op(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151902,2))
    local g=Duel.SelectMatchingCard(tp,c60151902.rpfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
    local tc=g:GetFirst()
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    Duel.SetLP(tp,Duel.GetLP(tp)-500)
end
function c60151902.thfilter(c)
    return (c:IsSetCard(0x6b26) or c:IsSetCard(0x9b26)) and c:IsAbleToHand()
end
function c60151902.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151902.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151902.e3op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60151902.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.SetLP(tp,Duel.GetLP(tp)-1000)
    end
end
