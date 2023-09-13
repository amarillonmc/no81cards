--沉默巫师
function c98920556.initial_effect(c)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920556,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,98920556)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920556.drcon)
	e2:SetTarget(c98920556.drtg)
	e2:SetOperation(c98920556.drop)
	c:RegisterEffect(e2)
end
function c98920556.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_EFFECT)
end
function c98920556.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920556.cfilter,1,nil,1-tp)
end
function c98920556.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98920556.spfilter(c,e,tp)
	return (c:IsSetCard(0xe7,0xe8) or c:IsCode(19502505)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98920556.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT) and e:GetHandler():IsLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(c98920556.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(98920556,2)) then
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920556.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 then
		   Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end