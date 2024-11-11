--闪蝶幻乐曲-『日光』
function c9911456.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9911456.target)
	e1:SetOperation(c9911456.activate)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9911456.splimit)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9911456)
	e3:SetTarget(c9911456.thtg)
	e3:SetOperation(c9911456.thop)
	c:RegisterEffect(e3)
end
function c9911456.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function c9911456.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function c9911456.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c9911456.cfilter(c,cd)
	return c:IsFaceup() and c:IsCode(cd)
end
function c9911456.thfilter(c,tp)
	return c:IsSetCard(0x3952) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(c9911456.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c9911456.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=0
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SET_SUMMON_COUNT_LIMIT)}
		for _,te in ipairs(ce) do
			ct=math.max(ct,te:GetValue())
		end
		return ct<2 and Duel.IsExistingMatchingCard(c9911456.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9911456.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911456.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local hc=g:GetFirst()
	if hc and Duel.SendtoHand(hc,nil,REASON_EFFECT)~=0 and hc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
		local tc=tg:GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(2)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
