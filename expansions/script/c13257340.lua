--梦超时空战斗机-琪露诺
local m=13257340
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1015)
	c:SetCounterLimit(0x1015,10)
	c:EnableCounterPermit(0x351)
	c:SetCounterLimit(0x351,5)
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.accon)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.acop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--perfect freeze
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(cm.cost1)
	e4:SetTarget(cm.target1)
	e4:SetOperation(cm.operation1)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetOperation(cm.bgmop)
	c:RegisterEffect(e11)
	eflist={"bomb",e4}
	cm[c]=eflist

end
function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(1)>0
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1015,1)
	end
end
function cm.acop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1015,1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1015)>=2 end
	local ct=e:GetHandler():GetCounter(0x1015)
	e:SetLabel(ct/2)
	e:GetHandler():RemoveCounter(tp,0x1015,ct,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local val=e:GetLabel()
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(val)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	Duel.RegisterEffect(e1,tp)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetCount()>0 then
		local tc=eg:GetFirst()
		while tc do
			if not tc:IsImmuneToEffect(e) then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local fid=e:GetOwner():GetFieldID()
				tc:RegisterFlagEffect(m+10000000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e3)
				end
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e4:SetCode(EVENT_PHASE+PHASE_END)
				e4:SetCountLimit(1)
				e4:SetLabel(fid)
				e4:SetLabelObject(tc)
				e4:SetCondition(cm.descon)
				e4:SetOperation(cm.desop)
				e4:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e4,tp)
			end
			if e:GetOwner():GetFlagEffect(m) then
				local e5=Effect.CreateEffect(c)
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
				e5:SetRange(LOCATION_MZONE)
				e5:SetCode(EFFECT_IMMUNE_EFFECT)
				e5:SetValue(cm.efilter)
				e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e:GetOwner():RegisterEffect(e5)
				local e6=Effect.CreateEffect(c)
				e6:SetType(EFFECT_TYPE_SINGLE)
				e6:SetProperty(EFFECT_FLAG_COPY_INHERIT)
				e6:SetCode(EFFECT_UPDATE_ATTACK)
				e6:SetReset(RESET_EVENT+RESETS_STANDARD)
				e6:SetValue(100)
				e:GetOwner():RegisterEffect(e6)

				e:GetOwner():AddCounter(0x351,1)
			end
			tc=eg:GetNext()
		end
	end
end
function cm.efilter(e,te)
	return te:GetHandler():GetFlagEffect(m+10000000)>0
end
function cm.desfilter(c,fid)
	return c:GetFlagEffectLabel(m+10000000)==fid
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.GetTurnPlayer()==tp then return false end
	if not cm.desfilter(tc,e:GetLabel()) then
		e:Reset()
		return false
	else return true end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	--local tg=g:Filter(c13257349.desfilter,nil,e:GetLabel())
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x351)>=5 end
	e:GetHandler():RemoveCounter(tp,0x351,5,REASON_COST)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(filter2,tp,0,LOCATION_ONFIELD,1,nil) end
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,0,LOCATION_ONFIELD,nil,e)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if not tc:IsImmuneToEffect(e) then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local fid=c:GetFieldID()
				tc:RegisterFlagEffect(m+10000000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e3)
				end
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e4:SetCode(EVENT_PHASE+PHASE_END)
				e4:SetCountLimit(1)
				e4:SetLabel(fid)
				e4:SetLabelObject(tc)
				e4:SetCondition(cm.descon)
				e4:SetOperation(cm.desop)
				e4:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e4,tp)
			end
			if e:GetOwner():GetFlagEffect(m) then
				local e5=Effect.CreateEffect(c)
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
				e5:SetRange(LOCATION_MZONE)
				e5:SetCode(EFFECT_IMMUNE_EFFECT)
				e5:SetValue(cm.efilter)
				e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e:GetOwner():RegisterEffect(e5)
				local e6=Effect.CreateEffect(c)
				e6:SetType(EFFECT_TYPE_SINGLE)
				e6:SetProperty(EFFECT_FLAG_COPY_INHERIT)
				e6:SetCode(EFFECT_UPDATE_ATTACK)
				e6:SetReset(RESET_EVENT+RESETS_STANDARD)
				e6:SetValue(100)
				e:GetOwner():RegisterEffect(e6)
			end
			tc=g:GetNext()
		end
	end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(cm.efilter)
	e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
	e:GetHandler():RegisterEffect(e4)
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(m,7))
end
