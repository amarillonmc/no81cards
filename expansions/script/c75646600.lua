--创造之匙
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(s.checkcon)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkcon(e)
	local tp=e:GetHandlerPlayer()
	local ct=e:GetHandler():GetFlagEffect(5646600)
	local ctt=0
	local cttt=Duel.GetFlagEffectLabel(tp,id-o)
	if cttt and cttt>0 then
		ctt=cttt
	end
	return ct and ct>ctt
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local ct=e:GetHandler():GetFlagEffect(5646600)
	local ctt=Duel.GetFlagEffectLabel(tp,id-o)
	if ct and ctt and ct>ctt then 
		Duel.ResetFlagEffect(tp,id-o)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetDescription(aux.Stringid(id,ct))
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local re1=Effect.CreateEffect(e:GetHandler())
	re1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	re1:SetCode(EVENT_ADJUST)
	re1:SetCondition(s.checkcon)
	re1:SetOperation(s.resetop)
	re1:SetLabelObject(e1)
	Duel.RegisterEffect(re1,tp)
	Duel.RegisterFlagEffect(tp,id-o,0,0,0,ct)
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	e1:Reset()
	e:Reset()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(5646600)
	local lp=500
	if ct>0 then lp=500+ct*500 end
	return Duel.GetLP(tp)<=lp 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(5646600)
	local lp=500
	if ct>0 then lp=500+ct*500 end
	if Duel.GetLP(tp)>lp then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(s.effectfilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.intg)
	e3:SetValue(1)
	Duel.RegisterEffect(e3,tp)  
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(s.spintg)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	Duel.RegisterEffect(e5,tp)
	Duel.RegisterFlagEffect(tp,id,0,0,1)
end
function s.intg(e,c)
	return aux.IsCodeListed(c,id)
end
function s.effectfilter(e,ct)
	local p=e:GetOwner():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and aux.IsCodeListed(te:GetHandler(),id)
end
function s.spintg(e,c)
	return aux.IsCodeListed(c,id)
end