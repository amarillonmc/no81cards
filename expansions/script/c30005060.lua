--深海之潜影 塔芭丝可
local m=30005060
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.NonTuner(cm.synfilter),nil,nil,aux.Tuner(cm.synfilter1),2,99)
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--double tuner
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetCode(21142671)
	c:RegisterEffect(ea)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(cm.setcon)
	e1:SetTarget(cm.settg)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)
	--Effect 2 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(cm.con)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op1)
	c:RegisterEffect(e3)  
	--Effect 3 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(cm.con1)
	e4:SetTarget(cm.tg1)
	e4:SetOperation(cm.op2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(cm.valcheck)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
cm.material_type=TYPE_SYNCHRO
--synchro summon
function cm.synfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSynchroType(TYPE_SYNCHRO)
end
function cm.synfilter1(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
--Effect 1
function cm.tffilter(c,tp,tc)
	return c:IsCode(tc:GetCode()) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.setfilter(c)
	return c:IsAbleToRemove()
end
function cm.setfilter1(c,tc)
	return c:IsCode(tc:GetCode()) and c:IsSSetable()
end
function cm.filter5(c,e,tp,tc)
	return c:IsCode(tc:GetCode()) and (c:IsCanBeSpecialSummoned(e,0,tp,true,false) or (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)))
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetCurrentPhase()~=PHASE_END
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and cm.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.setfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.setfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			if tc:IsType(TYPE_CONTINUOUS+TYPE_FIELD) 
			and not tc:IsForbidden() and tc:CheckUniqueOnField(tp)
			and (not tc:IsSSetable() or Duel.SelectOption(tp,1153,aux.Stringid(m,1))==1) then
				if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local tc1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tffilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp,tc):GetFirst()
				if tc1:IsType(TYPE_FIELD) then
					Duel.MoveToField(tc1,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				else
					Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tc):GetFirst()
				if g then
					Duel.SSet(tp,g)
				end
			end
		end
		if tc:IsType(TYPE_MONSTER) and not tc:IsType(TYPE_SPELL+TYPE_TRAP) then 
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter5),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,tc)
			local tc3=g1:GetFirst()
			if g1:GetCount()>0 and (not tc3:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) or Duel.SelectOption(tp,1153,1152)==1) then
				Duel.SpecialSummon(tc3,0,tp,tp,true,false,POS_FACEUP)
			else
				Duel.SpecialSummon(tc3,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc3)
			end
		end
	end
end
--Effect 2
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,nil)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,1-tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		local g5=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local g7=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		Duel.ConfirmCards(tp,g7)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,g5)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local tc2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil):GetFirst()
		if tc1 and tc2 then
			local g3=Group.FromCards(tc1,tc2)
			Duel.SendtoDeck(g3,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
			if ct>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(63166095,0)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
			if ct>0 and Duel.IsPlayerCanDraw(1-tp,1) and Duel.SelectYesNo(1-tp,aux.Stringid(63166095,0)) then
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
			Duel.ShuffleHand(1-tp)
			Duel.ShuffleHand(tp)
		end
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(e:GetHandler()) and Duel.IsChainDisablable(ev)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
		local g5=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local g7=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		Duel.ConfirmCards(tp,g7)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,g5)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local tc2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil):GetFirst()
		if tc1 and tc2 then
			local g3=Group.FromCards(tc1,tc2)
			Duel.SendtoDeck(g3,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
			if ct>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(63166095,0)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
			if ct>0 and Duel.IsPlayerCanDraw(1-tp,1) and Duel.SelectYesNo(1-tp,aux.Stringid(63166095,0)) then
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
			Duel.ShuffleHand(1-tp)
			Duel.ShuffleHand(tp)
		end
	end
--Effect 3 
function cm.valcheck(e,c)
	local ct=e:GetHandler():GetMaterial():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)
	e:GetLabelObject():SetLabel(ct)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function cm.todeckfilter(c)
	return c:IsAbleToDeck() and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsExtraDeckMonster() 
		and Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_EXTRA)  then
			if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.todeckfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil)
				if g:GetCount()>0 then
					Duel.HintSelection(g)
					Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
				end
			end
	end
end