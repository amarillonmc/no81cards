local m=53755006
local cm=_G["c"..m]
cm.name="兔子小队据守"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_DECK)
	e2:SetCondition(cm.condition)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_DECK)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetLabelObject(e2)
	e3:SetTarget(cm.actarget)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.tftg)
	e4:SetOperation(cm.tfop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(m)
	e5:SetRange(LOCATION_DECK)
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_ADJUST)
		ge:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) cm.check=false end)
		Duel.RegisterEffect(ge,0)
		cm[0]=Duel.ConfirmDecktop
		Duel.ConfirmDecktop=function(tp,ct)
			local g=Duel.GetDecktopGroup(tp,ct)
			if ct<5 and not cm.check then
				if g:IsExists(Card.IsHasEffect,1,nil,m) then Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) end
			end
			local ch=Duel.GetCurrentChain()
			g:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(m)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetLabelObject(g)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAINING)
			e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev>ch end)
			e2:SetLabelObject(e1)
			e2:SetOperation(cm.reset)
			e2:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e2,tp)
			cm.check=false
			return cm[0](tp,ct)
		end
		local f2=Duel.MoveSequence
		Duel.MoveSequence=function(...)
			cm.check=true
			return f2(...)
		end
	end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():GetLabelObject():Clear()
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	e:GetHandler():CreateEffectRelation(te)
	local c=e:GetHandler()
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function cm.pfilter(c,tp,...)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x5536) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:IsCode(...)
end
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local le={Duel.IsPlayerAffectedByEffect(tp,m)}
	local g,codet=Group.CreateGroup(),{}
	for _,v in pairs(le) do g:Merge(v:GetLabelObject()) end
	for tc in aux.Next(g) do table.insert(codet,tc:GetCode()) end
	if chk==0 then return #codet>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp,table.unpack(codet)) end
	e:SetLabel(table.unpack(codet))
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if rc:IsFaceup() and rc:IsLocation(LOCATION_ONFIELD) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetValue(cm.indct)
		rc:RegisterEffect(e2)
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp,e:GetLabel()):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
end
