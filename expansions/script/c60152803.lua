--素晴的飞檐走壁的盗贼
function c60152803.initial_effect(c)
	--fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c60152803.ffilter,2,true)
    aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c60152803.e1splimit)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c60152803.e2op)
    c:RegisterEffect(e2)
    --remove
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60152803,0))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e3:SetCountLimit(1)
    e3:SetCondition(c60152803.e3con)
    e3:SetTarget(c60152803.e3tg)
    e3:SetOperation(c60152803.e3op)
    c:RegisterEffect(e3)
end
function c60152803.ffilter(c,fc,sub,mg,sg)
    return c:IsFaceup() and (not sg or sg:FilterCount(aux.TRUE,c)==0
        or (sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()) and not sg:IsExists(Card.IsType,1,nil,TYPE_LINK) and not sg:IsExists(Card.IsType,1,nil,TYPE_XYZ)
            and sg:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_WIND) and sg:IsExists(Card.IsLevel,1,c,c:GetLevel())))
end
function c60152803.e1splimit(e,se,sp,st)
    return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60152803.e2op(e,tp,eg,ep,ev,re,r,rp)
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
function c60152803.e3con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c60152803.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove()
        and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    g:AddCard(e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c60152803.e3op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
    if g:GetCount()==0 or not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
    local rs=g:RandomSelect(1-tp,1)
    if Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
	if Duel.SendtoHand(rs,tp,REASON_EFFECT)==0 then return end
    local fid=c:GetFieldID()
    local oc2=rs:GetFirst()
    local og=Group.FromCards(c,oc2)
    local oc=og:GetFirst()
	while oc do
        if oc:IsControler(tp) then
            oc:RegisterFlagEffect(60152803,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1,fid)
        else
            oc:RegisterFlagEffect(60152803,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,0,1,fid)
        end
        oc=og:GetNext()
    end
    og:KeepAlive()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetLabel(fid)
    e1:SetLabelObject(og)
    e1:SetCondition(c60152803.e3opcon)
    e1:SetOperation(c60152803.e3opop)
    e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
    Duel.RegisterEffect(e1,tp)
end
function c60152803.e3opconfilter(c,fid)
    return c:GetFlagEffectLabel(60152803)==fid
end
function c60152803.e3opcon(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetTurnPlayer()~=tp then return false end
    local g=e:GetLabelObject()
    if not g:IsExists(c60152803.e3opconfilter,1,nil,e:GetLabel()) then
        g:DeleteGroup()
        e:Reset()
        return false
    else return true end
end
function c60152803.e3opop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    local sg=g:Filter(c60152803.e3opconfilter,nil,e:GetLabel())
    g:DeleteGroup()
    local tc=sg:GetFirst()
    while tc do
        if tc==e:GetHandler() then
            Duel.ReturnToField(tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(2000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetValue(2000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			tc:RegisterEffect(e2)
        else
            Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
        end
        tc=sg:GetNext()
    end
end