--RDR-テンペスト
function c98730417.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --monster effect
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(98730417,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,98730417)
    e2:SetCost(c98730417.shcost)
    e2:SetTarget(c98730417.shtg)
    e2:SetOperation(c98730417.shop)
    c:RegisterEffect(e2)
    --tograve
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,98730417)
    e3:SetCost(c98730417.thcost)
    e3:SetTarget(c98730417.thtg)
    e3:SetOperation(c98730417.thop)
    c:RegisterEffect(e3)
    --remove
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCountLimit(1,98730417)
    e4:SetCost(c98730417.rmcost)
    e4:SetTarget(c98730417.rmtg)
    e4:SetOperation(c98730417.rmop)
    c:RegisterEffect(e4)
    --destroy replace
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EFFECT_SEND_REPLACE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c98730417.retcon)
    e5:SetTarget(c98730417.reptg)
    e5:SetOperation(c98730417.repop)
    c:RegisterEffect(e5)
    --pendulum effect
    --disable
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_IGNORE_IMMUNE)
    e7:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e7:SetRange(LOCATION_PZONE)
    e7:SetCode(EFFECT_DISABLE)
    e7:SetCondition(c98730417.discon)
    e7:SetTarget(c98730417.disable)
    c:RegisterEffect(e7)
    --ritural
    local e8=Effect.CreateEffect(c)
    e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_PZONE)
    e8:SetCountLimit(1,10405)
    e8:SetTarget(c98730417.sptg)
    e8:SetOperation(c98730417.spop)
    c:RegisterEffect(e8)
end

--to hand
function c98730417.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c98730417.shfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_PENDULUM)
    and (c:IsLocation(LOCATION_DECK) or c:IsFaceup()) and not c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c98730417.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730417.shfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c98730417.shop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c98730417.shfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

--to grave
function c98730417.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c98730417.thfilter(c)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WIND)) and c:IsType(TYPE_PENDULUM)
     and not c:IsType(TYPE_RITUAL) and c:IsAbleToGrave()
end
function c98730417.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730417.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98730417.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c98730417.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end

--to remove
function c98730417.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c98730417.rmfilter(c)
    return  c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_RITUAL) and c:IsAbleToRemove()
end
function c98730417.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730417.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c98730417.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c98730417.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end

--destroy replace
function c98730417.retcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c98730417.retfilter(c,e,tp,mg)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_PENDULUM)
        and not c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c98730417.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c98730417.retfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
        and c:IsAbleToDeck()
        and c:IsReason(REASON_BATTLE+REASON_EFFECT) and (not re or re:GetOwner()~=c) end
    return Duel.SelectYesNo(tp,aux.Stringid(98730417,4))
end
function c98730417.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
    Duel.ShuffleDeck(tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c98730417.retfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

--distable
function c98730417.disfilter(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_PENDULUM)
end
function c98730417.discon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c98730417.disfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
        and Duel.GetCurrentPhase()==PHASE_MAIN1 and e:GetHandlerPlayer()==Duel.GetTurnPlayer()
end
function c98730417.disable(e,c)
    return c:IsFaceup() and not (c:IsAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_DRAGON))
end


--ritual
function c98730417.rexfilter(c)
    return c:GetFlagEffect(98730417)==0
end
function c98730417.spfilter(c,e,tp,m,ft)
    if not ((c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WIND)) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL))
        or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
    local mx=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    local mg=mx:Filter(c98730417.rexfilter,nil)
    if ft>0 then
        return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
    else
        return mg:IsExists(c98730417.mfilterf,1,nil,tp,mg,c)
    end
end
function c98730417.mfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),0,99,rc)
    else return false end
end
function c98730417.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_PENDULUM)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return ft>-1 and Duel.IsExistingMatchingCard(c98730417.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
    if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_PZONE,0,1,e:GetHandler(),ATTRIBUTE_WIND) then
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
    end
end
c98730417.sploc_table={LOCATION_HAND,LOCATION_DECK,LOCATION_GRAVE,LOCATION_REMOVED}
function c98730417.spop(e,tp,eg,ep,ev,re,r,rp)
    for i=1,4 do
        local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_PENDULUM)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft>-1 and Duel.IsExistingMatchingCard(c98730417.spfilter,tp,c98730417.sploc_table[i],0,1,nil,e,tp,mg,ft)
            and (i==1 or (Duel.IsExistingMatchingCard(c98730417.disfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
            and Duel.SelectYesNo(tp,aux.Stringid(98730417,i-1)))) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,c98730417.spfilter,tp,c98730417.sploc_table[i],0,1,1,nil,e,tp,mg,ft)
            local tc=g:GetFirst()
            if tc then
                mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
                mg=mg:Filter(c98730417.rexfilter,nil)
                local mat=nil
                if ft>0 then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                    mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
                else
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                    mat=mg:FilterSelect(tp,c98730417.mfilterf,1,1,nil,tp,mg,tc)
                    Duel.SetSelectedCard(mat)
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                    local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
                    mat:Merge(mat2)
                end
                tc:SetMaterial(mat)
                Duel.ReleaseRitualMaterial(mat)
                Duel.BreakEffect()
                Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
                tc:CompleteProcedure()
                tc:RegisterFlagEffect(98730417,RESET_CHAIN,0,1)
            end
        end
    end
    Duel.SpecialSummonComplete()
end
