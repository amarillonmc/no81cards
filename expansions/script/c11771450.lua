--死魂驭者 赛斯
function c11771450.initial_effect(c)
	c:SetSPSummonOnce(11771450)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11771450.matfilter,1,1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11771450,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11771450)
	e1:SetCondition(c11771450.thcon1)
	e1:SetTarget(c11771450.thtg1)
	e1:SetOperation(c11771450.thop1)
	c:RegisterEffect(e1)
end
function c11771450.matfilter(c)
	return c:GetOriginalRace()&(RACE_ZOMBIE)>0 and not c:IsType(TYPE_TUNER)
end
function c11771450.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11771450.thfilter1(c)
	return c:IsCode(11771455) and c:IsAbleToHand()
end
function c11771450.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11771450.thfilter1,tp,0x11,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x11)
end
function c11771450.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11771450.thfilter1),tp,0x11,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end