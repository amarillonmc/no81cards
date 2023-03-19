--学园孤岛 丈枪由纪
local m=42621009
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.cscon)
	e2:SetCost(cm.cscost)
	e2:SetOperation(cm.csop)
	c:RegisterEffect(e2)
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end

function cm.cscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetCurrentScale()~=7
end

function cm.costcfilter(c)
	return not c:IsPublic() and c:IsLevel(6) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end

function cm.cscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,cm.costcfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
end

function cm.csop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(7)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		c:RegisterEffect(e2)
	end
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,nil,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,nil,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(cm.adjustop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local dgg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_DECK,nil)
	local drg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_DECK,nil,1-tp,POS_FACEDOWN)
	local cgg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_EXTRA,nil)
	local crg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_EXTRA,nil,1-tp,POS_FACEDOWN)
	local hgg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_HAND,nil)
	local hrg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_HAND,nil,1-tp,POS_FACEDOWN)
	local gg=Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)
	local rg=Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)
	if gg==rg or (rg>gg and dgg:GetCount()==0 and cgg:GetCount()==0 and hgg:GetCount()==0) or 
	(gg>rg and drg:GetCount()==0 and crg:GetCount()==0 and hrg:GetCount()==0) then return false end
	local tc=nil
	while Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)~=Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED) do
		if Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)>Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE) then
			if Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_DECK,nil):GetCount()>0 then
				tc=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_DECK,nil):RandomSelect(1-tp,1):GetFirst()
			elseif Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_EXTRA,nil):GetCount()>0 then
				tc=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_EXTRA,nil):RandomSelect(1-tp,1):GetFirst()
			elseif Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_HAND,nil):GetCount()>0 then
				tc=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_HAND,nil):RandomSelect(1-tp,1):GetFirst()
			end
			Duel.SendtoGrave(tc,REASON_RULE)
		elseif Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED) then
			if Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_DECK,nil,1-tp,POS_FACEDOWN):GetCount()>0 then
				tc=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_DECK,nil,1-tp,POS_FACEDOWN):RandomSelect(1-tp,1):GetFirst()
			elseif Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_EXTRA,nil,1-tp,POS_FACEDOWN):GetCount()>0 then
				tc=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_EXTRA,nil,1-tp,POS_FACEDOWN):RandomSelect(1-tp,1):GetFirst()
			elseif Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_HAND,nil,1-tp,POS_FACEDOWN):GetCount()>0 then
				tc=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_HAND,nil,1-tp,POS_FACEDOWN):RandomSelect(1-tp,1):GetFirst()
			end
			Duel.Remove(tc,POS_FACEDOWN,REASON_RULE)
		end
		if tc:GetLocation()==LOCATION_GRAVE then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,1)
			e1:SetTarget(cm.sumlimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_REMOVE)
			e2:SetValue(1)
			Duel.RegisterEffect(e2,tp)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CANNOT_ACTIVATE)
			e4:SetValue(cm.aclimit)
			Duel.RegisterEffect(e4,tp)
		end
		if (Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)>Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE) and Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_DECK,nil):GetCount()==0 and Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_EXTRA,nil):GetCount()==0 and Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_HAND,nil):GetCount()==0) or 
		(Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED) and Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_DECK,nil,1-tp,POS_FACEDOWN):GetCount()==0 and Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_EXTRA,nil,1-tp,POS_FACEDOWN):GetCount()==0 and Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_HAND,nil,1-tp,POS_FACEDOWN):GetCount()==0) then break end
	end
	Duel.Readjust()
end

function cm.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end

function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end