--水之女演员 国斗鱼
function c33718003.initial_effect(c)
--一回合一次；从你的墓地选1张「水之女演员 / Aquaactress」怪兽或「水族馆 / Aquarium」卡，将其表侧置放在你的场上的一个正确区域。
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c33718003.condition1)
	e1:SetTarget(c33718003.target)
	e1:SetOperation(c33718003.activate)
	c:RegisterEffect(e1)
--水再演
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c33718003.condition2)
	c:RegisterEffect(e2)
--唐鱼
	local e3=e1:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c33718003.condition3)
	c:RegisterEffect(e3)
end
function c33718003.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,33718017) and not Duel.IsPlayerAffectedByEffect(tp,33718001)
end
function c33718003.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33718017) and not Duel.IsPlayerAffectedByEffect(tp,33718001)
end
function c33718003.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33718001) and not Duel.IsPlayerAffectedByEffect(tp,33718017)
end
function c33718003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33718003.filter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c33718003.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33718003.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if not g:GetCount()>0 then return end 
	if g:GetFirst():IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_MZONE,POS_FACEUP,true)
	end
	if g:GetFirst():IsType(TYPE_SPELL) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end