--桃绯巫女 闲仓五十铃
function c9910530.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910530)
	e1:SetTarget(c9910530.thtg)
	e1:SetOperation(c9910530.thop)
	c:RegisterEffect(e1)
	--remove & draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,9910531)
	e2:SetTarget(c9910530.rmtg)
	e2:SetOperation(c9910530.rmop)
	c:RegisterEffect(e2)
end
function c9910530.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa950) and c:IsAbleToHand()
end
function c9910530.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9910530.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910530.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9910530.thfilter,tp,LOCATION_ONFIELD,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9910530.lvfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsLevelAbove(4)
end
function c9910530.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	while ct>0 do
		local lg=Duel.GetMatchingGroup(c9910530.lvfilter,tp,LOCATION_HAND,0,nil)
		if lg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910530,0)) then
			Duel.BreakEffect()
			local tc=lg:Select(tp,1,1,nil):GetFirst()
			if tc then
				Duel.ConfirmCards(1-tp,tc)
				Duel.ShuffleHand(tp)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetValue(-2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
			ct=ct-1
		else
			ct=0
		end
	end
end
function c9910530.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c9910530.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c9910530.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910530.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9910530.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil,id)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9910530.filter(c)
	return c:IsSetCard(0xa950) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
		and c:IsLocation(LOCATION_REMOVED)
end
function c9910530.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	local ct=Duel.GetOperatedGroup():FilterCount(c9910530.filter,nil)
	if ct>0 and Duel.IsPlayerCanDraw(tp,ct) and Duel.SelectYesNo(tp,aux.Stringid(9910530,1)) then
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
