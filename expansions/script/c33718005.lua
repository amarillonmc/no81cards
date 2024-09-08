--水之女演员 神仙鱼
function c33718005.initial_effect(c)
--将你控制的1张「水之女演员 / Aquaactress」怪兽卡返回手牌，然后抽1张卡，那张卡是「水之女演员 / Aquaactress」怪兽的场合，可以将其特殊召唤，然后再抽1张卡。
--这个卡名的卡的效果1回合只能发动1次。
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(c33718005.target)
	e1:SetOperation(c33718005.activate)
	c:RegisterEffect(e1)
--水再演
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c33718005.condition2)
	c:RegisterEffect(e2)
--唐鱼
	local e3=e1:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c33718005.condition3)
	c:RegisterEffect(e3)
end
function c33718005.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,33718017) and not Duel.IsPlayerAffectedByEffect(tp,33718001)
end
function c33718005.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33718017) and not Duel.IsPlayerAffectedByEffect(tp,33718001)
end
function c33718005.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33718001) and not Duel.IsPlayerAffectedByEffect(tp,33718017)
end
function c33718005.filter(c)
	return c:IsSetCard(0xcd) and c:IsAbleToHand()
end
function c33718005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33718005.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33718005.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33718005.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 and g:GetFirst():IsRelateToEffect(e) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			local c=e:GetHandler()
			local g=Duel.GetOperatedGroup()
			local tc=g:GetFirst()
			if tc:IsSetCard(0xce) and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(33718005,0)) then
				Duel.BreakEffect()
				if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	end
end
