--源于阴影 诘问
local s,id,o=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SSET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,id)
    e2:SetCost(s.thcost)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_CUSTOM+65820000)
    e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
    e3:SetCountLimit(1,id+2)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(s.spcon)
    e3:SetTarget(s.sptg2)
    e3:SetOperation(s.spop2)
    c:RegisterEffect(e3)
end
s.effect_lixiaoguo=true
function s.consume_use_counter(e,tp)
    local c=e:GetHandler()
    for i=0,10 do
        Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
    end
    local count = math.max(Duel.GetFlagEffect(tp,65820099)-1,0)
    Duel.ResetFlagEffect(tp,65820099)
    for i=1,count do
        Duel.RegisterFlagEffect(tp,65820099,0,0,1)
    end
    local te=Effect.CreateEffect(c)
    te:SetDescription(aux.Stringid(65820000,count))
    te:SetType(EFFECT_TYPE_FIELD)
    te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
    te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    te:SetTargetRange(1,0)
    Duel.RegisterEffect(te,tp)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local lp = Duel.GetLP(tp)
    if lp>=2500 then
        Duel.PayLPCost(tp,2500,REASON_COST)
    else
        Duel.PayLPCost(tp,lp,REASON_COST)
    end
    if Duel.GetLP(tp)<=0 then
        Duel.SetLP(tp,4000)
        Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_EFFECT,tp,tp,4000)
    end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c = e:GetHandler()
    local has_use = (Duel.GetFlagEffect(tp,65820099) > 0)
    local is_flipped = (c:GetFlagEffect(65820010) > 0)
    if not ((has_use and not is_flipped) or (not has_use and is_flipped)) then
        if chk==0 then return false end
    end
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    end
    if has_use then s.consume_use_counter(e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
        and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
        and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg = Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
        Duel.HintSelection(sg)
        Duel.SendtoGrave(sg,REASON_EFFECT)
    end
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c = e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c = e:GetHandler()
    local has_use = (Duel.GetFlagEffect(tp,65820099) > 0)
    local is_flipped = (c:GetFlagEffect(65820010) > 0)
    if not ((not has_use and not is_flipped) or (has_use and is_flipped)) then
        if chk==0 then return false end
    end
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
    end
    if has_use then s.consume_use_counter(e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        else
            Duel.SSet(tp,tc)
        end
    end
end
function s.thfilter(c)
    if not (c:IsSetCard(0x3a32) and c:IsType(TYPE_SPELL+TYPE_TRAP)) then return false end
    return c:IsAbleToHand() or c:IsSSetable()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(function(c) return c:IsSetCard(0x3a32) end,1,nil,tp) and ep==tp
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end