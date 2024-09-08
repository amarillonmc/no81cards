--水之女演员 七星鱼
function c33718002.initial_effect(c)
--一回合一次；从你的墓地将1张「水之女演员 / Aquaactress」卡加入手牌并常时展示。在双方玩家的结束阶段与准备阶段，可以将因为这个效果常时展示的卡特殊召唤。
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)--一回合一次
	e1:SetCondition(c33718002.condition1)
	e1:SetTarget(c33718002.target)
	e1:SetOperation(c33718002.activate)
	c:RegisterEffect(e1)
--水再演
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c33718002.condition2)
	c:RegisterEffect(e2)
--唐鱼
	local e3=e1:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c33718002.condition3)
	c:RegisterEffect(e3)
end
function c33718002.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,33718017) and not Duel.IsPlayerAffectedByEffect(tp,33718001)
end
function c33718002.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33718017) and not Duel.IsPlayerAffectedByEffect(tp,33718001)
end
function c33718002.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33718001) and not Duel.IsPlayerAffectedByEffect(tp,33718017)
end
function c33718002.filter(c)
	return c:IsSetCard(0xcd) and c:IsAbleToHand()
end
function c33718002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33718002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33718002.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33718002.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33718002.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(g)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY+PHASE_END)
		e1:SetRange(LOCATION_HAND)
		e1:SetCountLimit(1)
		e1:SetTarget(c33718002.sptarget)
		e1:SetOperation(c33718002.spactivate)
		c:RegisterEffect(e1,true)
	end
end
function c33718002.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33718002.spactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end