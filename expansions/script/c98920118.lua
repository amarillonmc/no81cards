--巨大战舰-旋核
function c98920118.initial_effect(c)
	c:EnableCounterPermit(0x1f)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98920118.spcon)
	e1:SetOperation(c98920118.spop)
	c:RegisterEffect(e1)
--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920118,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c98920118.cttg)
	e2:SetOperation(c98920118.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
 --remove counter
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920118,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetCondition(aux.dsercon)
	e5:SetTarget(c98920118.rcttg)
	e5:SetOperation(c98920118.rctop)
	c:RegisterEffect(e5)
--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920118,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c98920118.atkcost2)
	e2:SetOperation(c98920118.atkop2)
	c:RegisterEffect(e2)
end
function c98920118.spfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToGraveAsCost()
end
function c98920118.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920118.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c98920118.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920118.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98920118.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x1f)
end
function c98920118.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1f,2)
	end
end
function c98920118.rcttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not e:GetHandler():IsCanRemoveCounter(tp,0x1f,1,REASON_EFFECT) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function c98920118.rctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if c:IsCanRemoveCounter(tp,0x1f,1,REASON_EFFECT) then
			c:RemoveCounter(tp,0x1f,1,REASON_EFFECT)
		else
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
function c98920118.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(98920118)==0 end
	c:RegisterFlagEffect(98920118,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c98920118.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=c:GetAttack()*2
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_DISABLE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end