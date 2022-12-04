--噩梦回廊的误入者
function c67200753.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--set field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200753,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCountLimit(1,67200753)
	e2:SetTarget(c67200753.sttg)
	e2:SetOperation(c67200753.stop)
	c:RegisterEffect(e2)
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200753,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,67200753)
	e3:SetCondition(c67200753.cecondition)
	e3:SetTarget(c67200753.cetarget)
	e3:SetOperation(c67200753.ceoperation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c67200753.cecon2)
	c:RegisterEffect(e4)	
end
--
function c67200753.plfilter1(c)
	return c:IsSetCard(0x67d) and not c:IsForbidden()
end

function c67200753.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c67200753.plfilter1,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and g:GetCount()>0 end
end
function c67200753.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67200753.plfilter1,tp,LOCATION_DECK,0,1,1,nil)
	g:AddCard(c)
	local tc=g:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67200753,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
--
function c67200753.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end
function c67200753.cfilter(c)
	return c:IsFaceup() and c:IsCode(67200755)
end
function c67200753.cecondition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and Duel.IsExistingMatchingCard(c67200753.cfilter,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c67200753.cetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67200753.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c67200753.repop)
end
--
function c67200753.cecon2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and Duel.IsExistingMatchingCard(c67200753.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerAffectedByEffect(tp,67200755)
end


