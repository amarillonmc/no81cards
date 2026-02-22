--源于黑影 朦胧
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_PAY_LPCOST)
	e3:SetCondition(s.damcon1)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DAMAGE)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_CHAIN_SOLVED)
	c:RegisterEffect(e5)
	--Cost Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LPCOST_CHANGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(s.costchcon)
	e2:SetValue(s.costchange)
	--c:RegisterEffect(e2)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCountLimit(1)
	e6:SetTarget(s.damtg)
	e6:SetOperation(s.rmop)
	--c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,0))
	e7:SetRange(LOCATION_FZONE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_CUSTOM+65820000)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCountLimit(1)
	e7:SetCondition(s.condition)
	e7:SetTarget(s.damtg)
	e7:SetOperation(s.rmop)
	c:RegisterEffect(e7)
end

s.effect_lixiaoguo=true

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
end

function s.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetTurnPlayer()==tp and (Duel.GetFlagEffect(tp,65820099)==0 and c:GetFlagEffect(65820010)==0 or Duel.GetFlagEffect(tp,65820099)>0 and c:GetFlagEffect(65820010)>0)) or (Duel.GetTurnPlayer()==1-tp and (Duel.GetFlagEffect(tp,65820099)>0 and c:GetFlagEffect(65820010)==0 or Duel.GetFlagEffect(tp,65820099)==0 and c:GetFlagEffect(65820010)>0))
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)<=0 and Duel.GetLP(1-tp)~=0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.SetLP(tp,4000)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_EFFECT,tp,tp,4000)
	end
end


function s.costchcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return (Duel.GetFlagEffect(tp,65820099)==0 and c:GetFlagEffect(65820010)>0 or Duel.GetFlagEffect(tp,65820099)>0 and c:GetFlagEffect(65820010)==0)
end
function s.costchange(e,re,rp,val)
	if re and re:GetHandler():IsSetCard(0x3a32) and not Duel.IsChainSolving() then
		return 99999--re:GetHandler():GetControler():GetLP()
	else
		return val
	end
end



function s.cfilter1(c,tp)
	return c:IsSetCard(0x3a32)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil,tp) and ep==tp
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,65820099)<10 end
	Duel.SetTargetPlayer(tp)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local count=Duel.GetFlagEffect(p,65820099)
	if count>=10 then return end
	for i=0,10 do
		Duel.ResetFlagEffect(p,EFFECT_FLAG_EFFECT+65820000+i)
	end
	Duel.RegisterFlagEffect(p,65820099,0,0,1)
	local count1=math.max(Duel.GetFlagEffect(p,65820099),0)
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count1))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count1)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,p)
end