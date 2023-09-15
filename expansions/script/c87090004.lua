--端午节的虫师
function c87090004.initial_effect(c)
	  --todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87090004,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,87090004)
	e1:SetCondition(c87090004.descon)
	e1:SetCost(c87090004.cost)  
	e1:SetTarget(c87090004.destg)
	e1:SetOperation(c87090004.desop)
	c:RegisterEffect(e1)  
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xafa))
	e4:SetValue(c87090004.value)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)

end
function c87090004.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousSequence()<5
end
function c87090004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c87090004.desfilter(c)
	return (c:IsFacedown() or not c:IsSetCard(0xafa)) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c87090004.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87090004.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c87090004.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c87090004.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c87090004.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c87090004.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xafa)
end
function c87090004.value(e,c)
	return Duel.GetMatchingGroupCount(c87090004.atkfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*100
end









