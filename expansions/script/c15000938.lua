local m=15000938
local cm=_G["c"..m]
cm.name="憾死蔷薇花-怨灾莱西米娅"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.mfilter,1,1)
	c:EnableReviveLimit()
	--tograve rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.tgcon)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,15000920))
	c:RegisterEffect(e2)
	--double damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.damtg)
	e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e3)
end
function cm.mfilter(c)
	return c:IsAttackAbove(2000) and c:IsLinkType(TYPE_TOKEN)
end
function cm.tgfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x3f3f)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:IsFacedown() and c:IsLocation(LOCATION_EXTRA) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetTurnPlayer()==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.Hint(HINT_CARD,1-tp,15000938)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.SendtoGrave(g1,REASON_COST)~=0 then
		Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
	end
end
function cm.damtg(e,c)
	local tp=e:GetHandler():GetControler()
	return c:IsCode(15000920) and c:IsControler(tp) and c:GetBattleTarget()~=nil and c:GetBattleTarget():IsPosition(POS_FACEUP_ATTACK)
end