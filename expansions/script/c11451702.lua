--舞台倾侧
local m=11451702
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local _GetTurnCount=Duel.GetTurnCount
	Duel.GetTurnCount=function() if Duel.GetTurnPlayer()==tp then return _GetTurnCount()+2 else return _GetTurnCount()+1 end end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SKIP_TURN)}
	Duel.GetTurnCount=_GetTurnCount
	if #eset>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(cm.hapeop)
		if Duel.GetTurnPlayer()==tp then
			e1:SetLabel(Duel.GetTurnCount()+2)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetLabel(Duel.GetTurnCount()+1)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(cm.skipcon)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
	Duel.GetTurnCount=function() if Duel.GetTurnPlayer()==1-tp then return _GetTurnCount()+2 else return _GetTurnCount()+1 end end
	local eset2={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN)}
	Duel.GetTurnCount=_GetTurnCount
	if #eset2>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(cm.hapeop2)
		if Duel.GetTurnPlayer()==1-tp then
			e1:SetLabel(Duel.GetTurnCount()+2)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		else
			e1:SetLabel(Duel.GetTurnCount()+1)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	else
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SKIP_TURN)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		if Duel.GetTurnPlayer()==1-tp then
			e2:SetLabel(Duel.GetTurnCount())
			e2:SetCondition(cm.skipcon)
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		else
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		end
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.hapeop(e,tp)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SKIP_TURN)}
	if #eset>0 then
		for _,ae in pairs(eset) do
			local con=ae:GetCondition() or aux.TRUE
			local lab=e:GetLabel()
			ae:SetCondition(function(e,...) return con(e,...) and Duel.GetTurnCount()~=lab end)
		end
	end
end
function cm.hapeop2(e,tp)
	local eset={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN)}
	if #eset>0 then
		for _,ae in pairs(eset) do
			local con=ae:GetCondition() or aux.TRUE
			local lab=e:GetLabel()
			ae:SetCondition(function(e,...) return con(e,...) and Duel.GetTurnCount()~=lab end)
		end
	end
end