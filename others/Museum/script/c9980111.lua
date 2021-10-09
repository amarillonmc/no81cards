--守护女神·诺瓦露
function c9980111.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9980111.splimit)
	c:RegisterEffect(e2)
	--destroy and set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980111,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9980111)
	e1:SetCondition(c9980111.con1)
	e1:SetTarget(c9980111.target)
	e1:SetOperation(c9980111.operation)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e5:SetCondition(c9980111.con2)
	c:RegisterEffect(e5)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xbc8))
	e2:SetValue(c9980111.val1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetValue(c9980111.val2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetValue(c9980111.val3)
	c:RegisterEffect(e4)
end
function c9980111.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xbc8) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c9980111.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9980121)
end
function c9980111.con2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) and Duel.IsPlayerAffectedByEffect(tp,9980121)
end
function c9980111.desfilter(c,tp)
	if c:IsFacedown() then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 then
		return Duel.IsExistingMatchingCard(c9980111.filter,tp,LOCATION_DECK,0,1,nil,true)
	else
		return Duel.IsExistingMatchingCard(c9980111.filter,tp,LOCATION_DECK,0,1,nil,false)
	end
end
function c9980111.filter(c,ignore)
	return c:IsSetCard(0xbc8) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(ignore)
end
function c9980111.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9980111.desfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c9980111.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9980111.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9980111.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c9980111.filter,tp,LOCATION_DECK,0,1,1,nil,false)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c9980111.val1(e,c)
	return c:GetLevel()*100 
end
function c9980111.val2(e,c)
	return c:GetRank()*100
end
function c9980111.val3(e,c)
	return c:GetLink()*200
end