--
function c67200752.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--set field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200752,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,67200752)
	e2:SetCost(c67200752.stcost)
	e2:SetTarget(c67200752.sttg)
	e2:SetOperation(c67200752.stop)
	c:RegisterEffect(e2)  
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200752,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,67200752)
	e3:SetCondition(c67200752.cecondition)
	e3:SetTarget(c67200752.cetarget)
	e3:SetOperation(c67200752.ceoperation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c67200752.cecon2)
	c:RegisterEffect(e4)	 
end
--
function c67200752.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoExtraP(c,tp,REASON_COST)
end
function c67200752.psfilter(c)
	return c:IsSetCard(0x67d) and c:IsType(TYPE_TRAP) and not c:IsForbidden()
end
function c67200752.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c67200752.psfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c67200752.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200752.psfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
--
function c67200752.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end
function c67200752.cfilter(c)
	return c:IsFaceup() and c:IsCode(67200755)
end
function c67200752.cecondition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and Duel.IsExistingMatchingCard(c67200752.cfilter,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c67200752.cetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67200752.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c67200752.repop)
end
--
function c67200752.cecon2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and Duel.IsExistingMatchingCard(c67200752.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerAffectedByEffect(tp,67200755)
end
