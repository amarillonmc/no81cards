--龙腾无人机衍生物-激光开采模块
function c79029082.initial_effect(c)
	c:SetUniqueOnField(1,0,79029082)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetTarget(c79029082.target)
	e3:SetOperation(c79029082.operation)
	c:RegisterEffect(e3) 
end
function c79029082.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function c79029082.operation(e,tp,eg,ep,ev,re,r,rp)
	 local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end






