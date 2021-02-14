--庇护天马
function c9910432.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c9910432.indtg)
	e1:SetValue(c9910432.efilter)
	c:RegisterEffect(e1)
	--change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910432)
	e2:SetTarget(c9910432.cbtg)
	e2:SetOperation(c9910432.cbop)
	c:RegisterEffect(e2)
	--change effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9910432)
	e3:SetCondition(c9910432.cecon)
	e3:SetTarget(c9910432.cetg)
	e3:SetOperation(c9910432.ceop)
	c:RegisterEffect(e3)
end
function c9910432.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c9910432.efilter(e,te)
	local tp=e:GetHandlerPlayer()
	if not te:IsActivated() then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD)
end
function c9910432.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ag=Duel.GetAttacker():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	ag:RemoveCard(at)
	if chk==0 then return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp) and ag:IsContains(c) end
end
function c9910432.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetAttacker():IsImmuneToEffect(e)
		or not Duel.ChangeAttackTarget(c) then return false end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910432,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.LinkSummon(tp,tc,nil)
	end
end
function c9910432.cfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function c9910432.cecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g:IsExists(c9910432.cfilter,1,nil,tp) and not g:IsContains(c)
end
function c9910432.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckChainTarget(ev,c) end
end
function c9910432.ceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) or not Duel.GetAttacker():IsImmuneToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(c))
	end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910432,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.LinkSummon(tp,tc,nil)
	end
end
