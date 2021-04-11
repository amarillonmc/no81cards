--奥兹国的大魔女
function c72411760.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72411760)
	e1:SetCondition(c72411760.sprcon)
	e1:SetOperation(c72411760.sprop)
	c:RegisterEffect(e1)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72411760,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c72411760.drtg)
	e3:SetOperation(c72411760.drop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c72411760.condition)
	e4:SetTarget(c72411760.target)
	e4:SetOperation(c72411760.operation)
	c:RegisterEffect(e4)
end
function c72411760.tdfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToDeckAsCost() and not c:IsType(TYPE_PENDULUM)
end
function c72411760.tdgcheck(g)
	return Duel.GetMZoneCount(tp,g,tp) > 0 and g:GetClassCount(Card.GetType) == #g
end
function c72411760.sprcon(e,c)
	if c == nil then return true end
	local tp = c:GetControler()
	local g = Duel.GetMatchingGroup(c72411760.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return g:CheckSubGroup(c72411760.tdgcheck,5,5)
end
function c72411760.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g = Duel.GetMatchingGroup(c72411760.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg = g:SelectSubGroup(tp,c72411760.tdgcheck,false,5,5)
	Duel.ConfirmCards(1-tp,tg)
	Duel.SendtoDeck(tg,nil,2,REASON_COST)
end
function c72411760.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c72411760.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ct>0 and Duel.Draw(p,ct,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		Duel.ConfirmCards(1-p,g)
		local m=Group.Filter(g,Card.IsType,nil,TYPE_SPELL):GetCount()
		Duel.Draw(p,m,REASON_EFFECT)
	end
end
function c72411760.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c72411760.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	local m=Group.Filter(g,Card.IsType,nil,TYPE_SPELL):GetCount()
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,m)
end

function c72411760.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	Duel.ConfirmCards(1-p,g)
	local rg=Group.Filter(g,Card.IsType,nil,TYPE_SPELL)
	if rg~=0 then 
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end