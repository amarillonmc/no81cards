if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCode(id)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(s.adcon)
	e3:SetTarget(s.adtg)
	e3:SetValue(s.adval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		ge1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		ge1:SetTargetRange(0xfe,0xfe)
		ge1:SetTarget(s.efftg)
		ge1:SetValue(s.evalue)
		Duel.RegisterEffect(ge1,0)
		local f1=Card.GetActivateEffect
		Card.GetActivateEffect=function(ac)
			local le={f1(ac)}
			local res=true
			while res do
				res=false
				for k,v in pairs(le) do if SNNM.IsInTable(v,s.CAe) then table.remove(le,k) res=true break end end
			end
			return table.unpack(le)
		end
		local f2=Card.CheckActivateEffect
		Card.CheckActivateEffect=function(ac,...)
			local le={f2(ac,...)}
			local res=true
			while res do
				res=false
				for k,v in pairs(le) do if SNNM.IsInTable(v,s.CAe) then table.remove(le,k) res=true break end end
			end
			return table.unpack(le)
		end
	end
end
s.OAe={}
s.CAe={}
s.counter_add_list={0x100e}
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:GetActivateEffect()end,0,LOCATION_DECK+LOCATION_GRAVE,LOCATION_DECK+LOCATION_GRAVE,nil)
	for tc in aux.Next(g) do
		local le={tc:GetActivateEffect()}
		for i,v in pairs(le) do
			if v:GetRange()&0x10a~=0 and not SNNM.IsInTable(v,s.OAe) then
				table.insert(s.OAe,v)
				local e1=v:Clone()
				local tg=v:GetTarget() or aux.TRUE
				e1:SetTarget(s.chtg(tg))
				e1:SetRange(LOCATION_DECK+LOCATION_GRAVE)
				tc:RegisterEffect(e1,true)
				table.insert(s.CAe,e1)
				local e2=SNNM.Act(tc,e1)
				e2:SetRange(LOCATION_DECK+LOCATION_GRAVE)
				e2:SetCost(s.costchk)
				e2:SetOperation(s.costop)
				tc:RegisterEffect(e2,true)
			end
		end
	end
end
function s.chtg(_tg)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return _tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) and chkc==teg:GetFirst() end
				if chk==0 then
					local pro1,pro2=e:GetProperty()
					local res1=pro1&EFFECT_FLAG_CARD_TARGET~=0
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
					local f3=Card.GetCounter
					Card.GetCounter=function(sc,ct)
						if ct==0x100e then return 0 else return f3(sc,ct) end
					end
					s.check=true
					local res3=_tg(e,tp,eg,ep,ev,re,r,rp,0)
					s.check=false
					Duel.IsExistingTarget=f1
					Card.IsCanBeEffectTarget=f2
					Card.GetCounter=f3
					return res1 and res2 and not res3
				end
				_tg(e,tp,eg,ep,ev,re,r,rp,1)
			end
end
function s.efftg(e,c)
	return c:GetCounter(0x100e)<=0 and not s.check
end
function s.evalue(e,re,rp)
	return rp==e:GetHandlerPlayer() and SNNM.IsInTable(re,s.CAe) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.costchk(e,te_or_c,tp)
	return Duel.IsPlayerAffectedByEffect(tp,id)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local le={Duel.IsPlayerAffectedByEffect(tp,id)}
	local g=Group.CreateGroup()
	for _,v in pairs(le) do g:AddCard(v:GetOwner()) end
	local tc=SNNM.Select_1(g,tp,aux.Stringid(id,0))
	local te=nil
	for _,v in pairs(le) do if v:GetOwner()==tc then te=v end end
	te:UseCountLimit(tp)
	SNNM.BaseActOp(e,tp,eg,ep,ev,re,r,rp)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x100e,1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x100e,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x100e,1)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then tc:AddCounter(0x100e,1) end
end
function s.adcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function s.adtg(e,c)
	local bc=c:GetBattleTarget()
	return bc and c:GetCounter(0x100e)~=0 and bc:IsSetCard(0xc)
end
function s.adval(e,c)
	return c:GetCounter(0x100e)*-300
end
