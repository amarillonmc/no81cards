--圆环魔女爆发
function c75081162.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75081162+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75081162.destg)
	e1:SetOperation(c75081162.desop)
	c:RegisterEffect(e1)   
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75081162,1))
	--e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,75081163)
	e2:SetCondition(c75081162.thcon)
	e2:SetTarget(c75081162.thtg)
	e2:SetOperation(c75081162.thop)
	c:RegisterEffect(e2)  
	--Send to extra
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75081162,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,75081164)
	e4:SetCondition(c75081162.tecon)
	e4:SetTarget(c75081162.tetg)
	e4:SetOperation(c75081162.teop)
	c:RegisterEffect(e4)	 
end
function c75081162.desfilter(c)
	return c:IsSetCard(0x6754) and c:IsFaceupEx()
end
function c75081162.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c75081162.desfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c75081162.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp) then return end
	local g=Duel.GetMatchingGroup(c75081162.desfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
	local og=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g*#og==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,#og,nil)
	local oc=Duel.Destroy(sg,REASON_EFFECT)
	if oc==0 then return end
	local op=Duel.GetOperatedGroup():GetCount()
	Duel.Draw(tp,op,REASON_EFFECT)
end
--
function c75081162.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_HAND)
end
function c75081162.thfilter(c)
	return c:IsSetCard(0x6754) and c:IsAbleToHand()
end
function c75081162.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c75081162.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
--
function c75081162.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x6754)
end
function c75081162.tecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c75081162.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c75081162.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end