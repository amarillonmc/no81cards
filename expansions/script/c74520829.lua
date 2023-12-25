--卢纳魔术使·迪安娜
function c74520829.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,74546765,c74520829.matfilter,1,true,true)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74520829,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,74520829)
	e1:SetCondition(c74520829.thcon)
	e1:SetTarget(c74520829.thtg)
	e1:SetOperation(c74520829.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,84520829)
	e2:SetCost(c74520829.spcost)
	e2:SetTarget(c74520829.sptg)
	e2:SetOperation(c74520829.spop)
	c:RegisterEffect(e2)
end
function c74520829.matfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsLocation(LOCATION_MZONE)
end
function c74520829.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c74520829.thfilter(c)
	return c:IsSetCard(0x745) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c74520829.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74520829.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c74520829.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c74520829.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c74520829.filter(c,e,tp)
	return not c:IsPublic() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER)
		and Duel.IsExistingMatchingCard(c74520829.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c74520829.spfilter(c,e,tp,pc)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevel(pc:GetLevel()) and not c:IsCode(pc:GetCode())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c74520829.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c74520829.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c74520829.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c74520829.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c74520829.spop(e,tp,eg,ep,ev,re,r,rp)
	local pc=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or pc==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c74520829.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,pc):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if tc:IsType(TYPE_DUAL) then
			tc:EnableDualState()
		end
	end
end
