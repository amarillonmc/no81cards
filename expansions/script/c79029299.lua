--非戏剧性惨案
function c79029299.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetTarget(c79029299.target)
	e1:SetOperation(c79029299.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--dis 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c79029299.condition)
	e2:SetOperation(c79029299.op)
	c:RegisterEffect(e2)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(1)
	e2:SetCondition(c79029299.lpcon)
	e2:SetOperation(c79029299.lpop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabel(1)
	e3:SetCondition(c79029299.lpcon1)
	e3:SetOperation(c79029299.lpop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetLabel(1)
	e4:SetCondition(c79029299.regcon)
	e4:SetOperation(c79029299.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c79029299.lpcon2)
	e5:SetOperation(c79029299.lpop2)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c79029299.mtop)
	c:RegisterEffect(e4)
end
function c79029299.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetTargetCard(g)
	local mg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,mg,mg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79029299.activate(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	Duel.Destroy(g,REASON_EFFECT)
	Duel.Remove(mg,REASON_EFFECT)
end
function c79029299.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RULE 
end
function c79029299.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029299)
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0)
	Duel.SendtoDeck(g,ep,2,REASON_EFFECT)
	Duel.ShuffleDeck(ep)
	Duel.BreakEffect()
	Duel.Draw(ep,g:GetCount(),REASON_EFFECT)
end
function c79029299.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function c79029299.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	return (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c79029299.lpop1(e,tp,eg,ep,ev,re,r,rp)
	local rnum=eg:GetSum(Card.GetAttack)
	Duel.Recover(1-ep,rnum,REASON_EFFECT)
end
function c79029299.regcon(e,tp,eg,ep,ev,re,r,rp)
	return c79029299.lpcon(e,tp,eg,ep,ev,re,r,rp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c79029299.regop(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg
	local g=e:GetLabelObject()
	if g==nil or #g==0 then
		lg:KeepAlive()
		e:SetLabelObject(lg)
	else
		g:Merge(lg)
	end
	e:GetHandler():RegisterFlagEffect(79029299,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function c79029299.lpcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(79029299)>0
end
function c79029299.lpop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(79029299)
	local lg=e:GetLabelObject():GetLabelObject()
	local rnum=lg:GetSum(Card.GetAttack)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
	lg:DeleteGroup()
	Duel.Recover(1-ep,rnum,REASON_EFFECT)
end
function c79029299.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local xg=g:RandomSelect(tp,1)
	Duel.Release(xg,REASON_EFFECT)
	else
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end

