--战源猎人 龙骑双子
function c12057611.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c12057611.mfilter1,c12057611.mfilter2,true) 
	--attribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetRange(0xff)
	e0:SetValue(RACE_WARRIOR)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c12057611.immcon1)
	e1:SetValue(c12057611.efilter1)
	c:RegisterEffect(e1)	
	--pos 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057611,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c12057611.postg1)
	e2:SetOperation(c12057611.posop1)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057611,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c12057611.postg2)
	e2:SetOperation(c12057611.posop2)
	c:RegisterEffect(e2)
	--repeat attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12057611,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCountLimit(1,12057611)
	e3:SetTarget(c12057611.thtg)
	e3:SetOperation(c12057611.thop)
	c:RegisterEffect(e3)
end
function c12057611.mfilter1(c)
	return c:IsAttackAbove(1500) and c:IsRace(RACE_WARRIOR)
end
function c12057611.mfilter2(c)
	return c:IsDefenseAbove(1800) and c:IsRace(RACE_DRAGON)
end
function c12057611.immcon1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c12057611.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() 
end
function c12057611.posfil1(c)
	return c:IsFaceup()
end
function c12057611.postg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057611.posfil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():GetFlagEffect(12057611)==0 end 
	e:GetHandler():RegisterFlagEffect(12057611,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c12057611.posop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12057611.posfil1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c12057611.posfil2(c)
	return c:IsDefensePos()
end
function c12057611.postg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057611.posfil2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():GetFlagEffect(12057611)==0 end 
	e:GetHandler():RegisterFlagEffect(12057611,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c12057611.posop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12057611.posfil2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
	end
end
function c12057611.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and tc:IsAbleToRemove() and tc:IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c12057611.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then tc=Duel.GetAttackTarget() end
	if tc and tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) and c:IsChainAttackable() then
		Duel.ChainAttack()
	end
end



