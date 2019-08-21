--崇高之瓶
local m=14090006
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function cm.filter(c)
	return c:IsAttackPos()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,g:GetCount()) and Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if g:GetCount()>0 then
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,0))
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,1))
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,2))
		Duel.Draw(p,d,REASON_EFFECT)
	end
	if e:GetHandler():IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end