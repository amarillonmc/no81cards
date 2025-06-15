--骰子小钥心·小全
local m=87498636
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local dice=Duel.TossDice(tp,1)
	local val=dice*700
	local c=e:GetHandler()
	local de=Effect.CreateEffect(c)
	de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	de:SetCode(EVENT_SPSUMMON_SUCCESS)
	de:SetLabel(val)
	de:SetOperation(cm.desop)
	Duel.RegisterEffect(de,tp)
end
function cm.desop(e,tp,eg)
	local dg=eg:Filter(Card.IsSummonPlayer,nil,1-tp)
	local val=e:GetLabel()
	local c=e:GetHandler()
	local og=Group.CreateGroup()
	if dg:GetCount()>0 then
		for tc in aux.Next(dg) do
			local flag=false
			if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
				local atk=tc:GetAttack()
				local def=tc:GetDefense()
				if atk>val then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_ATTACK_FINAL)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(0)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
					flag=true
				end
				if def>val then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(0)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
					flag=true
				end
			end
			if flag then
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
				og:AddCard(tc)
			end
		end
	end
	og:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetLabelObject(og)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.desop2)
	Duel.RegisterEffect(e2,tp)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	local dg=e:GetLabelObject()
	local og=Group.CreateGroup()
	Duel.Hint(HINT_CARD,0,m)
	for tc in aux.Next(dg) do
		if tc:GetFlagEffect(m)>0 then
			og:AddCard(tc)
			tc:ResetFlagEffect(m)
		end
	end
	Duel.Destroy(og,REASON_EFFECT)	 
end