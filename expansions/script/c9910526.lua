--桃绯巫女 八岐雪花
function c9910526.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c9910526.atkval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910526.discon)
	e2:SetCost(c9910526.discost)
	e2:SetTarget(c9910526.distg)
	e2:SetOperation(c9910526.disop)
	c:RegisterEffect(e2)
	--remove & destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,9910526)
	e3:SetTarget(c9910526.rmtg)
	e3:SetOperation(c9910526.rmop)
	c:RegisterEffect(e3)
end
function c9910526.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa950) and c:GetLevel()>=0
end
function c9910526.atkval(e)
	local lg=Duel.GetMatchingGroup(c9910526.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return lg:GetSum(Card.GetLevel)*-50
end
function c9910526.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and rc:IsFaceup() and not rc:IsAttack(rc:GetBaseAttack())
		and Duel.IsChainNegatable(ev)
end
function c9910526.costfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c9910526.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c9910526.costfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c9910526.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c9910526.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c9910526.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c9910526.rmfilter1(c)
	return c:IsSetCard(0xa950) and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemove()
end
function c9910526.rmfilter2(c)
	return c:IsSetCard(0xa950) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c9910526.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9910526.rmfilter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c9910526.rmfilter2,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c9910526.rmfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c9910526.rmfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g3,1,0,0)
end
function c9910526.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,2,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
	end
end
