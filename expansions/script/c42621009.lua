local m=42621009
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--pzone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cm.lpcost)
	e2:SetOperation(cm.lpop)
	c:RegisterEffect(e2)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0x200,0x200,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,0x200,0x200,1,1,c)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end

function cm.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lpck0=Duel.GetLocationCount(tp,0x08,tp,0x1,0x11)>0
	local lpck1=Duel.GetLocationCount(1-tp,0x08,tp,0x1,0x11)>0
	if chk==0 then return not c:IsForbidden() and (lpck0 or lpck1) end
	local lpck
	if lpck0 and lpck1 then
		lpck=math.abs(Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))-tp)
	else
		if lpck0 then
			lpck=tp
		else
			lpck=1-tp
		end
	end
	Duel.MoveToField(c,tp,lpck,0x200,POS_FACEUP,true)
end

function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
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
		if tc and tc:IsLocation(0x10) then
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