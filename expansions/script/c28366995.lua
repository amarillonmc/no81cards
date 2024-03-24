--闪耀的六出花 繁花幸福论
function c28366995.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c28366995.matfilter1,nil,nil,aux.NonTuner(Card.IsSetCard,0x283),1,1)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,28366995)
	e1:SetCondition(c28366995.recon)
	e1:SetTarget(c28366995.retg)
	e1:SetOperation(c28366995.reop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,28366995)
	e2:SetCondition(c28366995.thcon)
	e2:SetTarget(c28366995.thtg)
	e2:SetOperation(c28366995.thop)
	c:RegisterEffect(e2)
end
function c28366995.matfilter1(c,syncard)
	return c:IsTuner(syncard) or (c:IsSetCard(0x287) and Duel.GetLP(c:GetControler())>=9000)
end
function c28366995.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c28366995.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c28366995.cfilter(c)
	return c:IsAbleToHand() and c:IsLocation(LOCATION_GRAVE)
end
function c28366995.reop(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	if Duel.Recover(tp,1000,REASON_EFFECT)>0 and Duel.GetLP(tp)>=10000 and mg:IsExists(c28366995.cfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28366995,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=mg:Filter(c28366995.cfilter,nil):Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c28366995.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=9000
end
function c28366995.thfilter(c)
	return c:IsSetCard(0x287,0x289) and c:IsAbleToHand()
end
function c28366995.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28366995.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28366995.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c28366995.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tg)
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-2000)
	end
end
