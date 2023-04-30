local m=82209002
local cm=_G["c"..m]
--陶器
function cm.initial_effect(c)
	--cannot special summon  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	c:RegisterEffect(e0)  
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCode(EVENT_BATTLE_DESTROYED)  
	e1:SetCondition(cm.drcon)  
	e1:SetTarget(cm.drtg)  
	e1:SetOperation(cm.drop)  
	c:RegisterEffect(e1)  
end  
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp)  
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,4) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(4)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,4)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  