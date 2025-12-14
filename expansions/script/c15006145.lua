local m=15006145
local cm=_G["c"..m]
cm.name="无海热祖 涌泉再生螺"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,99)
	c:EnableReviveLimit()
	--self
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(m)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE)
end
function cm.xyzcheck(g)
	local xyzc=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m):GetFirst()
	local b1=(g:FilterCount(Card.IsXyzLevel,nil,xyzc,8)==#g)
	local b2=(g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and cm.gcheck(g,xyzc))
	return (b1 or b2) and #g>=2
end
function cm.decToHex(num)
	if num==0 then
		return "0"
	end
	local hexDigits="0123456789ABCDEF"
	local result=""
	local n=math.floor(num)
	while n>0 do
		local remainder=n%16
		result=string.sub(hexDigits,remainder+1,remainder+1)..result
		n=math.floor(n/16)
	end
	return result
end
function cm.gcheck(g,xyzc)
	local tc=g:GetFirst()
	local lvlist={}
	while tc do
		local lv=0
		if tc:IsType(TYPE_XYZ) then lv=tc:GetRank()
		else lv=tc:GetLevel() end
		table.insert(lvlist,lv)
		if tc:IsHasEffect(EFFECT_XYZ_LEVEL) then
			for _,i in ipairs{tc:IsHasEffect(EFFECT_XYZ_LEVEL)} do
				local x=i:GetValue()
				local lvx=cm.decToHex(x(i,tc,xyzc)-lv)/10000
				table.insert(lvlist,lvx)
			end
		end
		table.insert(lvlist,0)
		tc=g:GetNext()
	end
	local elements={}
	local currentElement={}
	for i=1,#lvlist do
		local num=lvlist[i]
		if num==0 then
			if #currentElement>0 then
				table.insert(elements,currentElement)
				currentElement={}
			end
		else
			table.insert(currentElement,num)
		end
	end
	if #elements<2 then
		return false
	end
	local function backtrack(index,currentSum,usedNumbers)
		if index>#elements then
			return currentSum==8
		end
		local currentElementNumbers=elements[index]
		for i=1,#currentElementNumbers do
			local num=currentElementNumbers[i]
			local newSum=currentSum+num
			if newSum<=8 then
				if backtrack(index+1,newSum,usedNumbers) then
					return true
				end
			end
		end
		return false
	end
	return backtrack(1,0,{})
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg2=g2:Select(tp,1,1,nil)
		dg1:Merge(dg2)
		if dg1:GetCount()==2 then
			Duel.HintSelection(dg1)
			Duel.Destroy(dg1,REASON_EFFECT)
		end
	end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.cfilter(c,tc)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6f44) and c:IsFaceupEx()
		and c:IsAbleToHand() and not c:IsCode(tc:GetCode())
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6f44) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,c,c)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.cfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,tc,tc)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
	end
end