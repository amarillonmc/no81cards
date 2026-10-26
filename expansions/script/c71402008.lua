--天地的搬运工
local s,id,o=GetID()
function s.initial_effect(c)
	--①除外场上·墓地的卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con1)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--②回到卡组
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,id+100000)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and re~=nil
end
function s.costfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
			and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,c)
	if g:GetCount()==1 then
		g:AddCard(c)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function s.filter1(c,tp)
	return c:IsAbleToRemove(tp)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter1),tp,LOCATION_ONFIELD+LOCATION_GRAVE,
			LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,tp)
	end
	if Duel.GetTurnPlayer()==tp then
		e:SetCategory(e:GetCategory()|CATEGORY_DISABLE)
	else
		e:SetCategory(e:GetCategory()&~CATEGORY_DISABLE)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1),tp,LOCATION_ONFIELD+LOCATION_GRAVE,
		LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil,tp)
	local tc=g:GetFirst()
	if not tc or Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_REMOVED) then return end
	if Duel.GetTurnPlayer()==tp and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		s.regdisable(e,tp,tc)
		s.regredirect(e,tp)
	end
end
function s.regdisable(e,tp,tc)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(s.distg1)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(s.discon)
	e2:SetOperation(s.disop)
	e2:SetLabelObject(tc)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.distg2)
	e3:SetLabelObject(tc)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function s.distg1(e,c)
	local tc=e:GetLabelObject()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
	end
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
		and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function s.distg2(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function s.redirtg(e,c)
	return c:GetOwner()==e:GetLabel()
end
function s.regredirect(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(s.redirtg)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetLabel(tp)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function s.filter2(c)
	return c:IsAbleToDeck()
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck()
			and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,LOCATION_REMOVED)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,c)
	if g:GetCount()==1 then
		g:AddCard(c)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
