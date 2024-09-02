--花信之师 浩渺之源·努恩
function c16372024.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c16372024.lfilter,3,99,c16372024.lcheck)
	c:EnableReviveLimit()
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(0,LOCATION_SZONE)
	e0:SetValue(c16372024.matval)
	c:RegisterEffect(e0)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16372024,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,16372024)
	e1:SetCondition(c16372024.condition)
	e1:SetTarget(c16372024.target)
	e1:SetOperation(c16372024.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16372024,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCountLimit(1,16372024+200)
	e2:SetCondition(c16372024.damcon)
	e2:SetTarget(c16372024.damtg)
	e2:SetOperation(c16372024.damop)
	c:RegisterEffect(e2)
	--setself
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,16372024+100)
	e3:SetCondition(c16372024.setscon)
	e3:SetTarget(c16372024.setstg)
	e3:SetOperation(c16372024.setsop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c16372024.op2)
	c:RegisterEffect(e4)
	local e42=Effect.CreateEffect(c)
	e42:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e42:SetCode(EVENT_CHAIN_SOLVED)
	e42:SetRange(LOCATION_SZONE)
	e42:SetCondition(c16372024.spellcon)
	e42:SetOperation(c16372024.op22)
	c:RegisterEffect(e42)
end
function c16372024.lfilter(c)
	return c:IsLinkType(TYPE_EFFECT) and c:IsRace(RACE_PLANT)
end
function c16372024.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xdc1)
end
function c16372024.exmatcheck(c,lc,tp)
	if not c:IsControler(1-tp) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do	 
		local f=te:GetValue()
		local related,valid=f(te,lc,nil,c,tp)
		if related and not te:GetHandler():IsCode(16372024) then return false end
	end
	return true	 
end
function c16372024.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return c:IsSetCard(0xdc1),not mg or not mg:IsExists(c16372024.exmatcheck,1,nil,lc,tp)
end
function c16372024.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c16372024.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xdc1)
		and Duel.IsExistingMatchingCard(c16372024.colfilter,tp,0,LOCATION_MZONE,1,nil,c)
end
function c16372024.colfilter(c,tc)
	return c:IsFaceup() and c:GetAttack()>tc:GetAttack() and tc:GetColumnGroup():IsContains(c)
end
function c16372024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16372024.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
end
function c16372024.filter2(c,tp,e)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and not c:IsImmuneToEffect(e)
		and Duel.IsExistingMatchingCard(c16372024.colfilter,tp,0,LOCATION_MZONE,1,nil,c)
end
function c16372024.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c16372024.filter2,tp,LOCATION_MZONE,0,nil,tp,e)
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c16372024.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function c16372024.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetBattleTarget():GetAttack()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.ceil(e:GetHandler():GetBattleTarget():GetAttack()/2))
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.ceil(e:GetHandler():GetBattleTarget():GetAttack()/2))
end
function c16372024.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsFaceup() and tc:IsControler(1-tp) and tc:IsRelateToBattle() then
		local atk=tc:GetAttack()
		Duel.Damage(1-tp,math.ceil(atk/2),REASON_EFFECT)
		Duel.Recover(tp,math.ceil(atk/2),REASON_EFFECT)
	end
end
function c16372024.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16372024.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372024.setsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c16372024.spellcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS and ep~=tp and c:GetFlagEffect(16372024)~=0
end
function c16372024.op2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(16372024,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c16372024.op22(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,16372024)
	Duel.Recover(tp,300,REASON_EFFECT)
end