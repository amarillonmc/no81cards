--魔餐餐勺
function c51930008.initial_effect(c)
	c:EnableReviveLimit()
	--ritual
	local e1=aux.AddRitualProcEqual2(c,c51930008.rfilter,LOCATION_HAND+LOCATION_GRAVE,nil,c51930008.mfilter,true)
	e1:SetDescription(1168)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(0)
	e1:SetCountLimit(1,51930008)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c51930008.rscost)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,51930009)
	e2:SetCondition(c51930008.thcon)
	e2:SetTarget(c51930008.thtg)
	e2:SetOperation(c51930008.thop)
	c:RegisterEffect(e2)
end
function c51930008.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
end
function c51930008.rfilter(c,e,tp,chk)
	return c~=e:GetHandler()
end
function c51930008.mfilter(c,e,tp,chk)
	return c:IsSetCard(0x5258)
end
function c51930008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c51930008.thfilter(c)
	return c:IsSetCard(0x5258) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c51930008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51930008.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c51930008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c51930008.thfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
