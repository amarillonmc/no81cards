function c114890515.initial_effect(c)
    aux.AddXyzProcedure(c,nil,4,5,c114890515.ovfilter,aux.Stringid(114890515,0),5,c114890515.xyzop)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c114890515.atkval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetValue(c114890515.defval)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(114890515,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1)
    e3:SetCost(c114890515.spcost)
    e3:SetTarget(c114890515.sptg)
    e3:SetOperation(c114890515.spop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(114890515,2))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c114890515.mttg)
    e4:SetOperation(c114890515.mtop)
    c:RegisterEffect(e4)
end
function c114890515.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xf1) and not c:IsCode(114890515)
end
function c114890515.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,114890510)==0 end
    Duel.RegisterFlagEffect(tp,114890510,RESET_PHASE+PHASE_END,0,1)
end
function c114890515.atkfilter(c)
    return c:IsSetCard(0xf1) and c:GetAttack()>=0
end
function c114890515.atkval(e,c)
    local g=e:GetHandler():GetOverlayGroup():Filter(c114890515.atkfilter,nil)
    return g:GetSum(Card.GetAttack)
end
function c114890515.deffilter(c)
    return c:IsSetCard(0xf1) and c:GetDefense()>=0
end
function c114890515.defval(e,c)
    local g=e:GetHandler():GetOverlayGroup():Filter(c114890515.deffilter,nil)
    return g:GetSum(Card.GetDefense)
end
function c114890515.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
    c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c114890515.filter(c,e,tp,tc)
    return c:IsRank(4) and e:GetHandler():IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c114890515.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c114890515.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c114890515.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c114890515.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
    if not g or g:GetCount()==0 then return end
    local sc=g:GetFirst()
    local mg=c:GetOverlayGroup()
    if mg:GetCount()~=0 then
        Duel.Overlay(sc,mg)
    end
    sc:SetMaterial(Group.FromCards(c))
    Duel.Overlay(sc,c)
    Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
    sc:CompleteProcedure()
end
function c114890515.mtfilter(c)
    return c:IsSetCard(0xf1)
end
function c114890515.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(c114890515.mtfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c114890515.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,c114890515.mtfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Overlay(c,g)
    end
end