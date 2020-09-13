--六道忍龙 六色罗汉
function c40009151.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--setcode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetValue(0x61)
	c:RegisterEffect(e1)  
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009151,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c40009151.negcon)
	e2:SetCost(c40009151.cost1)
	e2:SetTarget(c40009151.negtg)
	e2:SetOperation(c40009151.negop)
	c:RegisterEffect(e2)   
end
function c40009151.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and ep~=tp and re:GetActivateLocation()==LOCATION_HAND and Duel.IsChainNegatable(ev)
end
function c40009151.cfilter1(c,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2b) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c40009151.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,c)
end
function c40009151.cfilter2(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x61) and c:IsAbleToGraveAsCost()
end
function c40009151.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009151.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c40009151.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	local cc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c40009151.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,cc,cc)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c40009151.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct>0 and aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,ct)
end
function c40009151.negop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if Duel.NegateActivation(ev) then
	   Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end