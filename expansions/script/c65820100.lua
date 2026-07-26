--源于黑影 螺旋
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(s.rmcost)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+65820000)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
		s.OAe={}
	end
end
function s.IsInTable(value, tbl)
	for k,v in ipairs(tbl) do
		if v == value then
		return true
		end
	end
	return false
end
function s.Act(c,e)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetLabelObject(e)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.HTAfactarget)
	e1:SetOperation(s.BaseActOp)
	return e1
end
function s.BaseActOp(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	if c:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(s.BaseActReset)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function s.BaseActReset(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
		if not rc:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_PENDULUM+TYPE_FIELD) and not rc:IsHasEffect(EFFECT_REMAIN_FIELD) then rc:CancelToGrave(false) end
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
end
function s.HTAfactarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	if s.geop_lock then return end
  	s.geop_lock = true

	local g=Duel.GetMatchingGroup(function(c)return c:IsSetCard(0x3a32) and c:IsType(TYPE_SPELL) and c:GetActivateEffect()end,0,LOCATION_DECK,LOCATION_DECK,nil)
	for tc in aux.Next(g) do
		local le={tc:GetActivateEffect()}
		for _,v in pairs(le) do
			if v:IsHasRange(0xa) and not s.IsInTable(v,s.OAe) then
				table.insert(s.OAe,v)
				local e1=v:Clone()
				e1:SetRange(LOCATION_DECK)
				e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
				tc:RegisterEffect(e1,true)
				local e2=s.Act(tc,e1)
				e2:SetRange(LOCATION_DECK)
				e2:SetCost(s.costchk)
				e2:SetOperation(s.costop)
				tc:RegisterEffect(e2,true)
				local e3=Effect.CreateEffect(tc)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_SPSUMMON_PROC_G)
				e3:SetRange(LOCATION_DECK)
				e3:SetCondition(s.hintcon)
				tc:RegisterEffect(e3,true)
			end
		end
	end

	s.geop_lock = false
end
function s.hintcon(e,c)
	if c==nil then return true end
	local ct=Duel.GetFlagEffectLabel(c:GetControler(),id) or 0
	return ct>0
end
function s.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffectLabel(tp,id) or 0
	return ct>0
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,id)
	Duel.SetFlagEffectLabel(tp,id,ct-1)
	s.BaseActOp(e,tp,eg,ep,ev,re,r,rp)
end
function s.actfilter(c)
	return c:IsSetCard(0x3a32) and c:IsType(TYPE_SPELL) and not c:IsForbidden()
end

function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lp=Duel.GetLP(tp)
	if lp>=2000 then
		Duel.PayLPCost(tp,2000,REASON_COST)
	else
		Duel.PayLPCost(tp,lp,REASON_COST)
	end
	if Duel.GetLP(tp)<=0 then
		Duel.SetLP(tp,4000)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_COST,tp,tp,4000)
	end
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,65820099)<10 end
	Duel.SetTargetPlayer(tp)
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local count=Duel.GetFlagEffect(p,65820099)
	if count>=10 then return end
	for i=0,10 do
		Duel.ResetFlagEffect(p,EFFECT_FLAG_EFFECT+65820000+i)
	end
	Duel.RegisterFlagEffect(p,65820099,0,0,1)
	local count1=math.max(Duel.GetFlagEffect(p,65820099),0)
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count1))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count1)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,p)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)==0 then Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1) end
	local ct=Duel.GetFlagEffectLabel(tp,id)
	Duel.SetFlagEffectLabel(tp,id,ct+1)
end