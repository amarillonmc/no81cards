--花信之师 浩渺之源·努恩
function c16322140.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c16322140.lfilter,2,99,c16322140.lcheck)
	c:EnableReviveLimit()
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetValue(c16322140.matval)
	c:RegisterEffect(e0)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16322140,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,16322140)
	e1:SetCondition(c16322140.condition)
	e1:SetTarget(c16322140.target)
	e1:SetOperation(c16322140.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16322140,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCountLimit(1,16322140+2)
	e2:SetCondition(c16322140.damcon)
	e2:SetTarget(c16322140.damtg)
	e2:SetOperation(c16322140.damop)
	c:RegisterEffect(e2)
	--setself
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,16322140+1)
	e3:SetCondition(c16322140.setscon)
	e3:SetTarget(c16322140.setstg)
	e3:SetOperation(c16322140.setsop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c16322140.op2)
	c:RegisterEffect(e4)
	local e42=Effect.CreateEffect(c)
	e42:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e42:SetCode(EVENT_CHAIN_SOLVED)
	e42:SetRange(LOCATION_SZONE)
	e42:SetCondition(c16322140.spellcon)
	e42:SetOperation(c16322140.op22)
	c:RegisterEffect(e42)
end
function c16322140.lfilter(c)
	return c:IsLinkType(TYPE_EFFECT) and c:IsRace(RACE_PLANT)
end
function c16322140.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3dc1)
end
function c16322140.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return c:IsSetCard(0x3dc1) and c:IsLevel(3),true
end
function c16322140.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c16322140.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3dc1)
		and Duel.IsExistingMatchingCard(c16322140.colfilter,tp,0,LOCATION_MZONE,1,nil,c)
end
function c16322140.colfilter(c,tc)
	return c:IsFaceup() and c:GetAttack()>tc:GetAttack() and tc:GetColumnGroup():IsContains(c)
end
function c16322140.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16322140.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
end
function c16322140.filter2(c,tp,e)
	return c:IsFaceup() and c:IsSetCard(0x3dc1) and not c:IsImmuneToEffect(e)
		and Duel.IsExistingMatchingCard(c16322140.colfilter,tp,0,LOCATION_MZONE,1,nil,c)
end
function c16322140.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c16322140.filter2,tp,LOCATION_MZONE,0,nil,tp,e)
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
function c16322140.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function c16322140.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetBattleTarget():GetAttack()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.ceil(e:GetHandler():GetBattleTarget():GetAttack()/2))
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.ceil(e:GetHandler():GetBattleTarget():GetAttack()/2))
end
function c16322140.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsFaceup() and tc:IsControler(1-tp) and tc:IsRelateToBattle() then
		local atk=tc:GetAttack()
		Duel.Damage(1-tp,math.ceil(atk/2),REASON_EFFECT)
		Duel.Recover(tp,math.ceil(atk/2),REASON_EFFECT)
	end
end
function c16322140.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16322140.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16322140.setsop(e,tp,eg,ep,ev,re,r,rp)
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
function c16322140.spellcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS and ep~=tp and c:GetFlagEffect(16322140)~=0
end
function c16322140.op2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(16322140,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c16322140.op22(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,16322140)
	Duel.Recover(tp,300,REASON_EFFECT)
end