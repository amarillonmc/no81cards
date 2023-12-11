--翼冠主·阿尔蒂玛媞娅
function c11570008.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.NonTuner(nil),1)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11570008,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11570008)
	e1:SetCondition(c11570008.thcon)
	e1:SetTarget(c11570008.thtg)
	e1:SetOperation(c11570008.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c11570008.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c11570008.chainop)
	c:RegisterEffect(e3)
end
function c11570008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c11570008.thfilter(c)
	return c:IsSetCard(0x810) and c:IsAbleToHand()
end
function c11570008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11570008.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c11570008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11570008.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11570008.tglimit(e,c)
	return c:IsSetCard(0x810) and c~=e:GetHandler()
end
function c11570008.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsType(TYPE_MONSTER) and ep==tp and re:GetHandler():IsSetCard(0x810) and Duel.GetFlagEffect(tp,11570008)==0
		and Duel.SelectYesNo(tp,aux.Stringid(11570008,1)) then
		Duel.SetChainLimit(c11570008.chainlm)
		Duel.RegisterFlagEffect(tp,11570008,RESET_PHASE+PHASE_END,0,1)
	end
end
function c11570008.chainlm(e,rp,tp)
	return tp==rp or e:GetHandler():IsSetCard(0x810)
end