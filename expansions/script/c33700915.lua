--闪亮的流星遗产，坠落于许愿之地
function c33700915.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP)
	e1:SetCondition(c33700915.condition)
	e1:SetTarget(c33700915.target)
	e1:SetOperation(c33700915.activate)
	c:RegisterEffect(e1) 
end
function c33700915.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c33700915.filter(c,tp,rc)
	local g=Group.FromCards(c,rc)
	return c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,g)
end
function c33700915.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c33700915.filter(chkc,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(c33700915.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c33700915.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,c)
	g:AddCard(c)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_HAND,0,g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
end
function c33700915.activate(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	if tc:IsRelateToEffect(e) then g:AddCard(tc) end
	if c:IsRelateToEffect(e) then g:AddCard(c) end
	local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_HAND,0,g)
	if #tg<=0 or Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)<=0 then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local b1=tc:IsFaceup() and tc:IsRelateToEffect(e)
	local b2=true
	if b1 and not Duel.SelectYesNo(tp,aux.Stringid(33700915,0)) then
		local g=Duel.GetMatchingGroup(c33700915.cfilter,tp,LOCATION_DECK,0,nil)
		local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local seq=-1
		local gc=g:GetFirst()
		local atk,def=0,0
		local ccard=nil
		local ct=0
		while gc do
			if gc:GetSequence()>seq then 
				seq=gc:GetSequence()
				ccard=gc
			end
			gc=g:GetNext()
		end
		if seq==-1 then
			Duel.ConfirmDecktop(tp,dcount)
			local tg=Duel.GetDecktopGroup(tp,dcount)
			atk,def=tg:GetSum(Card.GetAttack),tg:GetSum(Card.GetDefense)
			ct=dcount
		else
			Duel.ConfirmDecktop(tp,dcount-seq)
			local tg=Duel.GetDecktopGroup(tp,dcount-seq-1)
			atk,def=tg:GetSum(Card.GetAttack),tg:GetSum(Card.GetDefense) ct=dcount-seq
		end
		Duel.ShuffleDeck(tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(def)
		tc:RegisterEffect(e2)
	else
		repeat
			Duel.ConfirmDecktop(tp,1)
			local gc=Duel.GetDecktopGroup(tp,1):GetFirst()
			if gc:IsLevel(4) and gc:IsAttribute(ATTRIBUTE_LIGHT) and gc:IsRace(RACE_MACHINE) then 
				 Duel.DisableShuffleCheck()
				 Duel.SendtoGrave(gc,REASON_EFFECT+REASON_REVEAL)
				 if gc:IsLocation(LOCATION_GRAVE) then
					Duel.Damage(1-tp,gc:GetAttack(),REASON_EFFECT)
				 else
					break 
				 end
			else
				break 
			end
		until not Duel.IsPlayerCanDiscardDeck(tp,1) or Duel.GetLP(1-tp)<=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetOperation(function(e,tp) Duel.SetLP(tp,0) end)
		Duel.RegisterEffect(e2,tp)
	end
end
function c33700915.cfilter(c)
	return not c:IsLevel(4) or not c:IsAttribute(ATTRIBUTE_LIGHT) or not c:IsRace(RACE_MACHINE)
end