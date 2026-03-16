local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(s.negcon)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(s.descon)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if re:GetHandler()==c then return false end
	local g=c:GetOverlayGroup()
	if re:IsActiveType(TYPE_MONSTER) and g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then return false end
	if re:IsActiveType(TYPE_SPELL) and g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then return false end
	if re:IsActiveType(TYPE_TRAP) and g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then return false end
	return Duel.IsChainDisablable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=false
	-- ep is the player who activated the effect
	if c:IsRelateToEffect(e) and c:IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(ep,LOCATION_HAND,0)>0 then
		if Duel.SelectYesNo(ep,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,ep,HINTMSG_XMATERIAL)
			local g=Duel.SelectMatchingCard(ep,nil,ep,LOCATION_HAND,0,1,1,nil)
			if #g>0 then
				Duel.Overlay(c,g)
				res=true
			end
		end
	end
	if not res then
		Duel.NegateEffect(ev)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	return g:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
		and g:IsExists(Card.IsType,1,nil,TYPE_SPELL)
		and g:IsExists(Card.IsType,1,nil,TYPE_TRAP)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then return ct>0 and c:CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	c:RemoveOverlayCard(tp,ct,ct,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end