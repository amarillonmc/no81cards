--缭乱！胜利之路
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return true end cm.operation0(e,tp,eg,ep,ev,re,r,rp) end)
	e0:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return true end Duel.SetChainLimit(aux.FALSE) end)
	c:RegisterEffect(e0)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_ADJUST)
	e10:SetRange(LOCATION_FZONE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCondition(cm.condition0)
	e10:SetOperation(cm.operation0)
	--c:RegisterEffect(e10)
	--cannot be destroyed
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--cannot set/activate
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_SSET)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(1,0)
	e8:SetTarget(cm.setlimit)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(1,0)
	e9:SetValue(cm.actlimit)
	c:RegisterEffect(e9)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(cm.costcon)
	e1:SetTarget(cm.actarget2)
	e1:SetOperation(cm.costop2)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(m)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.rmcon)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	if not PNFL_TURN_TOHAND_CHECK then
		PNFL_TURN_TOHAND_CHECK={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_ONFIELD):Filter(Card.IsPreviousPosition,nil,POS_FACEUP)
	for tc in aux.Next(g) do
		local code,code2=tc:GetPreviousCodeOnField()
		PNFL_TURN_TOHAND_CHECK[code]=true
		if code2 then PNFL_TURN_TOHAND_CHECK[code2]=true end
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	PNFL_TURN_TOHAND_CHECK={}
end
function cm.condition0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)==0
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==4 then Duel.SendtoGrave(c,REASON_RULE) end
end
function cm.operation0(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,2))
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(cm.tgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,4)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
	cm[c]=e1
end
function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonLocation,1,nil,LOCATION_HAND)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetActivateEffect():IsActivatable(tp,true,true) end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		if tc:IsLocation(LOCATION_FZONE) then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_HAND)
			tc:RegisterEffect(e1)
		end
	end
end
function cm.costcon(e)
	cm[2]=false
	return true
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.actarget2(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc:IsLocation(LOCATION_MZONE)
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if cm[2] then return end
	local tg=te:GetTarget() or aux.TRUE
	local tg2=function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,1) end
				if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,0) end
				e:SetTarget(tg)
				tg(e,tp,eg,ep,ev,re,r,rp,1)
				if not Duel.IsPlayerAffectedByEffect(tp,m) or PNFL_TURN_TOHAND_CHECK[e:GetHandler():GetCode()] then return end
				local c=e:GetHandler()
				if c:IsLocation(LOCATION_MZONE) and c:IsAbleToHandAsCost() and Duel.GetFieldGroup(tp,LOCATION_HAND,0):FilterCount(cm.spfilter,nil,e,tp)>0 and Duel.GetMZoneCount(tp,c)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
					Duel.SendtoHand(c,nil,REASON_COST)
					c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
					local op0=e:GetOperation() or (function() end)
					local op2=function(e,tp,eg,ep,ev,re,r,rp)
								e:SetOperation(op0)
								op0(e,tp,eg,ep,ev,re,r,rp)
								local exc=e:GetHandler()
								if exc:GetFlagEffect(m)==0 then exc=nil end
								local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(cm.spfilter,exc,e,tp)
								if #sg>0 and Duel.GetMZoneCount(tp)>0 then
									Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
									sg=sg:Select(tp,1,1,nil)
									Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
								end
					end
					te:SetOperation(op2)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e1:SetCode(EVENT_CHAIN_SOLVED)
					e1:SetCountLimit(1)
					e1:SetLabel(Duel.GetCurrentChain()+1)
					e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==e:GetLabel() end)
					e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) re:SetOperation(op0) end)
					e1:SetReset(RESET_CHAIN)
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone()
					e2:SetCode(EVENT_CHAIN_NEGATED)
					Duel.RegisterEffect(e2,tp)
				end
			end
	te:SetTarget(tg2)
	cm[2]=true
end