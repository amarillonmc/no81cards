--蓝星界开
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local types={1057,1056,1063,1073,1074,1076}
	local alist=Duel.GetFlagEffectLabel(tp,id)
	if not alist then
		Duel.SetTargetParam(types[Duel.SelectOption(tp,table.unpack(types))+1])
	else
		local options={}
		for i = 1, 5, 1 do
			if bit.extract(alist,i)==0 then
				table.insert(options,types[i])
			end
		end
		Duel.SetTargetParam(options[Duel.SelectOption(tp,table.unpack(options))+1])
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ct,p=0,0
	if opt==1057 then ct=TYPE_RITUAL   p=1 end
	if opt==1056 then ct=TYPE_FUSION   p=2 end
	if opt==1063 then ct=TYPE_SYNCHRO  p=3 end
	if opt==1073 then ct=TYPE_XYZ      p=4 end
	if opt==1074 then ct=TYPE_PENDULUM p=5 end
    if opt==1076 then ct=TYPE_LINK p=6 end
	local alist=Duel.GetFlagEffectLabel(tp,id)
	if not alist then
		alist=1<<p
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1,alist)
	else
		alist=alist|(1<<p)
		Duel.SetFlagEffectLabel(tp,id,alist)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(ct)
	e1:SetTargetRange(1,1)
	e1:SetTarget(s.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.distg)
	e2:SetLabel(ct)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAIN_SOLVING)
    e3:SetCondition(s.discon)
    e3:SetOperation(s.disop)
    e3:SetLabel(ct)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetOriginalType()&e:GetLabel()>0
end
function s.distg(e,c)
	return c:IsType(e:GetLabel())
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsType(e:GetLabel())
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end