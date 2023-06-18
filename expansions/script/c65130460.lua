--随机卡呼唤
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
--此处代码抄袭自随兴
local A=1103515245
local B=12345
local M=32767
function s.roll(min,max)
	min=tonumber(min)
	max=tonumber(max)
	s.r=((s.r*A+B)%M)/M
	if min~=nil then
		if max==nil then
			return math.floor(s.r*min)+1
		else
			max=max-min+1
			return math.floor(s.r*max+min)
		end
	end
	return s.r
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local cnum=Duel.AnnounceLevel(tp,1,3)
	Duel.SetTargetParam(cnum)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(".")
	local cnum=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	s.testop(e,1-tp,cnum,0)
end
function s.testop(e,tp,cnum,count)
	if not s.r then
		local result=0
		local g=Duel.GetFieldGroup(0,0xff,0xff):RandomSelect(2,8)
		local ct={}
		local c=g:GetFirst()
		for i=0,7 do
			ct[c]=i
			c=g:GetNext()
		end
		for i=0,10 do
			result=result+(ct[g:RandomSelect(2,1):GetFirst()]<<(3*i))
		end
		g:DeleteGroup()
		s.r=result&0xffffffff
	end
	count=count+1
	if count>5 then Debug.Message("第"..count.."次了") end
	if count==10 then Debug.Message("要不投了吧") end
	if count==50 then Debug.Message("你是真的闲啊") end
	if count==100 then Debug.Message("套娃200次系统就会自动叫停了，加油") end
	if count==199 then Debug.Message("可喜可贺") end
	local ac=nil
	local _TGetID=GetID
	local tab1={}
	local IsFalse=false
	for i=1,cnum do
		while not ac do
			
			local int=s.roll(1,132000015)
			--continuously updated
			if int>132000000 and int<132000014 then int=int+739100000 end
			if int==132000014 then int=460524290 end
			if int==132000015 then int=978210027 end
			local cc,ca,ctype=Duel.ReadCard(int,CARDDATA_CODE,CARDDATA_ALIAS,CARDDATA_TYPE)
			if cc then
				local dif=cc-ca
				local real=0
				if dif>-10 and dif<10 then
					real=ca
				else
					real=cc
				end
				if ctype&TYPE_TOKEN==0 then
					ac=real
				end
			end	  
		end
		table.insert(tab1,ac)
		ac=nil
	end
	for i=1,cnum do
		Duel.Hint(HINT_CARD,tp,tab1[i])
	end
	for i=1,cnum do
		ac=Duel.AnnounceCard(tp)
		if ac~=tab1[i] then 
			Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(id,0))
			IsFalse=true
			break
		end
	end
	if IsFalse then
		s.testop(e,tp,cnum,count)
	else
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(id,1))
		if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			s.testop(e,1-tp,cnum,0)
		end
	end
end