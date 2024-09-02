--花信之友 苍穹之望·艾希丝
function c16372025.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c16372025.lfilter,3,99,c16372025.lcheck)
	c:EnableReviveLimit()
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(0,LOCATION_SZONE)
	e0:SetValue(c16372025.matval)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,16372025)
	e1:SetCondition(c16372025.atkcon)
	e1:SetTarget(c16372025.atktg)
	e1:SetOperation(c16372025.atkop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCountLimit(1,16372025+200)
	e2:SetCondition(c16372025.damcon)
	e2:SetTarget(c16372025.damtg)
	e2:SetOperation(c16372025.damop)
	c:RegisterEffect(e2)
	--setself
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,16372025+100)
	e3:SetCondition(c16372025.setscon)
	e3:SetTarget(c16372025.setstg)
	e3:SetOperation(c16372025.setsop)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c16372025.discon)
	e4:SetOperation(c16372025.disop)
	c:RegisterEffect(e4)
end
function c16372025.lfilter(c)
	return c:IsLinkType(TYPE_EFFECT) and c:IsRace(RACE_PLANT)
end
function c16372025.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xdc1)
end
function c16372025.exmatcheck(c,lc,tp)
	if not c:IsControler(1-tp) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do	 
		local f=te:GetValue()
		local related,valid=f(te,lc,nil,c,tp)
		if related and not te:GetHandler():IsCode(16372025) then return false end
	end
	return true	 
end
function c16372025.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return c:IsSetCard(0xdc1),not mg or not mg:IsExists(c16372025.exmatcheck,1,nil,lc,tp)
end
function c16372025.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c16372025.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c16372025.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372025.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c16372025.atkfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-tc:GetDefense())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c16372025.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function c16372025.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return math.abs(tc:GetAttack()-tc:GetBaseAttack())>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.abs(tc:GetAttack()-tc:GetBaseAttack()))
end
function c16372025.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsFaceup() and tc:IsControler(1-tp) and tc:IsRelateToBattle() then
		Duel.Damage(1-tp,math.abs(tc:GetAttack()-tc:GetBaseAttack()),REASON_EFFECT)
	end
end
function c16372025.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16372025.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372025.setsop(e,tp,eg,ep,ev,re,r,rp)
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
function c16372025.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and not rc:IsSetCard(0xdc1)
		and rc:GetAttack()~=rc:GetBaseAttack()
		and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c16372025.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end