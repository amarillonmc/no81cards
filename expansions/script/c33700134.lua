--霓火幻琴
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c33700134.initial_effect(c)
	c:EnableReviveLimit()
	Senya.AddXyzProcedureCustom(c,c33700134.ovfilter,nil,2,2)
	-- 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetDescription(aux.Stringid(33700134,0))
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(c33700134.condition)
	e1:SetTarget(c33700134.target)
	e1:SetOperation(c33700134.activate)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c33700134.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33700134,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c33700134.cost)
	e4:SetTarget(c33700134.tg)
	e4:SetOperation(c33700134.op)
	c:RegisterEffect(e4)
end
function c33700134.ovfilter(c,g)
	return c:IsSetCard(0x443)
end
function c33700134.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c33700134.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700134.cfilter,1,nil,1-tp)
end
function c33700134.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	 local g=eg:Filter(c33700134.cfilter,nil,1-tp)
	Duel.SetTargetCard(g)
end
function c33700134.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if  g:GetCount()~=0  then
		Duel.Overlay(c,g)
	end
end
function c33700134.atkval(e,c)
	return c:GetOverlayCount()*400
end
function c33700134.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33700134.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c33700134.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
