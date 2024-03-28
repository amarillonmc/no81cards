--镜影
--a(0)=1 a(1)=2 a(2)=8 a(3)=2048 a(4)=10^620
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil) end
end
function cm.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.filter3(c,ct)
	return c:GetFlagEffect(m)>ct
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_ONFIELD,0,nil,e)
	if sg:IsExists(cm.filter3,1,nil,1) and not cm[1] then
		cm[1]=true
		if 1==0 then
			Duel.Hint(24,0,aux.Stringid(m,7))
			Duel.Hint(24,0,aux.Stringid(m,8))
		else
			Debug.Message("A liar's song left all alone in fractals.")
			Debug.Message("纷繁层叠的真实倏忽入梦。神圣的狂乱于分形之中诞生。")
		end
	elseif sg:IsExists(cm.filter3,1,nil,0) and not cm[0] then
		cm[0]=true
		if 1==0 then
			Duel.Hint(24,0,aux.Stringid(m,5))
			Duel.Hint(24,0,aux.Stringid(m,6))
		else
			Debug.Message("Mirror on the wall, what fates do you see?")
			Debug.Message("递归、反复、循环。镜中映照出的是另一面镜还是迷宫？")
		end
	end
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(m,1))
		tc=sg:GetNext()
	end
	sg:KeepAlive()
	local e1=Effect.CreateEffect(c)
	local fid=e1:GetFieldID()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return re:GetHandler():GetFlagEffect(m)>0 and re:GetHandler():GetFlagEffectLabel(m)==fid end)
	e1:SetOperation(cm.dsop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(sg)
	e2:SetCondition(cm.descon)
	e2:SetOperation(cm.desop)
	Duel.RegisterEffect(e2,tp)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local dg=g:Filter(cm.desfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Destroy(dg,REASON_EFFECT)
end
function cm.desfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.dsop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsImmuneToEffect(e) then return end
	local op=re:GetOperation() or aux.TRUE
	local op2=function(e,...) e:SetOperation(op)  op(e,...) op(e,...) end
	re:SetOperation(op2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(ev)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==e:GetLabel() end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) re:SetOperation(op) end)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end