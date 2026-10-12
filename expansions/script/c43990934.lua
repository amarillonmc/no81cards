--象征世界的剥离
function c43990934.initial_effect(c)
	--leavl field
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVING)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCondition(c43990934.lfcon)
	e0:SetOperation(c43990934.lfop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43990934)
	e1:SetTarget(c43990934.target)
	e1:SetOperation(c43990934.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,43990934-1)
	e2:SetTarget(c43990934.reptg)
	e2:SetValue(c43990934.repval)
	e2:SetOperation(c43990934.repop)
	c:RegisterEffect(e2)
end
function c43990934.lfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and (not c:IsOnField() or not c:IsRelateToEffect(re))-- and re:IsActivated()
end
function c43990934.lfop(e,tp,eg,ep,ev,re,r,rp)
	--if not Duel.SelectYesNo(tp,aux.Stringid(43990934,2)) then return end
	Duel.Hint(HINT_CARD,0,43990934)
	Duel.Draw(rp,1,REASON_EFFECT)
end
function c43990934.spfilter(c,e,tp)
	return c:IsSetCard(0x7a10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43990934.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c43990934.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	if Duel.Destroy(sg,REASON_EFFECT)==0 then return end
	local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(43990934,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g2:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c43990934.repfilter(c,tp)
	return c:IsSetCard(0x7a10) and c:IsControler(tp) and c:IsOnField() and c:IsFaceup() and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c43990934.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and eg:IsExists(c43990934.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c43990934.repval(e,c)
	return c43990934.repfilter(c,e:GetHandlerPlayer())
end
function c43990934.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,43990934)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
