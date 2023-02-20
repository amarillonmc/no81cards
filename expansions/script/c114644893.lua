--リチュアに伝わりし神判の予言
function c114644893.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCountLimit(1,114644893+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c114644893.target)
    e1:SetOperation(c114644893.activate)
    c:RegisterEffect(e1)
end
function c114644893.filter(c)
    return c:IsSetCard(0x3a) and c:GetCode()~=114644893 and c:IsAbleToHand()
end
function c114644893.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c114644893.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c114644893.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c114644893.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(c114644893.regcon)
    e1:SetOperation(c114644893.regop1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_NEGATED)
    e2:SetCondition(c114644893.regcon)
    e2:SetOperation(c114644893.regop2)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetCountLimit(1)
    e3:SetCondition(c114644893.effcon)
    e3:SetOperation(c114644893.effop)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
    e1:SetLabelObject(e3)
    e2:SetLabelObject(e3)
end
function c114644893.regcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and re:IsActiveType(TYPE_RITUAL)
end
function c114644893.regop1(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabelObject():GetLabel()
    e:GetLabelObject():SetLabel(ct+1)
end
function c114644893.regop2(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabelObject():GetLabel()
    if ct==0 then ct=1 end
    e:GetLabelObject():SetLabel(ct-1)
end
function c114644893.effcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabel()>0
end

function c114644893.rtfilter(c,e,tp,m,ft)
    if not c:IsAttribute(ATTRIBUTE_WATER) or bit.band(c:GetType(),0x81)~=0x81
        or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local m2=Duel.GetMatchingGroup(c114644893.mfilter,tp,LOCATION_DECK,0,c,c:GetLevel())
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    local mg2=m2:Filter(Card.IsCanBeRitualMaterial,c,c)
    if c.mat_filter then
        mg=mg:Filter(c.mat_filter,nil)
        mg2=mg2:Filter(c.mat_filter,nil)
    end
    if ft>0 then
        return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c) or mg2:GetCount()>0
    else
        return ft>-1 and mg:IsExists(c114644893.mfilterf,1,nil,tp,mg,c)
    end
end
function c114644893.mfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
    else return false end
end
function c114644893.mfilter(c,lv)
    return c:IsSetCard(0x3a) and c:IsType(TYPE_MONSTER) and (c:GetLevel()==lv or c:IsCode(29888389,47106439,38356857)) and c:IsAbleToGrave()
end
function c114644893.effop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,114644893)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c114644893.filter,tp,LOCATION_DECK,0,1,e:GetLabel(),nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        --ritual
        local mg=Duel.GetRitualMaterial(tp)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft>-1 and Duel.IsExistingMatchingCard(c114644893.rtfilter,tp,LOCATION_DECK,0,1,nil,e,tp,mg,ft) and Duel.SelectYesNo(tp,aux.Stringid(114644893,1)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local tg=Duel.SelectMatchingCard(tp,c114644893.rtfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg,ft)
            local tc=tg:GetFirst()
            local mat=nil
            local tg2=Duel.GetMatchingGroup(c114644893.mfilter,tp,LOCATION_DECK,0,tc,tc:GetLevel())
            local mg2=tg2:Filter(Card.IsCanBeRitualMaterial,tc,tc)
            if tc then
                mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
                if tc.mat_filter then
                    mg=mg:Filter(tc.mat_filter,nil)
                    mg2=mg2:Filter(tc.mat_filter,nil)
                end
                if ft>0 and mg2:GetCount()>0 
                    and (not mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),1,99,tc) or Duel.SelectYesNo(tp,aux.Stringid(114644893,2))) then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
                    local mat=mg2:Select(tp,1,1,tc)
                    tc:SetMaterial(mat)
                    Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
                elseif ft>0 then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                    mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
                    tc:SetMaterial(mat)
                    Duel.ReleaseRitualMaterial(mat)
                else
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                    mat=mg:FilterSelect(tp,c114644893.mfilterf,1,1,nil,tp,mg,tc)
                    Duel.SetSelectedCard(mat)
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                    local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
                    mat:Merge(mat2)
                    tc:SetMaterial(mat)
                    Duel.ReleaseRitualMaterial(mat)
                end
                Duel.BreakEffect()
                Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
                tc:CompleteProcedure()
            end
        end
    end
end
