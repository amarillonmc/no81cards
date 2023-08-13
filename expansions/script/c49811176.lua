--神星クリフォート セフィラアポク
function c49811176.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811176,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,49811176)
    e1:SetCondition(c49811176.hspcon)
    e1:SetValue(c49811176.hspval)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811176,1))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,49811177)
    e2:SetCondition(c49811176.drcon)
    e2:SetTarget(c49811176.drtg)
    e2:SetOperation(c49811176.drop)
    c:RegisterEffect(e2)
    --negate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811176,2))
    e3:SetCategory(CATEGORY_DISABLE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e3:SetCountLimit(1,49811178)
    e3:SetCost(c49811176.ngcost)
    e3:SetOperation(c49811176.ngop)
    c:RegisterEffect(e3)
end
function c49811176.cfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c49811176.getzone(tp)
    local zone=0
    local g=Duel.GetMatchingGroup(c49811176.cfilter,tp,LOCATION_MZONE,0,nil)
    for tc in aux.Next(g) do
        local seq=tc:GetSequence()
        if seq==5 or seq==6 then
            zone=zone|(1<<aux.MZoneSequence(seq))
        else
            if seq>0 then zone=zone|(1<<(seq-1)) end
            if seq<4 then zone=zone|(1<<(seq+1)) end
        end
    end
    return zone
end
function c49811176.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local zone=c49811176.getzone(tp)
    return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c49811176.hspval(e,c)
    local tp=c:GetControler()
    return 0,c49811176.getzone(tp)
end
function c49811176.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c49811176.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c49811176.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c49811176.costfilter(c,tp)
    return c:IsType(TYPE_PENDULUM) and c:IsControler(tp) and (c:IsSetCard(0xaa) or c:IsSetCard(0xc4))
end
function c49811176.ngcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811176.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c49811176.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c49811176.ngop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetTarget(c49811176.distg)
    e1:SetLabel(TYPE_LINK)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c49811176.distg(e,c)
    return c:IsType(e:GetLabel())
end