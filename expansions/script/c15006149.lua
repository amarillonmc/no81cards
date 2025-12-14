local m=15006149
local cm=_G["c"..m]
cm.name="无海潮旋 终末审判官"
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
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.atcon)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(cm.atcon)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)
	--battle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.cost)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) then return end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc&LOCATION_ONFIELD~=0 and rc:GetFlagEffect(m)==0 then
		rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE)
end
function cm.xyzcheck(g)
	local xyzc=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m):GetFirst()
	local b1=(g:FilterCount(Card.IsXyzLevel,nil,xyzc,10)==#g)
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
			return currentSum==10
		end
		local currentElementNumbers=elements[index]
		for i=1,#currentElementNumbers do
			local num=currentElementNumbers[i]
			local newSum=currentSum+num
			if newSum<=10 then
				if backtrack(index+1,newSum,usedNumbers) then
					return true
				end
			end
		end
		return false
	end
	return backtrack(1,0,{})
end
function cm.atfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x6f44)
end
function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(cm.atfilter,1,nil)
end
function cm.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and tc:IsFaceup() and tc:GetFlagEffect(m)>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCondition(cm.actcon)
	e4:SetValue(1)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function cm.actcon(e)
	local a=Duel.GetBattleMonster(e:GetHandlerPlayer())
	return a and a:IsFaceup() and a:IsSetCard(0x6f44)
end