--临魔世计
function c33310153.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c33310153.spcon)
	e1:SetOperation(c33310153.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--linmo
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33310153.con)
	e2:SetCost(c33310153.cost)
	e2:SetCountLimit(1)
	e2:SetTarget(c33310153.tg)
	e2:SetOperation(c33310153.op)
	c:RegisterEffect(e2)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c33310153.flagop)
	c:RegisterEffect(e5)
	local e4=e5:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	c33310153[c]=e2
end
function c33310153.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(33310153)~=0
end
function c33310153.flagop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(33310153,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
end
function c33310153.costfil(c)
	return c:IsSetCard(0x55b) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function c33310153.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310153.costfil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c33310153.costfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c33310153.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
end
function c33310153.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

function c33310153.filter(c)
	return c:IsSetCard(0x55b) and c:IsSummonable(true,nil)
end
function c33310153.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33310153.filter,tp,LOCATION_HAND,0,1,nil) and Duel.GetFlagEffect(tp,33310153)==0
end
function c33310153.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(33310153,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33310153.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Summon(tp,g:GetFirst(),true,nil)
	Duel.RegisterFlagEffect(tp,33310153,RESET_PHASE+PHASE_END,0,1)
end