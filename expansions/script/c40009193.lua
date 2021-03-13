--时机工程师·伊巴特
function c40009193.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--set p
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009193,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,40009193)
	e1:SetCondition(c40009193.setcon1)
	e1:SetTarget(c40009193.settg)
	e1:SetOperation(c40009193.setop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c40009193.nnegcost)
	e2:SetCondition(c40009193.setcon2)
	c:RegisterEffect(e2)  
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009193,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40009194)
	e3:SetCondition(c40009193.spcon1)
	e3:SetTarget(c40009193.sptg)
	e3:SetOperation(c40009193.spop)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCost(c40009193.nnegcost)
	e4:SetCondition(c40009193.spcon2)
	c:RegisterEffect(e4)  
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40009193,2))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,40009194)
	e5:SetCondition(c40009193.tdcon1)
	e5:SetTarget(c40009193.tdtg)
	e5:SetOperation(c40009193.tdop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	e6:SetCost(c40009193.nnegcost)
	e6:SetCondition(c40009193.tdcon2)
	c:RegisterEffect(e6)
end
function c40009193.nnegcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xf1c,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xf1c,3,REASON_COST)
end
function c40009193.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler()) and (not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208)))
end
function c40009193.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler()) and Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009193.setfilter(c,e,tp)
	return c:IsSetCard(0xf1c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009193.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c40009193.setfilter,tp,LOCATION_PZONE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c40009193.setfilter,tp,LOCATION_PZONE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c40009193.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c40009193.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c40009193.splimit(e,c)
	return not (c:IsType(TYPE_XYZ) or c:IsSetCard(0xf1c)) and c:IsLocation(LOCATION_EXTRA)
end
function c40009193.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208))
end
function c40009193.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009193.filter1(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c40009193.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and c:IsSetCard(0xf1c) and c:IsType(TYPE_PENDULUM) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c40009193.filter2(c,e,tp,mc,rk)
	local rk=0
	if mc:IsType(TYPE_XYZ) then
		rk=mc:GetRank()
	else
		rk=mc:GetLevel()
	end
	return c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:GetRank()==rk+1
end
function c40009193.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c40009193.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c40009193.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c40009193.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40009193.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009193.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	end
	sc:CompleteProcedure()
end
function c40009193.retcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c40009193.retop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end
function c40009193.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(40009193)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c40009193.retop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c40009193.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and (not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208)))
end
function c40009193.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009193.tdfilter(c)
	return c:IsSetCard(0xf1c) and c:IsAbleToDeck() and c:IsFaceup()
end
function c40009193.cfilter(c)
	return c:IsSetCard(0xf1c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c40009193.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsAbleToDeck() and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c40009193.tdfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c40009193.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c40009193.tdfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c40009193.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local ac=ag:GetFirst()
	while ac do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ac:RegisterEffect(e1)
		ac=ag:GetNext()
	end
		end
	end
end

