--暗黑超级运动员 狂暴四分卫
function c40008783.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40008783)
	e1:SetCondition(c40008783.spcon)
	e1:SetOperation(c40008783.spop)
	c:RegisterEffect(e1)  
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008783,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCountLimit(1,40008784)
	e2:SetCondition(c40008783.atkcon1)
	e2:SetCost(c40008783.cost)
	e2:SetOperation(c40008783.operation)
	c:RegisterEffect(e2) 
end
function c40008783.spfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0xb2) and not c:IsCode(40008783) and c:IsAbleToHandAsCost()
		and (ft>0 or c:GetSequence()<5)
end
function c40008783.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c40008783.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,ft)
end
function c40008783.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c40008783.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c40008783.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker()
end
function c40008783.cfilter2(c)
	return c:IsSetCard(0xb2) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c40008783.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008783.cfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c40008783.cfilter2,tp,LOCATION_HAND,0,1,63,nil)
	Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
	e:SetLabel(cg:GetSum(Card.GetAttack))
end
function c40008783.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end