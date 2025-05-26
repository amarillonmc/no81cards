--雾锁窗未命名实体
local s,id=GetID()
function s.sprule(c)
    c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,s.mfilter1,s.mfilter2,2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
end
function s.mfilter1(c)
    local ot=c:GetOriginalType()
    return ot&TYPE_MONSTER~=0 and ot&(TYPE_LINK+TYPE_FUSION)~=0 and c:IsFusionSetCard(0x6c12)
end
function s.mfilter2(c)
    return c:IsType(TYPE_TOKEN) or c:IsFusionAttribute(ATTRIBUTE_WATER)
end
function s.chtg(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
    if not _G['e47320100'] then
        _G['e47320100']=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
        if tc:IsCode(47320100) then
            Duel.RegisterFlagEffect(tc:GetPreviousControler(),47320100,0,0,0)
        end
		tc=eg:GetNext()
	end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,47320116)>math.floor(Duel.GetFlagEffect(tp,47320100)/5) then return false end
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.filter(c,ct)
	return Duel.CheckChainTarget(ct,c)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc~=e:GetLabelObject() and chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and s.filter(chkc,ev) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetLabelObject(),ev) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,e:GetLabelObject(),ev)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetFirst():IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,g)
	end
    Duel.RegisterFlagEffect(tp,47320116,RESET_PHASE+PHASE_END,0,1)
end
function s.negate(c)
    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.discon)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainDisablable(ev) and not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and Duel.GetFlagEffect(tp,47320100)>=5 and Duel.GetFlagEffect(tp,47319116)==0
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,47319116)==0 and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,1)) then
		Duel.RegisterFlagEffect(tp,47319116,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,id)
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end
function s.tofield(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
end
function s.tffilter(c)
    return c:IsSetCard(0x6c12) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and not c:IsForbidden()
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and s.tffilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.tffilter,tp,LOCATION_REMOVED,0,1,nil)
     and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	Duel.SelectTarget(tp,s.tffilter,tp,LOCATION_REMOVED,0,1,1,nil)
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
	end
end
function s.initial_effect(c)
	s.sprule(c)
    s.chtg(c)
    s.negate(c)
    s.tofield(c)
end
