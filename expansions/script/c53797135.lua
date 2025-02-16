if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,83104731)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.sumcon)
	e1:SetTarget(s.sumtg)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.cost)
	e2:SetOperation(s.op)
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
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (re:GetHandler():IsSetCard(0x7) or re:GetHandler():IsCode(37694547))
end
function s.filter(c)
	return c:IsSummonable(true,nil)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(s.con1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e4:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e4,tp)
	local e5=e1:Clone()
	e5:SetTargetRange(0,1)
	e5:SetCondition(s.con2)
	Duel.RegisterEffect(e5,tp)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_SSET)
	Duel.RegisterEffect(e6,tp)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e7,tp)
	local e8=e5:Clone()
	e8:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e8:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e8,tp)
	local e9=Effect.CreateEffect(e:GetHandler())
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetTargetRange(1,1)
	e9:SetValue(s.actlimit)
	e9:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e9,tp)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>0
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>0
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
function s.actlimit(e,re,rp)
	return Duel.GetFieldGroupCount(rp,LOCATION_MZONE,0)>0 and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0x7)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)==0 then Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1) end
	local ct=Duel.GetFlagEffectLabel(tp,id)
	Duel.SetFlagEffectLabel(tp,id,ct+1)
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return aux.IsCodeListed(c,83104731) and c:GetActivateEffect()end,0,LOCATION_DECK,LOCATION_DECK,nil)
	for tc in aux.Next(g) do
		local le={tc:GetActivateEffect()}
		for _,v in pairs(le) do
			if v:IsHasRange(0xa) and not SNNM.IsInTable(v,s.OAe) then
				table.insert(s.OAe,v)
				local e1=v:Clone()
				e1:SetRange(LOCATION_DECK)
				e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
				tc:RegisterEffect(e1,true)
				local e2=SNNM.Act(tc,e1)
				e2:SetRange(LOCATION_DECK)
				e2:SetCost(s.costchk)
				e2:SetOperation(s.costop)
				tc:RegisterEffect(e2,true)
			end
		end
	end
end
function s.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffectLabel(tp,id) or 0
	return ct>0
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,id)
	Duel.SetFlagEffectLabel(tp,id,ct-1)
	SNNM.BaseActOp(e,tp,eg,ep,ev,re,r,rp)
end
