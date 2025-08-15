--魔人★双子使徒 火焰书士
local cm,m=GetID()
function cm.initial_effect(c)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.settg)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--effect2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--setname
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetRange(0xff)
	e5:SetValue(0x151)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetValue(0x6d)
	c:RegisterEffect(e6)
end
function cm.filter(c)
	return c:IsSetCard(0x97b) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,m)<2+(Duel.GetFlagEffect(tp,11451926)>0 and 1 or 0) end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local op=0
	if Duel.IsPlayerAffectedByEffect(tp,11451481) then
		op=Duel.SelectOption(tp,aux.Stringid(11451483,2),aux.Stringid(11451483,3))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451483,op+2))
		if op==1 then
			Duel.RegisterFlagEffect(tp,11451481,0,0,1)
			Duel.ResetFlagEffect(tp,11451482)
		end
	end
	if Duel.GetFlagEffect(tp,m)>2 or (op==1 and Duel.GetFlagEffect(tp,11451481)>1) then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451926,4))
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451926)}
		local g=Group.CreateGroup()
		for _,te in pairs(eset) do g:AddCard(te:GetHandler()) end
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			g=g:Select(tp,1,1,nil)
		end
		Duel.RaiseSingleEvent(g:GetFirst(),EVENT_CUSTOM+11451926,e,0,tp,tp,0)
	end
	e:SetLabel(op)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local op=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2-op)
		tc:RegisterEffect(e1)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_FAIRY)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)<2+(Duel.GetFlagEffect(tp,11451926)>0 and 1 or 0) end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local op=0
	if Duel.IsPlayerAffectedByEffect(tp,11451481) then
		op=Duel.SelectOption(tp,aux.Stringid(11451483,2),aux.Stringid(11451483,3))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451483,op+2))
		if op==1 then
			Duel.RegisterFlagEffect(tp,11451481,0,0,1)
			Duel.ResetFlagEffect(tp,11451482)
		end
	end
	if Duel.GetFlagEffect(tp,m)>2 or (op==1 and Duel.GetFlagEffect(tp,11451481)>1) then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451926,4))
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451926)}
		local g=Group.CreateGroup()
		for _,te in pairs(eset) do g:AddCard(te:GetHandler()) end
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			g=g:Select(tp,1,1,nil)
		end
		Duel.RaiseSingleEvent(g:GetFirst(),EVENT_CUSTOM+11451926,e,0,tp,tp,0)
	end
	e:SetLabel(op)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	--activate limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetLabel(2-op)
	e4:SetCondition(cm.econ)
	e4:SetValue(cm.elimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	if Duel.GetFlagEffect(tp,m-1)>0 then return end
	Duel.RegisterFlagEffect(tp,m-1,RESET_PHASE+PHASE_END,0,1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetOperation(cm.aclimit1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local ct=Duel.GetFlagEffectLabel(tp,m)
	if not ct then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1,1)
	else
		Duel.SetFlagEffectLabel(tp,m,ct+1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetLabel(ev)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_CHAIN)
	e2:SetOperation(cm.resetop)
	Duel.RegisterEffect(e2,tp)
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local ct=Duel.GetFlagEffectLabel(tp,m)
	if ev==e:GetLabel() then Duel.SetFlagEffectLabel(tp,m,ct-1) end
end
function cm.econ(e)
	local ct=Duel.GetFlagEffectLabel(e:GetHandlerPlayer(),m)
	return ct and ct>=e:GetLabel()
end
function cm.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end