--苍白的魅魔
function c60159943.initial_effect(c)
    c:EnableReviveLimit()
	--special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60159943,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,60159943)
    e1:SetTarget(c60159943.e1tg)
    e1:SetOperation(c60159943.e1op)
    c:RegisterEffect(e1)
	--
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60159943,1))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCondition(c60159943.e2con)
    e2:SetTarget(c60159943.e2tg)
    e2:SetOperation(c60159943.e2op)
    c:RegisterEffect(e2)
	--destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60159943,3))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCondition(c60159943.e3con)
    e3:SetTarget(c60159943.e3tg)
    e3:SetOperation(c60159943.e3op)
    c:RegisterEffect(e3)
end
function c60159943.dfilter(c)
    return c:IsSetCard(0xcb2f) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c60159943.filter(c,e,tp)
    return c:IsCode(60159943)
end
function c60159943.rcheck(tp,g,c)
    return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c60159943.rgcheck(g)
    return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c60159943.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp)
        local dg=Duel.GetMatchingGroup(c60159943.dfilter,tp,LOCATION_DECK,0,nil)
        aux.RCheckAdditional=c60159943.rcheck
        aux.RGCheckAdditional=c60159943.rgcheck
        local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c60159943.filter,e,tp,mg,dg,Card.GetLevel,"Equal")
        aux.RCheckAdditional=nil
        aux.RGCheckAdditional=nil
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c60159943.e1op(e,tp,eg,ep,ev,re,r,rp)
    local m=Duel.GetRitualMaterial(tp)
    local dg=Duel.GetMatchingGroup(c60159943.dfilter,tp,LOCATION_DECK,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    aux.RCheckAdditional=c60159943.rcheck
    aux.RGCheckAdditional=c60159943.rgcheck
    local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c60159943.filter,e,tp,m,dg,Card.GetLevel,"Equal")
    local tc=tg:GetFirst()
    if tc then
        local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        mg:Merge(dg)
        if tc.mat_filter then
            mg=mg:Filter(tc.mat_filter,tc,tp)
        else
            mg:RemoveCard(tc)
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
        local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
        aux.GCheckAdditional=nil
        if not mat or mat:GetCount()==0 then
            aux.RCheckAdditional=nil
            aux.RGCheckAdditional=nil
            return
        end
        tc:SetMaterial(mat)
        local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
        if dmat:GetCount()>0 then
            mat:Sub(dmat)
            Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        end
        Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
    aux.RCheckAdditional=nil
    aux.RGCheckAdditional=nil
end
function c60159943.e2con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c60159943.e2tgfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsCode(60159943)
end
function c60159943.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60159943.e2tgfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60159943.e2tgfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c60159943.e2tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60159943.e2op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc0=Duel.GetFirstTarget()
    if tc0 and c:IsRelateToEffect(e) and c:IsFaceup() and tc0:IsRelateToEffect(e) then
        local code=tc0:GetOriginalCodeRule()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetValue(code)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
        if tc0:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e) 
            and tc0:IsLocation(LOCATION_MZONE) and tc0:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(60159943,2)) then
            Duel.Overlay(tc0,Group.FromCards(e:GetHandler()))
        end
    end
end
function c60159943.e3con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
        and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c60159943.e3tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c60159943.e3op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end
