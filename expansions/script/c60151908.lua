--魔缎 律法之缚
function c60151908.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCountLimit(1,60151908+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60151908.e1con)
    e1:SetCost(c60151908.e1cost)
    e1:SetTarget(c60151908.e1tg)
    e1:SetOperation(c60151908.e1op)
    c:RegisterEffect(e1)
	--special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c60151908.e2con)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c60151908.e2tg)
    e2:SetOperation(c60151908.e2op)
    c:RegisterEffect(e2)
end
function c60151908.e1confilter(c)
    return c:IsFaceup() and c:IsCode(60151902)
end
function c60151908.e1con(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(c60151908.e1confilter,tp,LOCATION_MZONE,0,1,nil) then return false end
    return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c60151908.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_REMAIN_FIELD)
    e1:SetProperty(EFFECT_FLAG_OATH)
    e1:SetReset(RESET_CHAIN)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_DISABLED)
    e2:SetOperation(c60151908.tgop)
    e2:SetLabel(cid)
    e2:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e2,tp)
end
function c60151908.tgop(e,tp,eg,ep,ev,re,r,rp)
    local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
    if cid~=e:GetLabel() then return end
    if e:GetOwner():IsRelateToChain(ev) then
        e:GetOwner():CancelToGrave(false)
    end
end
function c60151908.e1tgfilter(c)
    return c:IsFaceup()
end
function c60151908.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE)
        and Duel.IsExistingTarget(c60151908.e1tgfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c60151908.e1tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c60151908.e1op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsLocation(LOCATION_SZONE) then return end
    if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,c,tc)
        --Atkup
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_EQUIP)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
        --
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_EQUIP)
        e2:SetCode(EFFECT_DISABLE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e2)
        --
        local e5=Effect.CreateEffect(c)
        e5:SetType(EFFECT_TYPE_EQUIP)
        e5:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
        e5:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e5)
        --Equip limit
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_EQUIP_LIMIT)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetValue(1)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e3)
		local e6=Effect.CreateEffect(c)
		e6:SetCategory(CATEGORY_POSITION)
		e6:SetType(EFFECT_TYPE_IGNITION)
		e6:SetRange(LOCATION_SZONE)
		e6:SetTarget(c60151908.e1ope6tg)
		e6:SetOperation(c60151908.e1ope6op)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCode(EFFECT_SELF_TOGRAVE)
		e7:SetCondition(c60151908.e1ope7con)
		c:RegisterEffect(e7)
    else
        c:CancelToGrave(false)
    end
end
function c60151908.e1ope6tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsCanTurnSet() end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c60151908.e1ope6op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.ChangePosition(c,POS_FACEDOWN)
    end
end
function c60151908.e1ope7con(e)
    return not Duel.IsExistingMatchingCard(c60151908.e1confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60151908.e2con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c60151908.e2tgfilter(c,e,tp)
    return c:IsCode(60151901) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151908.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60151908.e2tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60151908.e2op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60151908.e2tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end