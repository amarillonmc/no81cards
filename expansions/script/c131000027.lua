--MORE MORE JUMP! 镜音铃
local m=131000027
local cm=_G["c"..m]
function cm.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c131000027.ffilter,2,true)
    --spsummon
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetCondition(c131000027.hspcon)
    e0:SetOperation(c131000027.hspop)
    c:RegisterEffect(e0)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(131000027,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c131000027.thtg1)
    e1:SetOperation(c131000027.thop1)
    c:RegisterEffect(e1)
    --pendulum
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(131000027,1))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_DECK)
    e2:SetCondition(c131000027.pencon)
    e2:SetTarget(c131000027.pentg)
    e2:SetOperation(c131000027.penop)
    c:RegisterEffect(e2)
    --splimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_PZONE)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c131000027.splimit)
    c:RegisterEffect(e3) 

end
function c131000027.splimit(e,c)
    return not c:IsSetCard(0xacdc)
end
function c131000027.ffilter(c)
    return (c:IsRace(RACE_CYBERSE) or c:IsRace(RACE_FAIRY)) and not c:IsType(TYPE_FUSION)
end
function c131000027.hspfilter(c,tp,sc)
    return (c:IsRace(RACE_CYBERSE) or c:IsRace(RACE_FAIRY)) and not c:IsType(TYPE_FUSION) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c131000027.hspcon(e,c)
    if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),c131000027.hspfilter,2,nil,c:GetControler(),c)
and Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil,0xacdc)
end
function c131000027.hspop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,c131000027.hspfilter,2,2,nil,tp,c)
    c:SetMaterial(g)
    Duel.Release(g,REASON_COST)
end
function c131000027.thfilter1(c)
    return c:IsCode(131000026) and c:IsAbleToHand()
end
function c131000027.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c131000027.thfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c131000027.thop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c131000027.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function c131000027.pencon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_EXTRA) and e:GetHandler():IsFaceup() and e:GetHandler():IsControler(tp)
end
function c131000027.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c131000027.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end
