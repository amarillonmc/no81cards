--混沌的预感 晓美焰
function c60151004.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,60151004)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetTarget(c60151004.distg)
	e1:SetOperation(c60151004.disop)
	c:RegisterEffect(e1)
	--spsum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151004,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,6011004)
	e2:SetCondition(c60151004.condition)
	e2:SetCost(c60151004.cost)
	e2:SetTarget(c60151004.target)
	e2:SetOperation(c60151004.operation)
	c:RegisterEffect(e2)
end
function c60151004.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function c60151004.discon2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and e:GetHandler():GetOriginalRace()==RACE_SPELLCASTER
end
function c60151004.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=Duel.SelectOption(tp,aux.Stringid(60151002,2),aux.Stringid(60151002,3))
	e:SetLabel(opt)
	Duel.SetChainLimit(aux.FALSE)
end
function c60151004.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 and c:IsAbleToHand() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	else
		--negate
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60151001,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetOperation(c60151004.disop3)
		c:RegisterEffect(e1)
	end
end
function c60151004.disop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c60151004.chlimit)
end
function c60151004.chlimit(e,ep,tp)
	return tp==ep
end
function c60151004.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60151004.disop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60151004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c60151004.filter2(c,e,tp)
	return c:IsSetCard(0x5b23) and c:IsType(TYPE_MONSTER) and not c:IsCode(60151004) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151004.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151004.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60151004.filter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end