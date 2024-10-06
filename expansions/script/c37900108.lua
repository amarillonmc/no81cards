--Seto
function c37900108.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,37900108)
	e1:SetCondition(c37900108.con)
	e1:SetTarget(c37900108.tg)
	e1:SetOperation(c37900108.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c37900108.tg2)
	e2:SetOperation(c37900108.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c37900108.op3)
	c:RegisterEffect(e3)
end
function c37900108.q(c)
	return c:IsFaceup() and not c:IsCode(37900108) and c:IsSetCard(0x382)
end
function c37900108.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37900108.q,tp,4,0,1,nil)
end
function c37900108.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c37900108.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c37900108.w(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable()
end
function c37900108.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(c37900108.w,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if chk==0 then return #g1>0 and (#g2>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function c37900108.op2(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(c37900108.w,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local x1,x2=false,false
	if #g1>0 then x1=true end
	if #g2>0 then x2=true end
	local op=aux.SelectFromOptions(tp,{x1,aux.Stringid(37900108,0),0},{x2,aux.Stringid(37900108,1),1})
	if op==nil then return end
	if op==0 then
		Duel.Hint(3,tp,HINTMSG_ATOHAND)
		local g=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif op==1 then
		Duel.Hint(3,tp,HINTMSG_SET)
		local g=g2:Select(tp,1,1,nil)
		Duel.SSet(tp,g:GetFirst(),tp,true)
	end
end
function c37900108.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:GetControler()~=c:GetOwner() then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMOVE_BRAINWASHING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	end
end