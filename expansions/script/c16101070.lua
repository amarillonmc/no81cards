--叠个甲
local m=16101070
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.act)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.sptg1)
	e2:SetOperation(cm.spop1)
	c:RegisterEffect(e2)
	--
	if not hudunjiance then
		hudunjiance=true
		hudunzhi={0,0,0,0}
	end
end
function cm.damval2(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if hudunzhi[tp+1]~=0 then
		if hudunzhi[tp+1]>=val then
			hudunzhi[tp+1]=hudunzhi[tp+1]-val
			return 0
		else
			val=val-hudunzhi[tp+1]
			hudunzhi[tp+1]=0
			return val
		end
	else
		return val
	end
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	hudunzhi[tp+1]=hudunzhi[tp+1]+3000
	if Duel.GetFlagEffect(tp,m)==0 then
		Duel.RegisterFlagEffect(tp,m,0,0,0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CHANGE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetValue(cm.damval2)
		Duel.RegisterEffect(e2,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,4))
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetCondition(cm.con)
		e1:SetOperation(cm.op1)
		Duel.RegisterEffect(e1,tp)
		e2:SetLabelObject(e1)
	end
end
function cm.con(e,tp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.op1(e,tp)
	Duel.Hint(HINT_NUMBER,tp,hudunzhi[tp+1])
end