--天空漫步者-追击
function c9910216.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c9910216.condition)
	e1:SetTarget(c9910216.target)
	e1:SetOperation(c9910216.activate)
	c:RegisterEffect(e1)
	if not c9910216.global_check then
		c9910216.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c9910216.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9910216.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE) then
			if tc:GetPreviousControler()~=0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,9910216,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,9910216,RESET_PHASE+PHASE_END,0,1) end
end
function c9910216.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsRace(RACE_PSYCHO))
end
function c9910216.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9910216)~=0
		and not Duel.IsExistingMatchingCard(c9910216.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910216.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9910216.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(9910216,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(9910216,4))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(9910216,5))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
	end
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(9910216,0)) then
		Duel.BreakEffect()
		if not Duel.IsPlayerCanDraw(1-tp,1) then Duel.Recover(1-tp,3000,REASON_EFFECT) return end
		if Duel.GetCurrentChain()>2 then
			if Duel.SelectOption(tp,aux.Stringid(9910216,1),aux.Stringid(9910216,2))==0 then
				Duel.Recover(1-tp,3000,REASON_EFFECT)
			else
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
		else
			if Duel.SelectOption(1-tp,aux.Stringid(9910216,1),aux.Stringid(9910216,2))==0 then
				Duel.Recover(1-tp,3000,REASON_EFFECT)
			else
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
		end
	end
end
