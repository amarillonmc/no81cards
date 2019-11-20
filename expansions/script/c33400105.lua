--刻刻帝 「五之弹」
function c33400105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400105+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33400105.target)
	e1:SetOperation(c33400105.activate)
	c:RegisterEffect(e1)
end
function c33400105.filter1(c)
	return c:IsSetCard(0x3341) or c:IsSetCard(0x3340)
end
function c33400105.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK)>0  and Duel.IsCanRemoveCounter(tp,1,0,0x34f,2,REASON_COST) end
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x34f)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 and ct>=4 then 
		  if Duel.IsExistingMatchingCard(c33400105.filter1,tp,LOCATION_GRAVE,0,3,nil) then
			op=Duel.SelectOption(tp,aux.Stringid(33400105,0),aux.Stringid(33400105,1),aux.Stringid(33400105,2))
			Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
			if op==2 then Duel.RemoveCounter(tp,1,0,0x34f,4,REASON_COST)
			else Duel.RemoveCounter(tp,1,0,0x34f,2,REASON_COST) 
			end
		  else
			 op=Duel.SelectOption(tp,aux.Stringid(33400105,0),aux.Stringid(33400105,1))
			 Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
			 Duel.RemoveCounter(tp,1,0,0x34f,2,REASON_COST)
		  end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(33400105,0))
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		Duel.RemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	else
		op=Duel.SelectOption(tp,aux.Stringid(33400105,1))+1
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		Duel.RemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	end
	e:SetLabel(op)
end
function c33400105.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if cm1>5 then cm1=5 end
	if cm2>5 then cm2=5 end
	if op~=1 then
		local g=Duel.GetDecktopGroup(tp,cm1)
		Duel.ConfirmCards(tp,g)
		if g:IsExists(c33400105.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33400105,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c33400105.filter,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.SortDecktop(tp,tp,cm1-1)
		else Duel.SortDecktop(tp,tp,cm1) 
		end
	end
	if op~=0 then
		  if op==2 then Duel.BreakEffect() end
		  local g=Duel.GetDecktopGroup(1-tp,cm2)
		  Duel.ConfirmCards(tp,g)
		  if g:IsExists(c33400105.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33400105,3)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local sg=g:FilterSelect(tp,c33400105.filter,1,1,nil)
		  Duel.DisableShuffleCheck()
		  Duel.SendtoHand(sg,tp,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,sg)
		  Duel.ShuffleHand(tp)
		  Duel.SortDecktop(tp,1-tp,cm2-1)
		  else Duel.SortDecktop(tp,1-tp,cm2) 
		  end					  
	end
	Duel.RegisterFlagEffect(tp,33400101,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end
function c33400105.filter(c)
	return (c:IsSetCard(0x3341) or c:IsSetCard(0x3340)) and c:IsAbleToHand()
end