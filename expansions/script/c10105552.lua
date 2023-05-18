--深渊
function c10105552.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10105552+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c10105552.activate)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10105552.reccon)
	e2:SetOperation(c10105552.recop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c10105552.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7cdd) and c:IsAbleToHand()
end
function c10105552.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10105552.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10105552,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c10105552.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c10105552.etfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7cdd)
end
function c10105552.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10105552.cfilter,1,nil,1-tp) and Duel.IsExistingMatchingCard(c10105552.etfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10105552.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10105552)
	Duel.Recover(tp,300,REASON_EFFECT)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end