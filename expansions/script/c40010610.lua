--拥宝之龙牙 道拉珠艾尔德
local m=40010610
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,cm.matfilter1,aux.FilterBoolFunction(Card.IsAttack,100),true) 
	aux.AddCodeList(c,40010618)
	--change name
	aux.EnableChangeCode(c,40010618,LOCATION_MZONE+LOCATION_GRAVE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.atkcost)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.efilter1)
	c:RegisterEffect(e2)

end
function cm.matfilter1(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_ROCK)
end
function cm.cfilter(c)
	return c:IsLevelAbove(1) and c:IsAbleToRemoveAsCost()
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetLevel)>=4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:SelectSubGroup(tp,aux.dlvcheck,false,4,4)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()~=100
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.c2filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.atkfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	if Duel.IsExistingMatchingCard(cm.c2filter,tp,0,LOCATION_MZONE,1,nil) then
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_FIELD)  
		e2:SetCode(EFFECT_CHANGE_DAMAGE)  
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
		e2:SetTargetRange(0,1)  
		e2:SetValue(cm.val)  
		e2:SetReset(RESET_PHASE+PHASE_BATTLE)  
		Duel.RegisterEffect(e2,tp) 
	end
end
function cm.val(e,re,dam,r,rp,rc)  
	if bit.band(r,REASON_BATTLE)~=0 then  
		return dam*2  
	else return dam end  
end  
function cm.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER) and te:GetOwner():GetAttack()==100
end


