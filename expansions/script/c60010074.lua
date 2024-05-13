--星-同谐-
local cm,m,o=GetID()
function cm.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
atkall=0
atkchange=0
function cm.adfilter(c,f)
	return math.max(f(c),0)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	if atkall~=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(cm.adfilter,Card.GetAttack) then
		atkchange=math.abs(atkall-Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(cm.adfilter,Card.GetAttack))
		atkall=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(cm.adfilter,Card.GetAttack)
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,nil,0,tp,tp,0)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_FZONE,0,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		--negate
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCondition(cm.lvcon)
		e2:SetOperation(cm.lvop)
		c:RegisterEffect(e2)
	end
end
function cm.lvfil(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_LINK)
end
function cm.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and e:GetHandler():IsLevelBelow(12)
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	if Duel.IsExistingMatchingCard(cm.lvfil,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local tc=Duel.GetMatchingGroup(cm.lvfil,tp,0,LOCATION_MZONE,nil):Select(tp,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-500)
		tc:RegisterEffect(e1)
	end
end

function cm.defil(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsDefense(0) and not c:IsType(TYPE_LINK)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)<e:GetHandler():GetLevel()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m+10000000)~=0 then
		if Duel.IsExistingMatchingCard(cm.defil,tp,0,LOCATION_MZONE,1,nil) then
			local tc=Duel.GetMatchingGroup(cm.defil,tp,0,LOCATION_MZONE,nil):Select(tp,1,1,nil):GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(-atkchange)
			tc:RegisterEffect(e1)
		else
			Duel.Damage(1-tp,atkchange,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m,RESET_PHASE+PHASE_END,0,1)
	else
		e:GetHandler():RegisterFlagEffect(m+10000000,RESET_PHASE+PHASE_END,0,1)
	end
end









