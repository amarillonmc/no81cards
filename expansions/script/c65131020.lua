--名字没想好
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(s.condition)
	--e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,aux.FALSE)
	if not s.global_check then
		s.global_check=true
		--_Damage=Duel.Damage
		--function Duel.Damage(p,value,...)
		--  if value>1000 and Duel.IsPlayerAffectedByEffect(p,id)~=nil and (Duel.IsPlayerAffectedByEffect(p,EFFECT_REVERSE_RECOVER)~=nil or Duel.IsPlayerAffectedByEffect(p,EFFECT_REVERSE_DAMAGE)==nil) then
		--	 return _Damage(p,1000,...)
		--  else
		--	  return _Damage(p,value,...)
		--  end
		--end
		--_Recover=Duel.Recover
		--function Duel.Recover(p,value,...)
		--  if value>1000 and Duel.IsPlayerAffectedByEffect(p,id)~=nil and Duel.IsPlayerAffectedByEffect(p,EFFECT_REVERSE_RECOVER)~=nil and Duel.IsPlayerAffectedByEffect(p,EFFECT_REVERSE_DAMAGE)==nil then
		--	  return _Recover(p,1000,...)
		--  else
		--	  return _Recover(p,value,...)
		--  end
		--end
		_SetLP=Duel.SetLP
		function Duel.SetLP(p,lp)
			if Duel.GetLP(p)-lp>1000 and Duel.IsPlayerAffectedByEffect(p,id)~=nil then
				Duel.Hint(HINT_CARD,0,id)
				_SetLP(p,Duel.GetLP(p)-1000)
			else
				_SetLP(p,lp)
			end
		end
		_CheckLPCost=Duel.CheckLPCost
		function Duel.CheckLPCost(p,cost)
			if cost>1000 and Duel.IsPlayerAffectedByEffect(p,id)~=nil then
				return _CheckLPCost(p,1000)
			else
				return _CheckLPCost(p,cost)
			end
		end
		_PayLPCost=Duel.PayLPCost
		function Duel.PayLPCost(p,cost)
			if cost>1000 and Duel.IsPlayerAffectedByEffect(p,id)~=nil then
				Duel.Hint(HINT_CARD,0,id)
				_PayLPCost(p,1000)
			else
				_PayLPCost(p,cost)
			end
		end	 
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(0,id)==0 then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,2)
		Duel.RegisterFlagEffect(1,id,RESET_PHASE+PHASE_END,0,2)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetTargetRange(1,1)
	e2:SetValue(2)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	e3:SetValue(function (e,re,val,r,rp)
		if val>1000 then Duel.Hint(HINT_CARD,0,id) end
		return math.min(val,1000)
	end)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetReset(RESET_PHASE+PHASE_END,2)
	e4:SetCondition(s.thcon)
	e4:SetOperation(s.thop)
	Duel.RegisterEffect(e4,tp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=Duel.GetTurnPlayer()
end
function s.IsPrime(num)
	if num<2 then return false end
	local i=2
	while i*i<=num do
		if num%i==0 then return false end
		i=i+1
	end
	return true;
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetTurnPlayer()
	local num=Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)
	c:SetHint(CHINT_TURN,num)
	if s.IsPrime(num) then Duel.Draw(p,1,REASON_EFFECT) end
end
function s.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_ONFIELD)>0
end