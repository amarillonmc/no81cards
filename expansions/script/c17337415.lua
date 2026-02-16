--从零开始
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337400,17337409)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,3))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(17337400)
end
function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsChainNegatable(ev)
end
function s.tdfilter(c)
	return c:IsCode(17337400) and c:IsAbleToDeck()
end
function s.chkfilter(c)
	return c:IsFaceupEx() and c:IsCode(17337409)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
			and Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		return b1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	end
	local sg=Duel.GetMatchingGroup(s.chkfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local ct=math.min(1,sg:GetCount())
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rg=sg:Select(tp,1,ct,nil)
	if rg:GetCount()>0 then
		local hg=rg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		local og=rg-hg
		Duel.ConfirmCards(1-tp,hg)
		Duel.HintSelection(og)
		if hg:GetCount()>=1 then
			Duel.ShuffleHand(tp)
		end
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
	end
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsCode(17337400) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end