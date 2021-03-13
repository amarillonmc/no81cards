--时机巨人·伊尔吉吉
function c40009184.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009184,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,40009184)
	e1:SetCondition(c40009184.setcon1)
	e1:SetTarget(c40009184.thtg)
	e1:SetOperation(c40009184.thop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c40009184.nnegcost)
	e2:SetCondition(c40009184.setcon2)
	c:RegisterEffect(e2)  
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009184,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40009185)
	e3:SetTarget(c40009184.sptg)
	e3:SetOperation(c40009184.spop)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCost(c40009184.nnegcost)
	e4:SetCondition(c40009184.spcon2)
	c:RegisterEffect(e4)  
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40009185,2))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,40009182)
	e5:SetCondition(c40009184.tdcon1)
	e5:SetTarget(c40009184.tdtg)
	e5:SetOperation(c40009184.tdop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	e6:SetCost(c40009184.nnegcost)
	e6:SetCondition(c40009184.tdcon2)
	c:RegisterEffect(e6)   
end
function c40009184.nnegcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xf1c,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xf1c,3,REASON_COST)
end
function c40009184.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208))
end
function c40009184.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009184.filter(c)
	return c:IsSetCard(0xf1c) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(40009184)
end
function c40009184.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009184.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40009184.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40009184.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c40009184.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c40009184.splimit(e,c)
	return not (c:IsType(TYPE_XYZ) or c:IsSetCard(0xf1c)) and c:IsLocation(LOCATION_EXTRA)
end 
function c40009184.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208))
end
function c40009184.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009184.rmfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xf1c) and c:IsAbleToRemove() and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c40009184.spfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel(),e,tp)
end
function c40009184.spfilter(c,lv,e,tp)
	return c:IsLevel(lv+3) and c:IsSetCard(0xf1c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end

function c40009184.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009184.rmfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c40009184.rmfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c40009184.rmfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c40009184.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c40009184.retcon1)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		e1:SetOperation(c40009184.retop1)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c40009184.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel(),e,tp):GetFirst()
	if sg and Duel.SpecialSummonStep(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(40009184,3))
		e2:SetType(EFFECT_TYPE_SINGLE)
		--e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sg:RegisterEffect(e2)
		local fid=e:GetHandler():GetFieldID()
		sg:RegisterFlagEffect(40009184,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		sg:RegisterFlagEffect(sg:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(sg)
		e3:SetCondition(c40009184.retcon2)
		e3:SetOperation(c40009184.retop2)
		Duel.RegisterEffect(e3,tp)
	end
	Duel.SpecialSummonComplete()
end

function c40009184.retcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c40009184.retop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end
function c40009184.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(40009184)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c40009184.retop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c40009184.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and (not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208)))
end
function c40009184.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009184.tdfilter(c)
	return c:IsSetCard(0xf1c) and c:IsAbleToDeck() and c:IsFaceup()
end
function c40009184.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsAbleToDeck() and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c40009184.tdfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c40009184.tdfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function c40009184.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,e:GetHandler())
		if g:GetCount()==0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
