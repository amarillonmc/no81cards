local m=4865004
local cm=_G["c"..m] 
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,cm.mfilter,1,1)
    c:EnableReviveLimit()
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(cm.thcon)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(cm.valcheck)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    --cannot be battle traget
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DAMAGE)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(cm.spcon)
    e4:SetTarget(cm.sptg)
    e4:SetOperation(cm.spop)
    c:RegisterEffect(e4)
end
function cm.mfilter(c)
    return c:IsLevelBelow(4) and c:IsLinkSetCard(0x332b)
end
function cm.valcheck(e,c)
    local g=c:GetMaterial()
    if g:IsExists(Card.IsLinkSetCard,1,nil,0x332b) then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetSequence()>4 and e:GetLabel()==1
end
function cm.thfilter(c)
    return c:IsSetCard(0x332b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0x332b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.Recover(tp,ev,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
