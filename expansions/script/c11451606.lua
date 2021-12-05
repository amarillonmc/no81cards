--斩机双同态
--21.08.08
local m=11451606
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetTargetRange(LOCATION_GRAVE,0)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e5)
	--become effect
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_ADD_TYPE)
	e8:SetValue(TYPE_EFFECT)
	e8:SetRange(LOCATION_SZONE)
	e8:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE,0)
	e8:SetTarget(cm.betg)
	c:RegisterEffect(e8)
end
function cm.AddFlagEffectLabel(code)
	local lab={Duel.GetFlagEffectLabel(tp,m)}
	if not lab or #lab==0 then Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1,code) return end
	table.insert(lab,code)
	Duel.SetFlagEffectLabel(tp,m,table.unpack(lab))
end
function cm.CheckFlagEffectLabel(code)
	local lab={Duel.GetFlagEffectLabel(tp,m)}
	if not lab or #lab==0 then return true end
	for _,ct in pairs(lab) do
		if ct==code then return false end
	end
	return true
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local code=c:GetOriginalCode()
	return Duel.GetFlagEffect(tp,m)==0 and rc~=c and rc:IsLocation(c:GetLocation()) and rc:IsControler(tp) and rc:IsSetCard(0x132)-- and cm.CheckFlagEffectLabel(code)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	--cm.AddFlagEffectLabel(code)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=re:GetTarget()
	if chk==0 then
		e:SetProperty(re:GetProperty())
		e:SetLabel(re:GetLabel())
		e:SetLabelObject(re:GetLabelObject())
		return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
	end
	e:SetCategory(re:GetCategory())
	e:SetProperty(re:GetProperty())
	e:SetLabel(re:GetLabel())
	e:SetLabelObject(re:GetLabelObject())
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabelObject(e)
	e1:SetCondition(cm.rscon)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	re:SetCategory(0)
	re:SetProperty(0)
	re:SetLabel(0)
	re:SetLabelObject(nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.eftg(e,c)
	return c:IsSetCard(0x132)
end
function cm.betg(e,c)
	return c:IsSetCard(0x132) and not c:IsType(TYPE_EFFECT)
end