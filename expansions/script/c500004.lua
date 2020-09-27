--千金女佣 千夜
function c500004.initial_effect(c)
	--race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetValue(RACE_FAIRY)
	c:RegisterEffect(e1)
	--Trap activate in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c500004.tg)
	e2:SetTargetRange(LOCATION_SZONE,0)
	c:RegisterEffect(e2)
	--To Hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_RELEASE)
	e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e4:SetCountLimit(1,500004)
	e4:SetCost(c500004.cost)
	e4:SetTarget(c500004.target)
	e4:SetOperation(c500004.operation)
	c:RegisterEffect(e4)
end
function c500004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c500004.filter1(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSummonable(true,nil)
end
function c500004.filter2(c)
	return c:IsReason(REASON_RELEASE) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c500004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c500004.filter1,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c500004.filter2,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(500004,1),aux.Stringid(500004,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(500004,1))
	else op=Duel.SelectOption(tp,aux.Stringid(500004,2))+1 end
	e:SetLabel(op)
	if op==0 then
	   Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	end
end
function c500004.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	   local g=Duel.SelectMatchingCard(tp,c500004.filter1,tp,LOCATION_HAND,0,1,1,nil)
	   if g:GetCount()>0 then
		  Duel.Summon(tp,g:GetFirst(),true,nil)
	   end
	else
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	   local g=Duel.SelectMatchingCard(tp,c500004.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	   if g:GetCount()>0 then
		  Duel.SSet(tp,g:GetFirst())
		  Duel.ConfirmCards(1-tp,g)
	   end
	end
end
function c500004.tg(e,c)
	return c:IsSetCard(0xffac) or c:IsSetCard(0xffad)
end