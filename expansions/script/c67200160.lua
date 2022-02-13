--天秤的裁决者 阿斯特莱雅
function c67200160.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum
	aux.EnablePendulumAttribute(c,false)
	--Synchro meterial
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_PENDULUM),aux.NonTuner(Card.IsSynchroType,TYPE_PENDULUM),1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200160)
	e1:SetCondition(c67200160.spcon)
	e1:SetTarget(c67200160.sptg)
	e1:SetOperation(c67200160.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200160,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c67200160.condition)
	e2:SetTarget(c67200160.target)
	e2:SetOperation(c67200160.operation)
	c:RegisterEffect(e2)  
	--summon word
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c67200160.txtcon)
	e3:SetOperation(c67200160.txtop)
	c:RegisterEffect(e3)
	--pendulum 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200160,2))
	e4:SetCategory(CATEGORY_RELEASE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c67200160.pencon)
	e4:SetTarget(c67200160.pentg)
	e4:SetOperation(c67200160.penop)
	c:RegisterEffect(e4)
c67200160.pendulum_level=10
end
--pendulum effect
function c67200160.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_PENDULUM)
end
function c67200160.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200160.cfilter,1,nil,tp)
end
function c67200160.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200160.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--negate
function c67200160.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c67200160.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,tc:GetBaseAttack())
end
function c67200160.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re)  and rc:GetBaseAttack()>=0
		and c:IsRelateToEffect(e) then
		local tc=eg:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
		end
	end
end
--summon TXT
function c67200160.txtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c67200160.txtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(67200160,3))
	Duel.Hint(24,0,aux.Stringid(67200160,4))
end
--go to P zone
function c67200160.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c67200160.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eeg=Duel.GetMatchingGroupCount(Card.IsReleasable,tp,LOCATION_PZONE,LOCATION_PZONE,nil)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,LOCATION_PZONE)>0 and eeg>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,g:GetCount(),0,0)
end
function c67200160.penop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	if Duel.Release(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
