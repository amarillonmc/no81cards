local m=25000005
local cm=_G["c"..m]
cm.name="审判"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCost(cm.costchk)
	e1:SetOperation(cm.costop)
	c:RegisterEffect(e1)
	if cm.dpcounter==nil then
		cm.dpcounter=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.resetcount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_CHAIN_SOLVING)
		ge2:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	cm[rp]=cm[rp]+1
end
function cm.costchk(e,te_or_c,tp)
	e:SetLabelObject(te_or_c)
	return true
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m)>0 then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,0,m)
	local ac=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12,13)
	local re=e:GetLabelObject()
	local op=re:GetOperation()
	local repop=function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local ex=Effect.CreateEffect(e:GetHandler())
		ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex:SetCode(EVENT_PHASE+PHASE_END)
		ex:SetReset(RESET_PHASE+PHASE_END)
		ex:SetCountLimit(1)
		ex:SetLabel(ac)
		ex:SetLabelObject(e:GetHandler())
		ex:SetOperation(cm.just)
		Duel.RegisterEffect(ex,tp)
	end
	re:SetOperation(repop)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetLabelObject(re)
	e1:SetOperation(cm.reset)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(m+Duel.GetFlagEffect(tp,m)*10000)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetLabelObject(re)
	e2:SetOperation(op)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.just(e,tp,eg,ep,ev,re,r,rp)
	if cm[tp]==e:GetLabel() then return end
	Duel.Hint(HINT_CARD,0,m)
	local exc=nil
	if e:GetLabelObject() and e:GetLabelObject():GetFlagEffect(m)>0 then exc=e:GetLabelObject() end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,exc)
	if #g==0 then return end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	--local ct=math.min(#g,cm[tp])
	--local sg=g:Select(tp,ct,ct,nil)
	local ct=Duel.SendtoGrave(g,REASON_RULE)
	Duel.SetLP(tp,Duel.GetLP(tp)-ct*800)
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	local re,op=e:GetLabelObject(),nil
	for i=0,10 do
		local ce=re
		if Duel.IsPlayerAffectedByEffect(tp,m+i*10000) then
			for _,i in ipairs{Duel.IsPlayerAffectedByEffect(tp,m+i*10000)} do
				if i:GetLabelObject()==ce then
					op=i:GetOperation()
					i:Reset()
				end
			end
		end
	end
	if op then re:SetOperation(op) end
	e:Reset()
end
