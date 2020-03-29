function c120366274.initial_effect(c)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_FUSION_MATERIAL)
    e1:SetCondition(c120366274.FShaddollCondition(ATTRIBUTE_LIGHT))
    e1:SetOperation(c120366274.FShaddollOperation(ATTRIBUTE_LIGHT))
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetValue(c120366274.splimit)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetTarget(c120366274.tgtg)
    e3:SetOperation(c120366274.tgop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_START)
    e4:SetCondition(c120366274.descon)
    e4:SetTarget(c120366274.destg)
    e4:SetOperation(c120366274.desop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e5:SetTarget(c120366274.thtg)
    e5:SetOperation(c120366274.thop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(aux.tgoval)
    c:RegisterEffect(e6)
end
function c120366274.FShaddollFilter(c,fc,attr)
    return (c120366274.FShaddollFilter1(c) or c120366274.FShaddollFilter2(c,attr)) and c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579)
end
function c120366274.FShaddollExFilter(c,fc,attr)
    return c:IsFaceup() and c120366274.FShaddollFilter(c,fc,attr)
end
function c120366274.FShaddollFilter1(c)
    return c:IsFusionSetCard(0xd2)
end
function c120366274.FShaddollFilter2(c,attr)
    return c:IsFusionAttribute(attr)
end
function c120366274.FShaddollSpFilter1(c,fc,tp,mg,exg,attr,chkf)
    return mg:IsExists(c120366274.FShaddollSpFilter2,1,c,fc,tp,c,attr,chkf)
end
function c120366274.FShaddollSpFilter2(c,fc,tp,mc,attr,chkf)
    local sg=Group.FromCards(c,mc)
    if sg:IsExists(aux.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
    if not aux.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
    if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc) then return false end
    return ((c120366274.FShaddollFilter1(c) and c120366274.FShaddollFilter2(mc,attr))
        or (c120366274.FShaddollFilter2(c,attr) and c120366274.FShaddollFilter1(mc)))
        and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
end
function c120366274.FShaddollCondition(attr)
    return  function(e,g,gc,chkf)
                if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
                local c=e:GetHandler()
                local mg=g:Filter(c120366274.FShaddollFilter,nil,c,attr)
                local tp=e:GetHandlerPlayer()
                local exg=nil
                if gc then
                    if not mg:IsContains(gc) then return false end
                    return c120366274.FShaddollSpFilter1(gc,c,tp,mg,exg,attr,chkf)
                end
                return mg:IsExists(c120366274.FShaddollSpFilter1,1,nil,c,tp,mg,exg,attr,chkf)
            end
end
function c120366274.FShaddollOperation(attr)
    return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
                local c=e:GetHandler()
                local mg=eg:Filter(c120366274.FShaddollFilter,nil,c,attr)
                local g=nil
                if gc then
                    g=Group.FromCards(gc)
                    mg:RemoveCard(gc)
                else
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
                    g=mg:FilterSelect(tp,c120366274.FShaddollSpFilter1,1,1,nil,c,tp,mg,exg,attr,chkf)
                    mg:Sub(g)
                end
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
                local sg=mg:FilterSelect(tp,c120366274.FShaddollSpFilter2,1,1,nil,c,tp,g:GetFirst(),attr,chkf)
                g:Merge(sg)
                Duel.SetFusionMaterial(g)
            end
end
function c120366274.splimit(e,se,sp,st)
    return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c120366274.tgfilter(c)
    return c:IsSetCard(0xd2) and c:IsDestructable()
end
function c120366274.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c120366274.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function c120366274.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,c120366274.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
function c120366274.descon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c120366274.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c120366274.desop(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    if bc:IsRelateToBattle() then
        Duel.Destroy(bc,REASON_EFFECT)
    end
end
function c120366274.thfilter(c)
    return c:IsSetCard(0xd2) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c120366274.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c120366274.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c120366274.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c120366274.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c120366274.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end