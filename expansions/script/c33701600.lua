--融入银色的幻想之流吧！
local m=33701600
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,33701601)
	--Ritual Summon	 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(33701600)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--protection
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.chtg)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end  
--Ritual Summon
function cm.filter(c,e,tp,mg)
	if bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or not c:IsCode(33701601) then return false end
	return mg:GetCount()>=c:GetLevel()
end
function cm.matfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave() and (c:GetActivateEffect():GetCategory()&CATEGORY_COIN~=0 or c:GetActivateEffect():GetCategory()&CATEGORY_DICE~=0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())==0 then
		loc=loc+LOCATION_DECK
	end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(cm.matfilter,tp,loc,0,nil)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())==0 then
		loc=loc+LOCATION_DECK
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,loc,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		local num=tc:GetLevel()
		local tgg=mg:FilterSelect(tp,aux.TRUE,num,num,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tgg,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
		Duel.BreakEffect()
		if tgg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
		end
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--protection
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cm.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and rc:IsCode(33701601) and ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end