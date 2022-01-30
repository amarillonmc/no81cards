--刻神编年史-時空巨兵

c40009538.named_with_Chrono=1
function c40009538.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--set p
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009538,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,40009538)
	e1:SetCondition(c40009538.setcon1)
	e1:SetTarget(c40009538.thtg)
	e1:SetOperation(c40009538.thop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c40009538.nnegcost)
	e2:SetCondition(c40009538.setcon2)
	c:RegisterEffect(e2) 
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009538,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40009539)
	e3:SetCondition(c40009538.spcon1)
	e3:SetTarget(c40009538.sptg)
	e3:SetOperation(c40009538.spop)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCost(c40009538.nnegcost)
	e4:SetCondition(c40009538.spcon2)
	c:RegisterEffect(e4)  
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40009538,2))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,40009539)
	e5:SetCondition(c40009538.tdcon1)
	e5:SetTarget(c40009538.tdtg)
	e5:SetOperation(c40009538.tdop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	e6:SetCost(c40009538.nnegcost)
	e6:SetCondition(c40009538.tdcon2)
	c:RegisterEffect(e6)   
	
end
function c40009538.nnegcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xf1c,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xf1c,3,REASON_COST)
end
function c40009538.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xf1c) and (not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208)))
end
function c40009538.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xf1c) and Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009538.sppfilter1(c,e,tp)
	return c:IsSetCard(0xf1c) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.IsExistingMatchingCard(c40009538.sppfilter2,tp,LOCATION_DECK,0,1,c,e,tp,c:GetLevel()) and not c:IsCode(40009538)
end
function c40009538.sppfilter2(c,e,tp,lv)
	return c:IsSetCard(0xf1c) and c:IsType(TYPE_MONSTER) and not c:IsLevel(lv) and c:IsLevelAbove(1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c40009538.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c40009538.sppfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c40009538.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if dg:GetCount()<2 then return end
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c40009538.sppfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		local tc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40009538.sppfilter2),tp,LOCATION_DECK,0,1,1,tc,e,tp,tc:GetLevel())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c40009538.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c40009538.splimit(e,c)
	return not (c:IsType(TYPE_XYZ) or c:IsSetCard(0xf1c)) and c:IsLocation(LOCATION_EXTRA)
end
function c40009538.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208))
end
function c40009538.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009538.filter1(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c40009538.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c40009538.filter2(c,e,tp,mc,rk)
	local rk=0
	if mc:IsType(TYPE_XYZ) then
		rk=mc:GetRank()
	else
		rk=mc:GetLevel()
	end
	return c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:GetRank()==rk+1
end
function c40009538.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c40009538.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c40009538.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c40009538.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40009538.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009538.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
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
function c40009538.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and (not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208)))
end
function c40009538.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009538.tdfilter(c)
	return c:IsSetCard(0xf1c) and c:IsAbleToDeck() and c:IsFaceup()
end
function c40009538.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsAbleToDeck() and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c40009538.tdfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c40009538.tdfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,5,0,0xf1c)
end
function c40009538.ctfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xf1c) and c:IsType(TYPE_CONTINUOUS) and c:IsCanAddCounter(0xf1c,5)
end
function c40009538.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		local g=Duel.SelectMatchingCard(tp,c40009538.ctfilter1,tp,LOCATION_SZONE,0,1,1,nil)
		if g:GetCount()==0 then return end
		Duel.BreakEffect()
		local pc=g:GetFirst()
			if pc then
				pc:AddCounter(0xf1c,5)
			end
		end
	end
end







