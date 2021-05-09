--单推人的幸福
function c16200006.initial_effect(c)
	aux.AddCodeList(c,16200003)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetLabel(0)
	e1:SetCountLimit(1,16200006)
	e1:SetCost(c16200006.cost)
	e1:SetCondition(c16200006.condition)
	e1:SetTarget(c16200006.target)
	e1:SetOperation(c16200006.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c16200006.handcon)
	c:RegisterEffect(e0)
end
function c16200006.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c16200006.handcon(e)
	return not Duel.IsExistingMatchingCard(c16200006.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c16200006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c16200006.condition(e,tp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c16200006.thfilter(c)
	return c:IsAbleToHand() and aux.IsCodeListed(c,16200003)
end
function c16200006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a1=Duel.IsExistingMatchingCard(c16200006.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.CheckReleaseGroup(tp,Card.IsCode,2,nil,16200003)
	local a2=Duel.CheckReleaseGroup(tp,Card.IsCode,3,nil,16200003)
	local a3=Duel.GetMatchingGroupCount(Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,LOCATION_MZONE,nil,true)==Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE) and Duel.CheckReleaseGroup(tp,Card.IsCode,4,nil,16200003)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		return a1 or a2 or a3
	end
	local op=1
	if a1 and a2 and a3 then
		op=Duel.SelectOption(tp,aux.Stringid(16200006,1),aux.Stringid(16200006,2),aux.Stringid(16200006,3))
	elseif a1 and a2 then
		op=Duel.SelectOption(tp,aux.Stringid(16200006,1),aux.Stringid(16200006,2))
	elseif a2 and a3 then
		op=Duel.SelectOption(tp,aux.Stringid(16200006,2),aux.Stringid(16200006,3))+1
	elseif a1 and a3 then
		op=Duel.SelectOption(tp,aux.Stringid(16200006,1),aux.Stringid(16200006,3))
		if op==1 then
			op=2
		end
	elseif a1 then
		op=Duel.SelectOption(tp,aux.Stringid(16200006,1))
	elseif a2 then
		op=Duel.SelectOption(tp,aux.Stringid(16200006,2))+1
	elseif a3 then
		op=Duel.SelectOption(tp,aux.Stringid(16200006,3))+2
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg1=Duel.SelectReleaseGroup(tp,Card.IsCode,2,2,nil,16200003)
		Duel.Release(sg1,REASON_COST)
		e:SetLabel(2)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg1=Duel.SelectReleaseGroup(tp,Card.IsCode,3,3,nil,16200003)
		Duel.Release(sg1,REASON_COST)
		e:SetLabel(3)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg1=Duel.SelectReleaseGroup(tp,Card.IsCode,4,99,nil,16200003)
		Duel.Release(sg1,REASON_COST)
		e:SetLabel(4)
	end
	if e:GetLabel()==2 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if e:GetLabel()==4 then
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,tp,nil)
	end
end
function c16200006.activate(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	if num==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c16200006.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	elseif num==3 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(2)
		Duel.RegisterEffect(e1,tp)
	elseif num==4 then
		local g1=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,0,nil)
		local g2=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,1-tp,LOCATION_MZONE,0,nil)
		Duel.SwapControl(g1,g2,PHASE_END,2)
	end
end