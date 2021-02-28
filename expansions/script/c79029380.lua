--编外干员-其空葵·力量解放
function c79029380.initial_effect(c)
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029380,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,79029380)
	e2:SetTarget(c79029380.thtg)
	e2:SetOperation(c79029380.thop)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)  
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1,09029380)
	e4:SetCondition(c79029380.sumcon)
	e4:SetTarget(c79029380.sumtg)
	e4:SetOperation(c79029380.sumop)
	c:RegisterEffect(e4)
end
function c79029380.thfil(c)
	return c:IsAbleToHand() and c:IsCode(79029372)
end
function c79029380.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029380.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end
function c79029380.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029380.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil) 
	if g:GetCount()<=0 then return end
	local tg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(tg,tp,REASON_EFFECT)
	Duel.ConfirmCards(tp,tg)
	if Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) and Duel.SelectYesNo(tp,aux.Stringid(79029380,0)) then
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(79029380,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(c79029380.val)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function c79029380.val(e,c)
	return c:IsSetCard(0xa900) or c:IsSetCard(0x87af)
end
function c79029380.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SUMMON) and Duel.GetTurnPlayer()==tp and (e:GetHandler():GetReasonCard():IsSetCard(0xa900) or e:GetHandler():GetReasonCard():IsSetCard(0x87af))
end
function c79029380.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79029380.sumop(e,tp,eg,ep,ev,re,r,rp)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x87af))
	e1:SetValue(0xa900)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end









