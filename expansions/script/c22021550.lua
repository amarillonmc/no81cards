--人理之诗 残食我心吧，月之光
function c22021550.initial_effect(c)
	aux.AddCodeList(c,22021540)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c22021550.e1tg)
	e1:SetOperation(c22021550.e1op)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(22021550,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c22021550.cost)
	e2:SetTarget(c22021550.thtg)
	e2:SetOperation(c22021550.thop)
	c:RegisterEffect(e2)
end
function c22021550.e1tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c22021550.e1tgfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c22021550.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c22021550.e1tgfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingTarget(c22021550.e1tgfilter2,tp,0,LOCATION_MZONE,1,nil) end
	local a=Duel.GetMatchingGroup(c22021550.e1tgfilter,tp,LOCATION_MZONE,0,nil)
	local b=Duel.GetMatchingGroup(c22021550.e1tgfilter2,tp,0,LOCATION_MZONE,nil)
	local ca=a:GetCount()
	local cb=b:GetCount()
	if ca>cb then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22021550,0))
		local ga=Duel.SelectTarget(tp,c22021550.e1tgfilter,tp,LOCATION_MZONE,0,1,cb,nil)
		local gca=ga:GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22021550,1))
		local gb=Duel.SelectTarget(tp,c22021550.e1tgfilter2,tp,0,LOCATION_MZONE,gca,gca,nil)
		local g0=Group.CreateGroup()
		Group.Merge(g0,ga)
		Group.Merge(g0,gb)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g0,g0:GetCount(),0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22021550,0))
		local ga=Duel.SelectTarget(tp,c22021550.e1tgfilter,tp,LOCATION_MZONE,0,1,ca,nil)
		local gca=ga:GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22021550,1))
		local gb=Duel.SelectTarget(tp,c22021550.e1tgfilter2,tp,0,LOCATION_MZONE,gca,gca,nil)
		local g0=Group.CreateGroup()
		Group.Merge(g0,ga)
		Group.Merge(g0,gb)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g0,g0:GetCount(),0,0)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c22021550.e1opfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c22021550.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	g=g:Filter(c22021550.e1opfilter,nil,e)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function c22021550.costfilter(c,tp)
	return c:IsFaceup() and c:IsCode(22021540) and Duel.GetMZoneCount(tp,c)>0
end
function c22021550.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22021550.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c22021550.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c22021550.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c22021550.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end