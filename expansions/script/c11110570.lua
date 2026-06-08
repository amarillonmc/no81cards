--领域对拼！！！
local s,id=GetID()
function s.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetRange(LOCATION_HAND)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetCondition(s.e0con)
	e0:SetTarget(s.e0tg)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.e1con)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
end
function s.e0filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function s.e0con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.e0filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function s.e0tg(e,c)
	return c:IsCode(id)
end
function s.e1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_FZONE,0)==nil
		or Duel.GetFieldCard(1-tp,LOCATION_FZONE,0)==nil
end
function s.e1filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local opp=1-tp
	local my_field=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	local op_field=Duel.GetFieldCard(opp,LOCATION_FZONE,0)
	local b1=false
	local b2=false
	if not my_field then
		b1=Duel.IsExistingMatchingCard(s.e1filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	end
	if not op_field then
		b2=Duel.IsExistingMatchingCard(s.e1filter,opp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,opp)
	end
	if chk==0 then return (b1 or b2) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local opp=1-tp
	local my_field=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	local op_field=Duel.GetFieldCard(opp,LOCATION_FZONE,0)
	if not my_field then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15248873,0))
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
		local tc=Duel.SelectMatchingCard(tp,s.e1filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		Duel.ResetFlagEffect(tp,15248873)
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECTS)
			e2:SetReset(RESET_EVENT+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE)
			tc:RegisterEffect(e3,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
		Duel.BreakEffect()
	end
	if not op_field then
		if Duel.IsExistingMatchingCard(s.e1filter,opp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,opp) then
			Duel.Hint(HINT_SELECTMSG,opp,aux.Stringid(15248873,0))
			local tc2=Duel.SelectMatchingCard(opp,s.e1filter,opp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,opp):GetFirst()
			if tc2 then
				local fc2=Duel.GetFieldCard(opp,LOCATION_FZONE,0)
				if fc2 then
					Duel.SendtoGrave(fc2,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(tc2,opp,opp,LOCATION_FZONE,POS_FACEUP,true)
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_DISABLE_EFFECTS)
				e4:SetReset(RESET_EVENT+RESET_PHASE+PHASE_END)
				tc2:RegisterEffect(e4,true)
				local e5=e4:Clone()
				e5:SetCode(EFFECT_DISABLE)
				tc2:RegisterEffect(e5,true)
				local te2=tc2:GetActivateEffect()
				te2:UseCountLimit(opp,1,true)
				local tep2=tc2:GetControler()
				local cost2=te2:GetCost()
				if cost2 then cost2(te2,tep2,eg,ep,ev,re,r,rp,1) end
				Duel.RaiseEvent(tc2,4179255,te2,0,opp,opp,Duel.GetCurrentChain())
			end
		end
	end

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetTargetRange(1,0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetCondition(s.e3costcon)
	e3:SetCost(s.e3cost)
	e3:SetOperation(s.e3costop)
	Duel.RegisterEffect(e3,tp)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_FLAG_EFFECT+id)
	e4:SetTargetRange(1,1)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetTargetRange(0,1)
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetCondition(s.e5costcon)
	e5:SetCost(s.e3cost)
	e5:SetOperation(s.e3costop)
	Duel.RegisterEffect(e5,tp)

	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetTargetRange(LOCATION_FZONE,0)
	e6:SetTarget(s.e6tg)
	e6:SetCondition(function()
		return Duel.GetLP(tp) < Duel.GetLP(1-tp)
	end)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	e7:SetTargetRange(LOCATION_FZONE,0)
	e7:SetTarget(s.e6tg)
	e7:SetCondition(function()
		return Duel.GetLP(tp) < Duel.GetLP(1-tp)
	end)
	e7:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e7,tp)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_CHANGE_CODE)
	e8:SetTargetRange(LOCATION_FZONE,0)
	e8:SetValue(76612510)
	Duel.RegisterEffect(e8,tp)

	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_DISABLE)
	e9:SetTargetRange(0,LOCATION_FZONE)
	e9:SetTarget(s.e6tg)
	e9:SetCondition(function()
		return Duel.GetLP(tp) > Duel.GetLP(1-tp)
	end)
	e9:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e9,tp)

	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_DISABLE_EFFECT)
	e10:SetTargetRange(0,LOCATION_FZONE)
	e10:SetTarget(s.e6tg)
	e10:SetCondition(function()
		return Duel.GetLP(tp) > Duel.GetLP(1-tp)
	end)
	e10:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e10,tp)
	local e11=e9:Clone()
	e11:SetCode(EFFECT_CHANGE_CODE)
	e11:SetTargetRange(0,LOCATION_FZONE)
	e11:SetValue(76612510)
	Duel.RegisterEffect(e11,tp)

	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetCountLimit(1)
	e12:SetCondition(s.e12con)
	e12:SetOperation(s.e12op)
	e12:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e12,tp)
end
function s.e12op(e,tp,eg,ep,ev,re,r,rp)
	local my_field = Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	local op_field = Duel.GetFieldCard(1-tp,LOCATION_FZONE,0)

	if not (my_field and op_field and my_field:IsFaceup() and op_field:IsFaceup()) then return end

	Duel.SendtoDeck(my_field, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SendtoDeck(op_field, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
end
function s.costcfilter(c)
return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function s.e3costcon(e,tp)
return Duel.IsExistingMatchingCard(s.costcfilter,tp,LOCATION_FZONE,0,1,nil)
end
function s.e5costcon(e,tp)
return Duel.IsExistingMatchingCard(s.costcfilter,tp,0,LOCATION_FZONE,1,nil)
end
function s.e3cost(e,te_or_c,tp)
local ct=Duel.GetFlagEffect(tp,id)
local can_pay=Duel.CheckLPCost(tp,ct*500)
local can_destroy=Duel.IsExistingMatchingCard(s.costcfilter,tp,LOCATION_FZONE,0,1,nil)
return can_pay or can_destroy
end
function s.e3costop(e,tp,eg,ep,ev,re,r,rp)
local ct=Duel.GetFlagEffect(tp,id)
local g=Duel.SelectMatchingCard(tp,s.costcfilter,tp,LOCATION_FZONE,0,0,1,nil)
if #g>0 then
Duel.Destroy(g,REASON_COST)
else
Duel.PayLPCost(tp,ct*500)
end
end
function s.e6tg(e,c)
	return c~=e:GetHandler() 
end
function s.e12filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function s.e12con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.e12filter1,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end