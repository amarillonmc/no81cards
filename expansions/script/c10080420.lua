--進化の到達点
function c10080420.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c10080420.ctop2)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(c10080420.drcon)
    e2:SetOperation(c10080420.drop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_FZONE)
    e3:SetOperation(aux.chainreg)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetCode(EVENT_CHAIN_SOLVED)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCondition(c10080420.ctcon)
    e4:SetOperation(c10080420.ctop)
    c:RegisterEffect(e4)
    --leave
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetCode(EVENT_LEAVE_FIELD_P)
    e5:SetOperation(c10080420.checkop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_LEAVE_FIELD)
    e6:SetLabelObject(e5)
    e6:SetOperation(c10080420.leave)
    c:RegisterEffect(e6)
end

function c10080420.evolfilter(c)
    return c:IsCode(10080420) --進化の到達点(「ジュラシックワールド」として扱うため実質「進化」カテゴリには含まれない)
      or c:IsCode(5338223) --強制進化
      or c:IsCode(88760522) --多様進化
      or c:IsCode(25573054) --進化する翼
      or c:IsCode(34026662) --進化の奇跡
      or c:IsCode(77840540) --超進化の繭
      or c:IsCode(8632967) --進化の宿命
      or c:IsCode(14154221) --進化の代償
      or c:IsCode(62991886) --進化する人類
      or c:IsCode(24362891) --突然進化
      or c:IsCode(64815084) --進化の分岐点
      or c:IsCode(74100225) --進化の特異点
      or c:IsCode(93504463) --進化への懸け橋
      -- 以下、「進化」モンスター（実質「進化」カテゴリには含まれない）
      or c:IsCode(44088292) --進化合獣ダイオーキシン
      or c:IsCode(80476891) --進化合獣ヒュードラゴン
      or c:IsCode(40240595) --進化の繭
    or c:IsSetCard(0x10e)
    or c:IsCode(7373632)
    or c:IsCode(34572613)
end


function c10080420.ctop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.IsExistingMatchingCard(c10080420.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and c:GetFlagEffect(10080421)<=1
    and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10080420,3)) then
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10080420,2))
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c10080420.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        c:RegisterFlagEffect(10080421,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
    end
end

function c10080420.cfilter(c,tp)
    return c:IsSetCard(0x504e) and c:GetPreviousControler()==tp and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c10080420.drcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c10080420.cfilter,1,nil,tp)
end
function c10080420.thfilter(c)
    return c10080420.evolfilter(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c10080420.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.IsExistingMatchingCard(c10080420.thfilter,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(10080420)<=1
    and Duel.SelectYesNo(tp,aux.Stringid(10080420,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c10080420.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        c:RegisterFlagEffect(10080420,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
    end
end

function c10080420.spfilter(c,e,tp)
    return (c:IsSetCard(0x304e) or c:IsSetCard(0x504e) or c:IsSetCard(0x604e)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10080420.ctcon(e,tp,eg,ep,ev,re,r,rp)
    if not re then return false end
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
    and c10080420.evolfilter(re:GetHandler())
end
function c10080420.ctop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.IsExistingMatchingCard(c10080420.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and c:GetFlagEffect(10080421)<=1
    and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10080420,3)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c10080420.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        c:RegisterFlagEffect(10080421,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
    end
end

function c10080420.rfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c10080420.checkop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsDisabled() then
        e:SetLabel(1)
    else e:SetLabel(0) end
end
function c10080420.leave(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetLabelObject():GetLabel()==0 and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP) then
        local g=Duel.GetMatchingGroup(c10080420.rfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
