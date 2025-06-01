--魔铳 急速之魔枪
function c60151905.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60151905+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60151905.e1con)
	e1:SetOperation(c60151905.e1op)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c60151905.e2con)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60151905.e2tg)
	e2:SetOperation(c60151905.e2op)
	c:RegisterEffect(e2)
end
function c60151905.e1con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c60151905.e1op(e,tp,eg,ep,ev,re,r,rp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(60151905,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(aux.TargetBoolFunction(c60151905.filter2))
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetCondition(c60151905.con)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetDescription(aux.Stringid(60151905,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetTarget(aux.TargetBoolFunction(c60151905.filter2))
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetCondition(c60151905.con)
	Duel.RegisterEffect(e4,tp)
end
function c60151905.filter2(c)
	return c:IsFaceup() and c:IsCode(60151902)
end
function c60151905.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xab26)
end
function c60151905.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60151905.filter,tp,LOCATION_PZONE,0,1,nil)
end
function c60151905.e2con(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	if not tc then return false end
	e:SetLabelObject(tc)
	local bc=tc:GetBattleTarget()
	return bc and tc:IsCode(60151902)
end
function c60151905.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151905.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=e:GetLabelObject()
	local d=a:GetBattleTarget()
	if a:IsFaceup() and a:IsRelateToBattle() and d:IsFaceup() and d:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(d:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		a:RegisterEffect(e1)
		local g=Group.FromCards(a,d)
		g:KeepAlive()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLED)
		e2:SetLabelObject(g)
		e2:SetOperation(c60151905.damop)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
end
function c60151905.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(Card.IsStatus,nil,STATUS_BATTLE_DESTROYED)
	local tc1=tg:Filter(Card.IsControler,nil,tp):GetFirst()
	local tc2=tg:Filter(Card.IsControler,nil,1-tp):GetFirst()
	if tc1 then
		Duel.Damage(tp,tc1:GetBaseAttack(),REASON_EFFECT,true)
	end
	if tc2 then
		Duel.Damage(1-tp,tc2:GetBaseAttack(),REASON_EFFECT,true)
	end
	Duel.RDComplete()
	g:DeleteGroup()
end