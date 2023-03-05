--初其狭，才通人
local m=11621403
local cm=_G["c"..m]
function c11621403.initial_effect(c)
	aux.AddCodeList(c,11621402,11621401)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1) 
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)   
end
cm.SetCard_THY_PeachblossomCountry=true 
--
function cm.filter(c,e,tp,mg)
	if bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	return (mg:GetCount())*2>=c:GetLevel()
end
function cm.matfilter(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then
		val=re:GetValue() 
	end
	return c:IsType(TYPE_TRAP) and (val==nil or val(re,c)~=true)
end
function cm.mfilter(c)
	return c:IsType(TYPE_TRAP) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
		if Duel.IsExistingMatchingCard(cm.mfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) then  
			local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
			mg:Merge(mg2)
		end
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
	local mg2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.mfilter),tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	mg:Merge(mg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)   
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		local num=tc:GetLevel()
		if num>1 then
			if num%2==0 then
				num=num/2
			else
				num=(num+1)/2
			end
		end 
		local tgg=mg:FilterSelect(tp,aux.TRUE,num,num,nil)
		local tgc=tgg:GetFirst()
		while tgc do
			--tc:SetMaterial(tgc)
			if tgc:IsControler(1-tp) then
				Duel.Remove(tgc,POS_FACEUP,REASON_EFFECT)
			else
				local ggg=Duel.Release(tgc,REASON_EFFECT)
				if ggg<1 then
					Duel.Release(tgc,REASON_COST)
				end
			end
			tgc=tgg:GetNext()
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		if not tc:IsRace(RACE_ZOMBIE) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(RACE_ZOMBIE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
--
function cm.tdfilter1(c)
	return c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.tdfilter2(c)
	return c:IsCode(11621402,11621401) and c:IsAbleToDeck()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(cm.tdfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter2,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(cm.tdfilter1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,5,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local sg=Duel.SelectMatchingCard(tp,cm.tdfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,c)
	g:Merge(sg)
	g:AddCard(e:GetHandler())
	if sg:GetCount()<=0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local tg=Duel.GetOperatedGroup()
	if tg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==5 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end