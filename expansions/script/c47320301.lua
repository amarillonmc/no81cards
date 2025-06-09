-- 花冠的幼王 克萝娜
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,47320301)
    s.ritmate(c)
    s.fusmate(c)
    s.synmate(c)
end
function s.ritmate(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_RITUAL_LEVEL)
    e1:SetValue(s.rlevel)
    c:RegisterEffect(e1)
end
function s.rlevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c:IsSetCard(0x3c17) or aux.IsCodeListed(c,47320301) then
		local clv=c:GetLevel()
		return (lv<<16)+clv
	else return lv end
end
function s.fusmate(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_BE_MATERIAL)
    e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
    e1:SetCondition(s.fucon)
    e1:SetOperation(s.fuop)
    c:RegisterEffect(e1)
end
function s.fucon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	return r==REASON_FUSION and aux.IsCodeListed(c:GetReasonCard(),47320301)
end
function s.fuop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    if not rc then return end

    local e1=Effect.CreateEffect(rc)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(s.limcon)
    e1:SetOperation(s.limop)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
    local e2=Effect.CreateEffect(rc)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_END)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetOperation(s.limop2)
	rc:RegisterEffect(e2,true)
    if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e3,true)
	end
end
function s.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(47320301,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(s.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(47320301)
	e:Reset()
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(47320301)~=0 then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	end
	e:GetHandler():ResetFlagEffect(47320301)
end
function s.synmate(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(s.synval)
	c:RegisterEffect(e1)
end
function s.synval(e,c)
    return c:IsType(TYPE_SYNCHRO) and aux.IsCodeListed(c,47320301)
end
