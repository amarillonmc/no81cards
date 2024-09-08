--水之女演员 小丑鱼
function c33718004.initial_effect(c)
--将你控制的1张「水族馆 / Aquarium」卡返回手牌，然后抽1张卡，那张卡是「水族馆 / Aquarium」卡的场合，可以将其表侧置放在场上，然后再抽1张卡。这个卡名的卡的效果1回合只能发动1次。
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33718004)
	e1:SetCondition(c33718004.condition1)
	e1:SetTarget(c33718004.target)
	e1:SetOperation(c33718004.activate)
	c:RegisterEffect(e1)
--水再演
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c33718004.condition2)
	c:RegisterEffect(e2)
--唐鱼
	local e3=e1:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c33718004.condition3)
	c:RegisterEffect(e3)
end
function c33718004.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,33718017) and not Duel.IsPlayerAffectedByEffect(tp,33718001)
end
function c33718004.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33718017) and not Duel.IsPlayerAffectedByEffect(tp,33718001)
end
function c33718004.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33718001) and not Duel.IsPlayerAffectedByEffect(tp,33718017)
end
function c33718004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33718004.filter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33718004.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33718004.filter,tp,LOCATION_SZONE,0,1,1,nil)
	if g:GetCount()>0 and g:GetFirst():IsRelateToEffect(e) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then 
			local c=e:GetHandler()
			local g=Duel.GetOperatedGroup()
			local tc=g:GetFirst()
			if tc:IsSetCard(0xce) and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(33718004,0)) then
				Duel.BreakEffect()
				if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	end
end