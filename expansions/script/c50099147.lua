--仗剑走天涯 水晶石
function c50099147.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE) 
	e1:SetCountLimit(1,50099147)
	e1:SetCondition(c50099147.condition) 
	e1:SetTarget(c50099147.target)
	e1:SetOperation(c50099147.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,50099147) 
	e2:SetTarget(c50099147.thtg)
	e2:SetOperation(c50099147.thop)
	c:RegisterEffect(e2)
end
function c50099147.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c50099147.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end  
function c50099147.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x998)
end
function c50099147.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c50099147.cfilter,tp,LOCATION_MZONE,0,1,nil) 
end
function c50099147.filter(c)
	return c:IsCanChangePosition()
end
function c50099147.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c50099147.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToRemove() and c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c50099147.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK) 
end
function c50099147.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then 
		local pos=0 
		if tc:IsPosition(POS_FACEUP_ATTACK) then pos=POS_FACEDOWN_DEFENSE end 
		if tc:IsPosition(POS_FACEDOWN_DEFENSE) then pos=POS_FACEUP_ATTACK end 
		if pos==0 then pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE) end 
		Duel.ChangePosition(tc,pos)
		local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToRemove() and c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT) 
		end
	end
end









