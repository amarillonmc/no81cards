--魔餐餐刀
function c51930004.initial_effect(c)
	c:EnableReviveLimit()
	--ritual
	local e1=aux.AddRitualProcEqual2(c,c51930004.rfilter,LOCATION_HAND+LOCATION_GRAVE,nil,c51930004.mfilter,true)
	e1:SetDescription(1168)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(0)
	e1:SetCountLimit(1,51930004)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c51930004.rscost)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,51930005)
	e2:SetCondition(c51930004.tgcon)
	e2:SetTarget(c51930004.tgtg)
	e2:SetOperation(c51930004.tgop)
	c:RegisterEffect(e2)
end
function c51930004.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
end
function c51930004.rfilter(c,e,tp,chk)
	return c~=e:GetHandler()
end
function c51930004.mfilter(c,e,tp,chk)
	return c:IsSetCard(0x5258)
end
function c51930004.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c51930004.tgfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c51930004.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51930004.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c51930004.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c51930004.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
