--飘摇之星宿 塞拉斯塔布
function c9910297.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910297)
	e1:SetCost(c9910297.sumcost)
	e1:SetTarget(c9910297.sumtg)
	e1:SetOperation(c9910297.sumop)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c9910297.chainop)
	c:RegisterEffect(e2)
end
function c9910297.filter(c,tp)
	local lv=c:GetLevel()
	return not c:IsPublic() and lv>0 and Duel.IsExistingMatchingCard(c9910297.tgfilter,tp,LOCATION_DECK,0,1,nil,lv)
end
function c9910297.tgfilter(c,lv)
	return c:IsLevel(lv+1,lv-1) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGraveAsCost()
end
function c9910297.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910297.filter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9910297.filter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local lv=g:GetFirst():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c9910297.tgfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	Duel.SendtoGrave(tg,REASON_COST)
end
function c9910297.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c9910297.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pos=0
	if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 then return end
	if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,c,true,nil,1)
	else
		Duel.MSet(tp,c,true,nil,1)
	end
end
function c9910297.chainop(e,tp,eg,ep,ev,re,r,rp)
	if tp~=Duel.GetTurnPlayer() or ep~=tp then return end
	if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_SPELLCASTER) then
		Duel.SetChainLimit(c9910297.chainlm1)
	end
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		Duel.SetChainLimit(c9910297.chainlm2)
	end
end
function c9910297.chainlm(re,rp,tp)
	return tp==rp or not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9910297.chainlm2(re,rp,tp)
	return tp==rp or not re:IsActiveType(TYPE_MONSTER)
end
