--煉獄神インフェルノイド·ティエラ
function c49811171.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c49811171.matfilter,4,4)
	--extra summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811171,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c49811171.spcon)
    e1:SetTarget(c49811171.sptg)
    e1:SetOperation(c49811171.spop)
    c:RegisterEffect(e1)
    Duel.AddCustomActivityCounter(49811171,ACTIVITY_SPSUMMON,c49811171.counterfilter)
    --unique
    c:SetUniqueOnField(1,0,49811171)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SET_BASE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c49811171.atkval)
    c:RegisterEffect(e2)
    --copy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811171,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,49811171)
    e3:SetTarget(c49811171.copytg)
    e3:SetOperation(c49811171.copyop)
    c:RegisterEffect(e3)
    --to grave
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,49811172)
    e4:SetCondition(c49811171.tgcon)
    e4:SetTarget(c49811171.tgtg)
    e4:SetOperation(c49811171.tgop)
    c:RegisterEffect(e4)
end
function c49811171.matfilter(c)
	return c:IsLinkSetCard(0xbb)
end
function c49811171.cfilter(c)
    return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c49811171.sumfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c49811171.lv_or_rk(c)
    if c:IsType(TYPE_XYZ) then return c:GetRank()
    else return c:GetLevel() end
end
function c49811171.counterfilter(c)
    return c:IsRace(RACE_FIEND)
end
function c49811171.excheck(g,tp,c)
	return Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function c49811171.fieldfilter(c)
	return c:IsFaceup() and c:IsCode(34822850) and not c:IsDisabled()
end
function c49811171.spcon(e,c,tp)
    if c==nil then return true end
    local tp=c:GetControler()
    local sum=Duel.GetMatchingGroup(c49811171.sumfilter,tp,LOCATION_MZONE,0,nil):GetSum(c49811171.lv_or_rk)
    if sum>8 then return false end
    local loc=LOCATION_GRAVE
    if Duel.IsExistingMatchingCard(c49811171.fieldfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) then loc=loc+LOCATION_MZONE end
    local g=Duel.GetMatchingGroup(c49811171.cfilter,tp,loc,0,c)
    return g:CheckSubGroup(c49811171.excheck,4,4,tp,c) and Duel.GetCustomActivityCount(49811171,tp,ACTIVITY_SPSUMMON)==0
end
function c49811171.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local loc=LOCATION_GRAVE
    if Duel.IsExistingMatchingCard(c49811171.fieldfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) then loc=loc+LOCATION_MZONE end
    local g=Duel.GetMatchingGroup(c49811171.cfilter,tp,loc,0,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local sg=g:SelectSubGroup(tp,c49811171.excheck,true,4,4,tp,c)
    if sg then
        sg:KeepAlive()
        e:SetLabelObject(sg)
        return true
    else return false end
end
function c49811171.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    g:DeleteGroup()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c49811171.sumlimit)
    Duel.RegisterEffect(e1,tp)
end
function c49811171.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsRace(RACE_FIEND)
end
function c49811171.atkval(e,c)
    return Duel.GetMatchingGroupCount(c49811171.afilter,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)*500
end
function c49811171.afilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbb)
end
function c49811171.copyfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsSetCard(0xbb)
end
function c49811171.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c49811171.copyfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c49811171.copyfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c49811171.copyfilter,tp,LOCATION_REMOVED,0,1,1,nil)
end
function c49811171.copyop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local code=tc:GetOriginalCodeRule()
        local cid=0
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetValue(code)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        if not tc:IsType(TYPE_TRAPMONSTER) then
            cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
        end
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(49811171,2))
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e2:SetCode(EVENT_PHASE+PHASE_END)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCountLimit(1)
        e2:SetLabelObject(e1)
        e2:SetLabel(cid)
        e2:SetOperation(c49811171.rstop)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2)
    end
end
function c49811171.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cid=e:GetLabel()
    if cid~=0 then
        c:ResetEffect(cid,RESET_COPY)
        c:ResetEffect(RESET_DISABLE,RESET_EVENT)
    end
    local e1=e:GetLabelObject()
    e1:Reset()
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c49811171.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD)
        and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c49811171.tgfilter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER)
end
function c49811171.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811171.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
    local g=Duel.GetMatchingGroup(c49811171.tgfilter,tp,LOCATION_REMOVED,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c49811171.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c49811171.tgfilter,tp,LOCATION_REMOVED,0,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
    end
end