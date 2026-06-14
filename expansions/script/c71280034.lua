--异晶人的咒石
function c71280034.initial_effect(c)
	aux.AddCodeList(c,97403510)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71280034+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c71280034.target)
	e1:SetOperation(c71280034.activate)
	c:RegisterEffect(e1)
	--act in deck
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(c71280034.cost)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_DECK)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetLabelObject(e1)
	e3:SetTarget(c71280034.actarget)
	e3:SetOperation(c71280034.costop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(71280034,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c71280034.mvcost)
	e4:SetTarget(c71280034.mvtg)
	e4:SetOperation(c71280034.mvop)
	c:RegisterEffect(e4)
end
function c71280034.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x48) and c:IsType(TYPE_MONSTER)
end
function c71280034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerAffectedByEffect(tp,71280033) and Duel.GetFlagEffect(tp,71280033)==0 end
	Duel.RegisterFlagEffect(tp,71280033,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c71280034.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function c71280034.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	e:GetHandler():CreateEffectRelation(te)
	local c=e:GetHandler()
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(c71280034.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function c71280034.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function c71280034.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71280034.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71280034.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c71280034.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c71280034.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(c71280034.indes)
	tc:RegisterEffect(e1)
	--
	local rg=Duel.GetMatchingGroup(c71280034.nbfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	local sg=Duel.GetMatchingGroup(c71280034.thfilter,tp,LOCATION_DECK,0,nil,tc:GetAttribute(),tc:GetRace(),tc:GetRank())
	local op=aux.SelectFromOptions(tp,
		{#rg>0,aux.Stringid(71280034,1),1},
		{#sg>0,aux.Stringid(71280034,2),2},
		{true,aux.Stringid(71280034,3),3})
	if op==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local rc=rg:Select(tp,1,1,nil):GetFirst()
		if rc and rc:IsCanBeDisabledByEffect(e) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e4)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e3)
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(rc,RESET_TURN_SET)
			Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		end
	elseif op==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		if sc then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		end
	end
end
function c71280034.indes(e,c)
	return not c:IsSetCard(0x48)
end
function c71280034.nbfilter(c,atk)
	return c:IsFaceup() and aux.NegateMonsterFilter(c) and c:IsAbleToRemove() and c:IsAttackBelow(atk)
end
function c71280034.thfilter(c,att,race,rk)
	return (c:IsRace(race) or c:IsAttribute(att)) and c:IsLevel(rk)
		and c:IsAbleToHand()
end
function c71280034.mvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function c71280034.chkfilter(c)
	return (c:IsFaceupEx() or c:IsLocation(LOCATION_EXTRA)) and c:IsCode(97403510)
end
function c71280034.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71280034.chkfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end
end
function c71280034.mvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71280034.chkfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	local ct=g:GetCount()
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rg=g:Select(tp,1,ct,nil)
	if rg:GetCount()>0 then
		local hg=rg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		local og=rg-hg
		Duel.ConfirmCards(1-tp,hg)
		Duel.HintSelection(og)
		Duel.Recover(tp,ct*1000,REASON_EFFECT)
	end
end