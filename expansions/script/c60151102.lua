--艾奇军团 随想者
function c60151102.initial_effect(c)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151101,2))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,6011102)
	e1:SetTarget(c60151102.cointg)
	e1:SetOperation(c60151102.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151102,3))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,60151102)
	e3:SetCondition(c60151102.spcon)
	e3:SetTarget(c60151102.sptg)
	e3:SetOperation(c60151102.spop)
	c:RegisterEffect(e3)
end
c60151102.toss_coin=true
function c60151102.coincon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(60151199)
end
function c60151102.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(60151199)
end
function c60151102.cointgf(c)
	return c:IsFaceup() or c:IsFacedown()
end
function c60151102.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151102.chlimit)
		Duel.RegisterFlagEffect(tp,60151102,RESET_CHAIN,0,1)
	else
		e:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c60151102.chlimit(e,ep,tp)
	return tp==ep
end
function c60151102.filter(c)
	return c:IsDestructable()
end
function c60151102.filter2(c)
	return c:IsAbleToGrave()
end
function c60151102.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=0
	if Duel.GetFlagEffect(tp,60151102)>0 then
		res=1
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c60151102.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
	if res==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c60151102.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if Duel.Destroy(g,REASON_EFFECT)~=0 then 
				local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
				if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151101,0)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local sg=g2:Select(tp,1,1,nil)
					Duel.SendtoGrave(sg,REASON_EFFECT)
				end
			end
		end
	end
end
function c60151102.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler()~=e:GetHandler()
end
function c60151102.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151102.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT) then
		local g8=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		if g8:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151101,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g8:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end