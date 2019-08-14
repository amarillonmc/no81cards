--├腹心反击┤
function c60151197.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCountLimit(1,60151197)
	e1:SetCondition(c60151197.condition)
	e1:SetTarget(c60151197.target)
	e1:SetOperation(c60151197.activate)
	c:RegisterEffect(e1)
	local e12=e1:Clone()
	e12:SetCode(EVENT_BECOME_TARGET)
	c:RegisterEffect(e12)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151197,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,60151197)
	e2:SetCondition(c60151197.drcon)
	e2:SetTarget(c60151197.drtg)
	e2:SetOperation(c60151197.drop)
	c:RegisterEffect(e2)
end
function c60151197.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x9b23) and tc:IsType(TYPE_MONSTER) and tc:IsLocation(LOCATION_MZONE)
end
function c60151197.tgfilter(c)
	return c:IsAbleToGrave()
end
function c60151197.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151197.tgfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c60151197.activate(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.ConfirmCards(tp,g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60151197.tgfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			local g3=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
			local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
			if g3:GetCount()>0 and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151197,0)) then 
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g1:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_EFFECT)
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local sg2=g3:Select(1-tp,1,1,nil)
				Duel.HintSelection(sg2)
				Duel.SendtoGrave(sg2,REASON_RULE)
			end
		end
	end
	Duel.ShuffleHand(1-tp)
end
function c60151197.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c60151197.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60151197.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end