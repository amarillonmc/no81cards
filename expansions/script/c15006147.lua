local m=15006147
local cm=_G["c"..m]
cm.name="无海共鸣 啸波压制铁"
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
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.discon)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.descost)
	e2:SetOperation(cm.desop)
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
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.NegateMonsterFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.des2con)
	e2:SetOperation(cm.des2op)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.des2filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsSetCard(0x6f44)
end
function cm.des2con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.des2filter,1,nil,tp) and Duel.GetFlagEffect(tp,m)==0
end
function cm.des2op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_CARD,1-tp,15006147)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		if tc then
			Duel.HintSelection(Group.FromCards(tc))
			Duel.Destroy(tc,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end