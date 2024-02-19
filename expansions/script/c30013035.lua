--深土之下的护卫 森之徘徊者
local m=30013035
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_FLIP),cm.ft,2,2,true)
	--spsummon condition
	local e51=Effect.CreateEffect(c)
	e51:SetType(EFFECT_TYPE_SINGLE)
	e51:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e51:SetCode(EFFECT_SPSUMMON_CONDITION)
	e51:SetValue(aux.fuslimit)
	c:RegisterEffect(e51)
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(cm.con1)
	e2:SetTarget(cm.todtg)
	e2:SetOperation(cm.todop)
	c:RegisterEffect(e2)
	local e32=e2:Clone()
	e32:SetType(EFFECT_TYPE_QUICK_O)
	e32:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e32:SetCode(EVENT_FREE_CHAIN)
	e32:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e32:SetCondition(cm.con2)
	c:RegisterEffect(e32)
	--Effect 2  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e12:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetCountLimit(1,m+100)
	e12:SetCondition(cm.specon1)
	e12:SetCost(cm.specost)
	e12:SetTarget(cm.spetg)
	e12:SetOperation(cm.speop)
	c:RegisterEffect(e12)
	local e33=Effect.CreateEffect(c)
	e33:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e33:SetType(EFFECT_TYPE_QUICK_O)
	e33:SetCode(EVENT_FREE_CHAIN)
	e33:SetRange(LOCATION_GRAVE)
	e33:SetCountLimit(1,m+100)
	e33:SetCondition(cm.specon2)
	e33:SetCost(cm.specost)
	e33:SetTarget(cm.spetg)
	e33:SetOperation(cm.speop)
	c:RegisterEffect(e33)
end
function cm.ft(c)
	return c:IsFusionType(TYPE_FLIP) and c:IsFusionSetCard(0x92c)
end
--Effect 1
function cm.con1(e)
	local tsp=e:GetHandler():GetControler()
	return not Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.con2(e)
	local tsp=e:GetHandler():GetControler()
	return Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.todtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.todop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if #g>0 then
		local ct=#g
		if #g>=5 then ct=5 end
		local sg=g:FilterSelect(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),1,ct,nil)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if og>0 then
			Duel.BreakEffect() 
			Duel.Recover(tp,og*300,REASON_EFFECT)
		end
	end
end
--Effect 2
function cm.the(c)
	return c:IsAbleToHand() and c:IsType(TYPE_FLIP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.the,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.the),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local rcs=0
	if g:GetCount()>0 then
		local tcc=g:GetFirst()
		if Duel.SendtoHand(tcc,nil,REASON_EFFECT)>0 and tcc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tcc)
			if Duel.IsExistingMatchingCard(cm.rlfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local rg=Duel.SelectMatchingCard(tp,cm.rlfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,2,nil,tp)
				local tc3=rg:GetFirst()
				local tc5=rg:GetNext()
				if #rg==2 and tc3:GetOriginalType()&TYPE_FLIP~=0
					and tc5:GetOriginalType()&TYPE_FLIP~=0 then
					rcs=2
				end
				Duel.HintSelection(rg)
				local tg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
				tg:Sub(rg)
				if Duel.SendtoGrave(rg,REASON_EFFECT+REASON_RELEASE)>1 
					and #tg>0 and rcs==2 then
					if Duel.IsPlayerAffectedByEffect(tp,30013020) then 
						local tg3=tg:Select(tp,1,2,nil)  
						Duel.HintSelection(tg3) 
						Duel.SendtoHand(tg3,nil,REASON_EFFECT)
					else
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetCode(EVENT_PHASE+PHASE_END)
						e1:SetCountLimit(1)
						e1:SetCondition(cm.thcon5)
						e1:SetOperation(cm.thop5)
						e1:SetReset(RESET_PHASE+PHASE_END)
						Duel.RegisterEffect(e1,tp)
					end
				end
			end
		end
	end
end
function cm.rlfilter(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then
		val=re:GetValue()
	end
	return c:IsReleasableByEffect() or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsLocation(LOCATION_HAND) and (val==nil or val(re,c)~=true))
end
function cm.thcon5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function cm.thop5(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	if Duel.IsPlayerAffectedByEffect(tp,30013020) then
		ct=2
	end 
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
--Effect 3 
function cm.specon1(e)
	local c=e:GetHandler()
	local tsp=c:GetControler()
	return not Duel.IsPlayerAffectedByEffect(tsp,30013020) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.specon2(e)
	local c=e:GetHandler()
	local tsp=c:GetControler()
	return Duel.IsPlayerAffectedByEffect(tsp,30013020) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.specost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.spe(c,e,tp)
	return  c:IsType(TYPE_FLIP)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.spetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(cm.spe,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.speop(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,30013020) 
		and ft>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		ct=2 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spe),tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end  