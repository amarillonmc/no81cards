--Nameless 鹿乃
function c75646403.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646403,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75646403)
	e1:SetCost(c75646403.cost)
	e1:SetTarget(c75646403.sptg)
	e1:SetOperation(c75646403.spop)
	c:RegisterEffect(e1)
	--tohand (self)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetTargetRange(1,0)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,7564643)
	e2:SetCost(c75646403.thcost)
	e2:SetCondition(c75646403.con)
	e2:SetTarget(c75646403.tg)
	e2:SetOperation(c75646403.op)
	c:RegisterEffect(e2)
end
function c75646403.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c75646403.filter1(c,e,tp)
	return not c:IsType(TYPE_XYZ) and c:IsAbleToGraveAsCost()
end
function c75646403.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646403.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75646403.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646403.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75646403.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(e:GetLabel())
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c75646403.cfilter(c)
	return c:IsReason(REASON_COST)
end
function c75646403.con(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(0x7f0) and eg:IsExists(c75646403.cfilter,1,nil) and re:GetHandler():IsSetCard(0x32c4) and e:GetHandler():GetFlagEffect(1)>0
end
function c75646403.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c75646403.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,2,REASON_EFFECT)
	end
end