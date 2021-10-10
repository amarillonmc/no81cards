--龙纹帝王
local m=40009960
local cm=_G["c"..m]
cm.named_with_Dragonic=1
cm.named_with_Overlord=1
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(cm.atcon)
	e1:SetCost(cm.atcost)
	e1:SetOperation(cm.atop)
	c:RegisterEffect(e1)  
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2)  
end
function cm.Dragonicfilter(c)
--「龙纹」字段在ocg持有的卡
	return c:IsCode(2896663,75402014,78009994,72549351,13035077,32437102) 
end

function cm.Overlordfilter(c)
--「帝王」字段在ocg持有的卡
	return c:IsCode(36970611,3659803,98452268) 
end



function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
		and e:GetHandler():IsChainAttackable(0)
end
function cm.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end