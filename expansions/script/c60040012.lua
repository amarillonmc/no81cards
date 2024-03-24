--肃清之器·梅希亚
local cm,m,o=GetID()
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--code
	aux.EnableChangeCode(c,60040005,LOCATION_MZONE+LOCATION_GRAVE)
	--synchro summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.drcon)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.drtarg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
end
function cm.filter1(c)
	return c:IsAbleToGraveAsCost() and c:IsFaceup()
end
function cm.filter2(c)
	return c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND,0,1,nil) end
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,0,LOCATION_ONFIELD,nil):Select(tp,1,1,nil)
	local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND,0,nil):Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end