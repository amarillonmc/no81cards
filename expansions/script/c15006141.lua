local m=15006141
local cm=_G["c"..m]
cm.name="无海回声 巡弋声翼鳐"
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
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
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
	local b1=(g:FilterCount(Card.IsXyzLevel,nil,xyzc,6)==#g)
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
			return currentSum==6
		end
		local currentElementNumbers=elements[index]
		for i=1,#currentElementNumbers do
			local num=currentElementNumbers[i]
			local newSum=currentSum+num
			if newSum<=6 then
				if backtrack(index+1,newSum,usedNumbers) then
					return true
				end
			end
		end
		return false
	end
	return backtrack(1,0,{})
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x6f44) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.filter(c)
	return c:IsCanOverlay() and c:IsFaceup()
end
function cm.xspfilter(c,mg,sc)
	return c:IsSetCard(0x6f44) and c:IsType(TYPE_XYZ) and mg:CheckSubGroup(cm.gselect,1,#mg,c,sc)
end
function cm.gselect(sg,c,sc)
	return sg:IsContains(sc) and c:IsXyzSummonable(sg,#sg,#sg)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.AdjustAll()
		local mg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
		local exg=Duel.GetMatchingGroup(cm.xspfilter,tp,LOCATION_EXTRA,0,nil,mg,tc)
		if exg:GetCount()>0 and tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) and tc:IsFaceup() and tc:IsType(TYPE_TUNER)
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=exg:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=mg:SelectSubGroup(tp,cm.gselect,false,1,mg:GetCount(),tg:GetFirst(),tc)
			Duel.XyzSummon(tp,tg:GetFirst(),sg,#sg,#sg)
		end
	end
end