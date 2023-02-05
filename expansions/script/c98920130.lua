--中生代化石恶魔 骷髅石像鬼
function c98920130.initial_effect(c)
		aux.AddCodeList(c,59419719)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_ROCK),c98920130.matfilter,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c98920130.splimit)
	c:RegisterEffect(e1) 
   --attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(c98920130.atkfilter)
	c:RegisterEffect(e2)   
 --redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)  
  --damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920130,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,98920130)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c98920130.target)
	e3:SetOperation(c98920130.operation)
	c:RegisterEffect(e3)
end
function c98920130.matfilter(c)
	return c:IsLevel(5,6)
end
function c98920130.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(59419719) or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c98920130.atkfilter(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c98920130.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c98920130.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c98920130.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_DISASTER_LEO=0x18
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END
		and Duel.GetLP(1-tp)<=2000 and e:GetHandler():GetOverlayCount()==0 then
		Duel.Win(tp,WIN_REASON_DISASTER_LEO)
	end
end