--于耳边窃窃私语的管狐
local m=23400101
local cm=c23400101
function c23400101.initial_effect(c)
		local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(cm.drcon)
	e1:SetCost(cm.drcost)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,aux.FALSE)
if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.spcheckop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.spcheckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsSummonPlayer(0) then p1=true else p2=true end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1) end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 and Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)~=0
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,2)
	local b2=true
	local b3=true 
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(cm.draw)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	elseif opval[op]==2 then
		e:SetOperation(cm.control)
	elseif opval[op]==3 then
		e:SetOperation(cm.todeck)
	end
end
function cm.draw(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_DRAW)
		if Duel.GetTurnPlayer()==tp then
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
end
function cm.control(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(cm.limittg)
			if Duel.GetTurnPlayer()==tp then
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
	Duel.RegisterEffect(e2,tp)
	local e4=e2:Clone()
			if Duel.GetTurnPlayer()==tp then
			e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e4,tp)
	local et=Effect.CreateEffect(c)
	et:SetType(EFFECT_TYPE_FIELD)
	et:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	et:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	et:SetTargetRange(1,1)
	et:SetValue(cm.countval)
		if Duel.GetTurnPlayer()==tp then
			et:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			et:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
	Duel.RegisterEffect(et,tp)
end
function cm.limittg(e,c,tp)
	local t1,t2=Duel.GetActivityCount(tp,ACTIVITY_SUMMON,ACTIVITY_SPSUMMON)
	return t1+t2>=2
end
function cm.countval(e,re,tp)
	local t1,t2=Duel.GetActivityCount(tp,ACTIVITY_SUMMON,ACTIVITY_SPSUMMON)
	if t1+t2>=2 then return 0 else return 2-t1-t2 end
end
function cm.countval2(e,re,tp)
	local t1,t2=Duel.GetActivityCount(1-tp,ACTIVITY_SUMMON,ACTIVITY_SPSUMMON)
	if t1+t2>=2 then return 0 else return 2-t1-t2 end
end
function cm.todeck(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_MSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(aux.TRUE)
	Duel.RegisterEffect(e4,tp) 
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SSET)
	Duel.RegisterEffect(e5,tp)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e6,tp)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e7:SetTarget(cm.sumlimit)
	Duel.RegisterEffect(e7,tp)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e13:SetCode(EVENT_CHAINING)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e13:SetOperation(cm.count)
	Duel.RegisterEffect(e13,tp)
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e14:SetCode(EVENT_CHAIN_NEGATED)
	e14:SetRange(LOCATION_MZONE)
	e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e14:SetOperation(cm.rst)
	Duel.RegisterEffect(e14,tp)
	--activate limit
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetCode(EFFECT_CANNOT_ACTIVATE)
	e15:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e15:SetTargetRange(1,1)
	e15:SetCondition(cm.econ)
	e15:SetValue(cm.elimit)
	Duel.RegisterEffect(e15,tp)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(m+1,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.rst(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(m+1)
end
function cm.econ(e)
	return e:GetHandler():GetFlagEffect(m+1)~=0
end
function cm.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end