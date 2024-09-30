--仿若无因飘落的细雨
function c60002422.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING) 
	e1:SetCondition(c60002422.condition)
	e1:SetTarget(c60002422.target)
	e1:SetOperation(c60002422.activate)
	c:RegisterEffect(e1)
end
function c60002422.condition(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>0 and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)==Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c60002422.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.GetDecktopGroup(tp,1):GetFirst() and Duel.GetDecktopGroup(tp,1):GetFirst():IsAbleToRemove(POS_FACEDOWN) and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0x6622) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_REMOVED,0,1,nil)
	local b2=Duel.GetDecktopGroup(tp,1):GetFirst() and Duel.GetDecktopGroup(tp,1):GetFirst():IsAbleToRemove() and Duel.IsExistingMatchingCard(function(c) return c:IsFacedown() and c:IsAbleToHand() and c:IsSetCard(0x6622) and c:IsType(TYPE_SPELL+TYPE_TRAP) end,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c60002422.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT) 
		local tc=eg:GetFirst()  
		if tc then 
		--activate limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)  
		e1:SetLabelObject(tc)
		e1:SetValue(c60002422.actlimit) 
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp) 
		end 
		local b1=Duel.GetDecktopGroup(tp,1):GetFirst() and Duel.GetDecktopGroup(tp,1):GetFirst():IsAbleToRemove(POS_FACEDOWN) and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0x6622) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_REMOVED,0,1,nil)
		local b2=Duel.GetDecktopGroup(tp,1):GetFirst() and Duel.GetDecktopGroup(tp,1):GetFirst():IsAbleToRemove() and Duel.IsExistingMatchingCard(function(c) return c:IsFacedown() and c:IsAbleToHand() and c:IsSetCard(0x6622) and c:IsType(TYPE_SPELL+TYPE_TRAP) end,tp,LOCATION_REMOVED,0,1,nil) 
		if b1 or b2 then 
			local op=2
			if b1 and b2 then 
				op=Duel.SelectOption(tp,aux.Stringid(60002422,1),aux.Stringid(60002422,2)) 
			elseif b1 then 
				op=Duel.SelectOption(tp,aux.Stringid(60002422,1)) 
			elseif b2 then 
				op=Duel.SelectOption(tp,aux.Stringid(60002422,2))+1  
			end 
			if op==0 then 
				local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0x6622) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_REMOVED,0,1,1,nil)  
				Duel.SendtoHand(sg,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg) 
				local tc=Duel.GetDecktopGroup(tp,1):GetFirst() 
				Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
			elseif op==1 then 
				local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil) 
				Duel.ConfirmCards(tp,g) 
				Duel.ConfirmCards(1-tp,g) 
				local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsFacedown() and c:IsAbleToHand() and c:IsSetCard(0x6622) and c:IsType(TYPE_SPELL+TYPE_TRAP) end,tp,LOCATION_REMOVED,0,1,1,nil)  
				Duel.SendtoHand(sg,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg) 
				local tc=Duel.GetDecktopGroup(tp,1):GetFirst() 
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end 
		end 
		if c:IsCanTurnSet() then 
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end 
	end
end
function c60002422.actlimit(e,re,tp) 
	local tc=e:GetLabelObject() 
	return re:GetHandler():GetOriginalCodeRule()==tc:GetOriginalCodeRule() 
end




