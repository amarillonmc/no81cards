--伯吉斯异兽·西德尼虫
function c98920418.initial_effect(c)
	aux.AddLinkProcedure(c,c98920418.matfilter,2,2)
	c:EnableReviveLimit()
--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c98920418.efilter)
	c:RegisterEffect(e1)
--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920418,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetTarget(c98920418.thtg)
	e1:SetOperation(c98920418.thop)
	c:RegisterEffect(e1)
--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c98920418.spcon)
	e4:SetTarget(c98920418.sptg)
	e4:SetOperation(c98920418.spop)
	c:RegisterEffect(e4)
end
function c98920418.matfilter(c)
	return c:GetOriginalType()&TYPE_TRAP>0
end
function c98920418.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()
end
function c98920418.filter(c)
	return c:IsSetCard(0xd4) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c98920418.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c98920418.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c98920418.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c98920418.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SSet(tp,tc)
end
function c98920418.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c98920418.thfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c98920418.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920418.thfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c98920418.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920418.thfilter),tp,LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end