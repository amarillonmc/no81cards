--传说之魂 正义
local m=33350005
local cm=_G["c"..m]
function c33350005.initial_effect(c)
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetCode(EVENT_SUMMON_SUCCESS)
	e01:SetRange(LOCATION_MZONE)
	e01:SetCondition(cm.e01con)
	e01:SetOperation(cm.e01op)
	c:RegisterEffect(e01)
	local e02=e01:Clone()
	e02:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e02)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetTarget(cm.attack)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(cm.actcon)
	e4:SetValue(cm.atlimit)
	c:RegisterEffect(e4)
end
cm.setname="TaleSouls"
function cm.tgfilter(c)
	return c:IsAbleToGrave()
end
function cm.filter(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.e01con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.e01op(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local nseq=Duel.TossDice(tp,1)-1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0  then
		return false
	end
	while nseq>4 or not Duel.CheckLocation(tp,LOCATION_MZONE,nseq) do
		nseq=Duel.TossDice(tp,1)-1
	end
	Duel.MoveSequence(c,nseq)

	if Duel.IsExistingMatchingCard(cm.tgfilter,tp,0,LOCATION_MZONE,1,nil)
	 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local ng=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
			local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
			local yseq=math.log(s,2)
			Duel.MoveSequence(ng,yseq-16)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(-300)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			ng:RegisterEffect(e2)
	 end
end
--效果1
function cm.atlimit(e,re)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and e:GetHandler():GetColumnGroup():IsContains(tc) and tc:IsAttackBelow(e:GetHandler():GetAttack())
end
function cm.actcon(e,tp)
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(33350001) and c:IsFaceup()
end
function cm.attack(e,c)
	if not c:IsFaceup() then return end
	return e:GetHandler():GetColumnGroup():IsContains(c)
end