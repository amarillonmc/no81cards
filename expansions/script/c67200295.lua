--封缄的先锋队
function c67200295.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200295,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200295)
	e1:SetCost(c67200295.setcost)
	e1:SetTarget(c67200295.settg)
	e1:SetOperation(c67200295.setop)
	c:RegisterEffect(e1)   
	--direct attack!
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200295,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c67200295.spcost)
	e3:SetTarget(c67200295.sptg)
	e3:SetOperation(c67200295.spop)
	c:RegisterEffect(e3)   
end
--
function c67200295.stfilter1(c)
	return c:IsFaceup() and c:IsCode(67200284) and c:IsReleasable()
end
function c67200295.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200295.stfilter1,tp,LOCATION_ONFIELD,0,1,c) end
	local sg=Duel.SelectMatchingCard(tp,c67200295.stfilter1,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.Release(sg,REASON_COST)
end
function c67200295.setfilter(c)
	return c:IsSetCard(0x674) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable()
end
function c67200295.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200295.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c67200295.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c67200295.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
--
function c67200295.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c67200295.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67200295.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x674))
	e1:SetValue(500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end