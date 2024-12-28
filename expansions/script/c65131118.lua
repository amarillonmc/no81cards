--秘计螺旋 毒爆
local s,id,o=GetID()
function s.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		s.hinteffect={}
		s.hinteffect[0]=Effect.GlobalEffect()
		s.hinteffect[0]:SetDescription(aux.Stringid(id,2))
		s.hinteffect[0]:SetType(EFFECT_TYPE_FIELD)
		s.hinteffect[0]:SetCode(id+1)
		s.hinteffect[0]:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		s.hinteffect[0]:SetTargetRange(1,0)
		s.hinteffect[1]=s.hinteffect[0]:Clone()
		_SetLP=Duel.SetLP
		function Duel.SetLP(p,lp)
			if Duel.GetLP(p)-lp>1 and Duel.IsPlayerAffectedByEffect(p,id)~=nil then
				Duel.Hint(HINT_CARD,0,id)
				_SetLP(p,Duel.GetLP(p)-1)
			else
				_SetLP(p,lp)
			end
		end
		_CheckLPCost=Duel.CheckLPCost
		function Duel.CheckLPCost(p,cost)
			if cost>1 and Duel.IsPlayerAffectedByEffect(p,id)~=nil then
				return _CheckLPCost(p,1)
			else
				return _CheckLPCost(p,cost)
			end
		end
		_PayLPCost=Duel.PayLPCost
		function Duel.PayLPCost(p,cost)
			if cost>1 and Duel.IsPlayerAffectedByEffect(p,id)~=nil then
				Duel.Hint(HINT_CARD,0,id)
				_PayLPCost(p,1)
			else
				_PayLPCost(p,cost)
			end
		end  
	end
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id)==0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,2)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	e2:SetValue(function (e,re,val,r,rp)
		if val>1 then Duel.Hint(HINT_CARD,0,id) end
		return math.min(val,1)
	end)
	Duel.RegisterEffect(e2,tp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not Duel.IsPlayerAffectedByEffect(tp,id+1) then
		Duel.RegisterEffect(s.hinteffect[tp],tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetOperation(s.hintop)
		Duel.RegisterEffect(e1,tp)
		--adjust
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EVENT_ADJUST)
		e2:SetLabel(Duel.GetTurnCount())
		e2:SetOperation(s.adjustop)
		Duel.RegisterEffect(e2,tp)
		--
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_MAX_MZONE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetLabel(Duel.GetTurnCount())
		e3:SetValue(s.mvalue)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_MAX_SZONE)
		e4:SetValue(s.svalue)
		Duel.RegisterEffect(e4,tp)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_ACTIVATE)
		e5:SetValue(s.aclimit)
		Duel.RegisterEffect(e2,tp)
		local e6=e3:Clone()
		e6:SetCode(EFFECT_CANNOT_SSET)
		e6:SetTarget(s.setlimit)
		Duel.RegisterEffect(e6,tp)
	end
end
function s.hintop(e,tp,eg,ep,ev,re,r,rp)
	local desc=Duel.GetTurnCount()-e:GetLabel()+2
	if desc>12 then desc=12 end
	local e=s.hinteffect[tp]:Clone()
	e:SetDescription(aux.Stringid(id,desc))
	s.hinteffect[tp]:Reset()
	s.hinteffect[tp]=e
	Duel.RegisterEffect(s.hinteffect[tp],tp)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local limit=10+e:GetLabel()-Duel.GetTurnCount()
	local count=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if count>limit then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,count-limit,count-limit,nil)
		Duel.SendtoGrave(g,REASON_RULE)
		Duel.Readjust()
	end
end
function s.mvalue(e,fp,rp,r)
	local limit=10+e:GetLabel()-Duel.GetTurnCount()
	return limit-Duel.GetFieldGroupCount(fp,LOCATION_SZONE,0)
end
function s.svalue(e,fp,rp,r)
	local limit=10+e:GetLabel()-Duel.GetTurnCount()
	return limit-Duel.GetFieldGroupCount(fp,LOCATION_MZONE,0)
end
function s.aclimit(e,re,tp)
	local limit=10+e:GetLabel()-Duel.GetTurnCount()
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	if re:IsActiveType(TYPE_FIELD) then
		return not Duel.GetFieldCard(tp,LOCATION_FZONE,0) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>=limit
	elseif re:IsActiveType(TYPE_PENDULUM) then
		return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>=limit
	end
	return false
end
function s.setlimit(e,c,tp)
	local limit=10+e:GetLabel()-Duel.GetTurnCount()
	return c:IsType(TYPE_FIELD) and not Duel.GetFieldCard(tp,LOCATION_FZONE,0) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>=limit
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x836))
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end