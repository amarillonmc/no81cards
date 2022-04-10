--业炎的魔神 Astaroth
function c33200020.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion procedure
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,c33200020.ffilter1,c33200020.ffilter2,c33200020.ffilter2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6830480,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c33200020.atktg)
	e1:SetOperation(c33200020.atkop)
	c:RegisterEffect(e1)
	--disable special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200020,1))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33200020)
	e2:SetCondition(c33200020.discon)
	e2:SetCost(c33200020.discost)
	e2:SetTarget(c33200020.distg)
	e2:SetOperation(c33200020.disop)
	c:RegisterEffect(e2)
	--to p
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)   
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,33200021)
	e3:SetCondition(c33200020.tpcon)
	e3:SetTarget(c33200020.tptg)
	e3:SetOperation(c33200020.tpop)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(c33200020.tpcon)
	e4:SetTarget(c33200020.target)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end

--fusion
function c33200020.ffilter2(c)
	return c:IsSetCard(0x321)
end
function c33200020.ffilter1(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_FUSION)
end

--e1
function c33200020.atkfilter(c)
	return c:IsFaceup() and not c:IsAttack(0)
end
function c33200020.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200020.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c33200020.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33200020.atkfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-300)
		tc:RegisterEffect(e1)
		if tc:IsAttack(0) then Duel.Destroy(tc,REASON_EFFECT) end
	end
end

--e4 e5
function c33200020.target(e,c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end

--e2
function c33200020.refilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsReleasable()
end
function c33200020.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c33200020.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200020.refilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c33200020.refilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c33200020.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,eg:GetCount(),0,0)
end
function c33200020.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoHand(eg,nil,REASON_EFFECT)
end

--e4
function c33200020.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsFaceup() and c:IsPreviousLocation(LOCATION_MZONE)
end
function c33200020.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c33200020.tpop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end