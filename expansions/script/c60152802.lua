--素晴的红魔族第一发育
function c60152802.initial_effect(c)
	--fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c60152802.ffilter,2,true)
    aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c60152802.e1splimit)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c60152802.e2op)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60152802,0))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e3:SetTarget(c60152802.e3tg)
    e3:SetOperation(c60152802.e3op)
    c:RegisterEffect(e3)
end
function c60152802.ffilter(c,fc,sub,mg,sg)
    return c:IsFaceup() and (not sg or sg:FilterCount(aux.TRUE,c)==0
        or (sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()) and not sg:IsExists(Card.IsType,1,nil,TYPE_LINK) and not sg:IsExists(Card.IsType,1,nil,TYPE_XYZ)
            and sg:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_DARK) and sg:IsExists(Card.IsLevel,1,c,c:GetLevel())))
end
function c60152802.e1splimit(e,se,sp,st)
    return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60152802.e2op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    local sa=0
    local sd=0
    local tc=g:GetFirst()
    while tc do
        local a=tc:GetAttack()
        local d=tc:GetDefense()
        if a<0 then a=0 end
        sa=sa+a
        if d<0 then d=0 end
        sd=sd+d
        tc=g:GetNext()
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(sa)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    e2:SetValue(sd)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
    c:RegisterEffect(e2)
end
function c60152802.e3tgfilter(c)
	local ct=bit.band(c:GetType(),0x7)
    return c:IsFaceup() and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c60152802.e3costfilter2,tp,LOCATION_DECK,0,1,c,ct)
end
function c60152802.e3costfilter2(c,ct)
    return c:IsType(ct) and c:IsAbleToRemoveAsCost()
end
function c60152802.e3tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60152802.e3tgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c60152802.e3tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local tc=g:GetFirst()
	local ct=bit.band(tc:GetType(),0x7)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c60152802.e3costfilter2,tp,LOCATION_DECK,0,1,1,nil,ct)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60152802.e3op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
    end
end