if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetOperation(s.sumop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.adjust)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.spcfilter(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_SZONE,0,1,nil)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local ct0=Duel.GetFlagEffectLabel(0,id)
	local ct1=Duel.GetFlagEffectLabel(1,id)
	Duel.SetFlagEffectLabel(0,id,ct0+1)
	Duel.SetFlagEffectLabel(1,id,ct1+1)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id,re,r,rp,ep,ev)
	if not Duel.IsChainSolving() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetOperation(s.trop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetOwner(),EVENT_CUSTOM+id,re,r,rp,ep,ev)
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	if not s.check then
		s.check=true
		Duel.RegisterFlagEffect(0,id,0,0,0,0)
		Duel.RegisterFlagEffect(1,id,0,0,0,0)
		s.OAe={}
		s.CAe={}
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		ge1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		ge1:SetTargetRange(0x38,0x38)
		ge1:SetValue(s.evalue)
		Duel.RegisterEffect(ge1,0)
	end
	local g=Duel.GetMatchingGroup(function(c)return c:IsType(TYPE_TRAP) and c:GetActivateEffect()end,0,LOCATION_DECK,LOCATION_DECK,nil)
	for tc in aux.Next(g) do
		local le={tc:GetActivateEffect()}
		for i,v in pairs(le) do
			if v:GetRange()&0x10a~=0 and not SNNM.IsInTable(v,s.OAe) then
				table.insert(s.OAe,v)
				local e1=v:Clone()
				local tg=v:GetTarget() or aux.TRUE
				e1:SetTarget(s.chtg(tg))
				e1:SetRange(LOCATION_DECK+)
				e1:SetHintTiming(TIMING_SUMMON+TIMING_SPSUMMON)
				tc:RegisterEffect(e1,true)
				table.insert(s.CAe,e1)
				local e2=SNNM.Act(tc,e1)
				e2:SetRange(LOCATION_DECK)
				e2:SetCost(s.costchk)
				e2:SetOperation(s.costop)
				tc:RegisterEffect(e2,true)
			end
		end
	end
end
function s.evalue(e,re,rp)
	return SNNM.IsInTable(re,s.CAe)
end
function s.chtg(_tg)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return _tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
				if chk==0 then
					local res1
					local f1=Duel.IsExistingTarget
					Duel.IsExistingTarget=function(...)
						res1=true
						return f1(...)
					end
					local f2=Card.IsCanBeEffectTarget
					Card.IsCanBeEffectTarget=function(...)
						res1=true
						return f2(...)
					end
					local res2=_tg(e,tp,eg,ep,ev,re,r,rp,0)
					Duel.IsExistingTarget=f1
					Card.IsCanBeEffectTarget=f2
					return res1 and res2
				end
				_tg(e,tp,eg,ep,ev,re,r,rp,1)
			end
end
function s.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffectLabel(tp,id)
	return ct>0 and Duel.CheckEvent(EVENT_CUSTOM+id)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,id)
	Duel.SetFlagEffectLabel(tp,id,ct-1)
	SNNM.BaseActOp(e,tp,eg,ep,ev,re,r,rp)
end
function s.adjust(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_CUSTOM+id) then return end
	Duel.SetFlagEffectLabel(0,id,0)
	Duel.SetFlagEffectLabel(1,id,0)
end
