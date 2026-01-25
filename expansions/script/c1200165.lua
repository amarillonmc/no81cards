--元素百科全书-光之卷
--1200165
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,5))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.tdcon)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
	
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCondition(s.checkcon)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return (sc and sc:IsSetCard(0x5240))
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x5240)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x5240) and tc:IsType(TYPE_SYNCHRO) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function s.studyfilter(c,tp)
	return c:IsCode(1200200) and c.studycon(c,tp)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=Duel.GetFlagEffect(tp,id)+1
	local study=Duel.IsExistingMatchingCard(s.studyfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	if count>=2 or study then
		--battle
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e11:SetReset(RESET_EVENT+RESETS_STANDARD)
		e11:SetValue(1)
		c:RegisterEffect(e11)
		local e12=Effect.CreateEffect(c)
		e12:SetType(EFFECT_TYPE_SINGLE)
		e12:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e12:SetReset(RESET_EVENT+RESETS_STANDARD)
		e12:SetValue(1)
		c:RegisterEffect(e12)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	end
	if count>=3 or study then
		--attack all
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ATTACK_ALL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(1)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	end
	if count>=4 or study then
		--cannot active
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetTargetRange(0,1)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(1)
		e3:SetCondition(s.actcon)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
	if count>=5 or study then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
	if count==6 or study then
		--atk down
		--local e4=Effect.CreateEffect(c)
		--e4:SetDescription(aux.Stringid(id,6))
		--e4:SetCategory(CATEGORY_ATKCHANGE)
		--e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
		--e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		--e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		--e4:SetCondition(s.atkcon)
		--e4:SetOperation(s.atkop)
		--c:RegisterEffect(e4)
		local e41=Effect.CreateEffect(c)
		e41:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e41:SetType(EFFECT_TYPE_FIELD)
		e41:SetCode(EFFECT_DISABLE)
		e41:SetRange(LOCATION_MZONE)
		e41:SetTargetRange(0,LOCATION_MZONE)
		e41:SetReset(RESET_EVENT+RESETS_STANDARD)
		e41:SetCondition(s.adcon)
		e41:SetTarget(s.adtg)
		c:RegisterEffect(e41)
		local e42=e41:Clone()
		e42:SetCode(EFFECT_DISABLE_EFFECT)
		c:RegisterEffect(e42)
		local e43=Effect.CreateEffect(c)
		e43:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e43:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e43:SetRange(LOCATION_MZONE)
		e43:SetOperation(s.atkop)
		e43:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e43)
		
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
	end
end

function s.tdfilter(c)
	return c:IsSetCard(0x5240) and c:IsAbleToDeck()
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,id)>=4 or Duel.IsExistingMatchingCard(s.studyfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,0x3e,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),tp,0x3e)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,0x3e,0,aux.ExceptThisCard(e))
	if aux.NecroValleyNegateCheck(g) then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

function s.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end

function s.adcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
end
function s.adtg(e,c)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a or not d then return false end	
	if not a:IsType(TYPE_EFFECT) and c:GetOriginalType()&TYPE_EFFECT==0 
		and not a:IsType(TYPE_EFFECT) and c:GetOriginalType()&TYPE_EFFECT==0 then return false end
	local tp=e:GetHandlerPlayer()
	local tc=e:GetHandler()
	return (a and a:IsControler(tp) and tc==a and c==a:GetBattleTarget()) or (d and d:IsControler(tp) and tc==d and c==d:GetBattleTarget())
end


function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a or not d then return end	
	if d==c then a,d=d,a end
	if not a==c or not d or d:IsControler(tp) or not d:IsRelateToBattle() then return end
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(d:GetAttack()%700)
	d:RegisterEffect(e1,true)
	if d:IsDefenseAbove(0) then
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(d:GetDefense()%700)
		d:RegisterEffect(e2,true)
	end
		
end


