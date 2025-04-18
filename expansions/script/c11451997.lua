--地灵佑佐 奥丝
local cm,m=GetID()
function cm.initial_effect(c)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(c)
	e3:SetCondition(cm.discon)
	e3:SetOperation(cm.disop)
	--pnfl.continuouseffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e3)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(function(e,c) return c:IsType(TYPE_EFFECT) end)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CUSTOM+m)
	e6:SetRange(LOCATION_MZONE)
	--e6:SetCondition(cm.discon)
	e6:SetOperation(cm.disop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(m)
	e7:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e7)
	--cm[c]=e6
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	--e1:SetCode(EVENT_LEAVE_FIELD_P)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTarget(cm.leaveop)
	e1:SetValue(aux.FALSE)
	local e4=e2:Clone()
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
	--remain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetLabelObject(e4)
	e5:SetTarget(cm.remain)
	e5:SetValue(aux.FALSE)
	--c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		cm.chainout={}
		cm.chainout[0]={}
		cm.chainout[1]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_ACTIVATING)
		ge1:SetOperation(function()
							cm.chainout[0]={}
							cm.chainout[1]={}
						end)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc&LOCATION_ONFIELD~=0 and not c:IsDisabled() then
		local tab=cm.chainout[c:GetControler()]
		--[[for _,tc in ipairs(tab) do
			if c==tc then c=nil end
		end--]]
		if c then tab[#tab+1]=c end
	end
	return loc&LOCATION_ONFIELD~=0
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lastc=(#cm.chainout[1-Duel.GetTurnPlayer()]==0 and cm.chainout[c:GetControler()][(#cm.chainout[c:GetControler()])]==c) or (c:GetControler()==1-Duel.GetTurnPlayer() and cm.chainout[c:GetControler()][(#cm.chainout[c:GetControler()])]==c)
	if not c:IsHasEffect(m) or e:GetCode()~=EVENT_CHAIN_SOLVING then
		--if e:GetCode()~=EVENT_CHAIN_SOLVING then Debug.Message(c:GetSequence()) end
		if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT) then --and c:GetOriginalCode()==m then
			if Duel.GetCurrentPhase()==PHASE_STANDBY then
				local tid=Duel.GetTurnCount()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(m,1))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
				e1:SetLabelObject(c)
				e1:SetCountLimit(1)
				e1:SetCondition(function() return Duel.GetTurnCount()~=tid end)
				e1:SetOperation(cm.retop)
				Duel.RegisterEffect(e1,tp)
			else
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(m,1))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e1:SetReset(RESET_PHASE+PHASE_STANDBY)
				e1:SetLabelObject(c)
				e1:SetCountLimit(1)
				e1:SetOperation(cm.retop)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
	if lastc and e:GetCode()==EVENT_CHAIN_SOLVING then --c~=e:GetLabelObject() and  --and (c:IsControler(1-Duel.GetTurnPlayer()) or not Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled() end,Duel.GetTurnPlayer(),0,LOCATION_MZONE,1,nil)) then
		--cm.disop(c[c],tp,eg,ep,ev,re,r,rp)
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,re,r,rp,ep,ev)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.leaveop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsContains(e:GetHandler()) and not e:GetHandler():IsFacedown() and e:GetHandler():GetDestination()&LOCATION_ONFIELD==0 end
	--if e:GetHandler():IsFacedown() then return end
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	local effp=e:GetHandler():GetControler()
	if Duel.Draw(effp,1,REASON_EFFECT)>0 then
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			local tid=Duel.GetTurnCount()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,2))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
			e1:SetCountLimit(1)
			e1:SetCondition(function() return Duel.GetTurnCount()~=tid end)
			e1:SetOperation(cm.rmop)
			Duel.RegisterEffect(e1,effp)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,2))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetOperation(cm.rmop)
			Duel.RegisterEffect(e1,effp)
		end
	end
	return false
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function cm.remain(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsContains(e:GetHandler()) end
	local e4=e:GetLabelObject():Clone()
	Duel.RegisterEffect(e4,tp)
	local ec={
		EVENT_CHAIN_ACTIVATING,
		EVENT_CHAINING,
		EVENT_ATTACK_ANNOUNCE,
		EVENT_BREAK_EFFECT,
		EVENT_CHAIN_SOLVING,
		EVENT_CHAIN_SOLVED,
		EVENT_CHAIN_END,
		EVENT_SUMMON,
		EVENT_SPSUMMON,
		EVENT_MSET,
		EVENT_BATTLE_DESTROYED
	}
	for _,code in ipairs(ec) do
		local ce=Effect.CreateEffect(e:GetHandler())
		ce:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce:SetCode(code)
		ce:SetLabelObject(e4)
		ce:SetOperation(function(e) if aux.GetValueType(e:GetLabelObject())=="Effect" then e:GetLabelObject():Reset() end e:Reset() end)
		Duel.RegisterEffect(ce,tp)
	end
	return false
end