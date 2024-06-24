--豊穣の海 ニア
function c260013018.initial_effect(c)
    c:SetSPSummonOnce(260013018)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c260013018.matfilter,1,1)
    
    --recover
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,260013018)
    e2:SetTarget(c260013018.rectg)
    e2:SetOperation(c260013018.recop)
    c:RegisterEffect(e2)
    
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(260013018,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_XMATERIAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c260013018.spcon1)
    e3:SetCost(c260013018.spcost1)
    e3:SetTarget(c260013018.sptg1)
    e3:SetOperation(c260013018.spop1)
    c:RegisterEffect(e3)
end


--【召喚ルール】
function c260013018.matfilter(c,lc,sumtype,tp)
    return c:IsLinkRace(RACE_SPELLCASTER)
end

--【回復】
function c260013018.recfilter(c)
    return c:IsFaceup() and c:GetBaseAttack()>0
end
function c260013018.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc~=c and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c260013018.recfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c260013018.recfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c260013018.recfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetBaseAttack())
end
function c260013018.recop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetBaseAttack()>0 then
        Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT)
    end
end

--【X効果】
function c260013018.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSetCard(0x943)
end
function c260013018.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c260013018.spfilter1(c,e,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c260013018.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c260013018.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c260013018.spop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c260013018.spfilter1),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c260013018.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end

function c260013018.splimit(e,c)
    return c:IsLocation(LOCATION_GRAVE)
end