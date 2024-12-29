local s,id,o=GetID()
function s.initial_effect(c)
	if not _G.dealergame then
		_G.dealergame=true
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_DRAW)
		ge0:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
		ge0:SetOperation(s.startop)
		Duel.RegisterEffect(ge0,0)
		local cge0=ge0:Clone()
		cge0:SetCode(EVENT_PREDRAW)
		Duel.RegisterEffect(cge0,0)
	end
end
function s.startop(e,tp,eg,ep,ev,re,r,rp)
	if _G.dealerplayer then
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CUSTOM+id)
		e1:SetOperation(s.adjust)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CUSTOM+id+1)
		e2:SetOperation(s.iswin1)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CUSTOM+id+2)
		e3:SetOperation(s.adjust)
		Duel.RegisterEffect(e3,0)
		s.carddeck={}
		s.drawnIndexes={}
		s.step=1
		for i=0,3 do
			for j=1,13 do
				table.insert(s.carddeck,65123100+20*i+j)
			end
		end
		s.dealcard(0,false)
		s.dealcard(0,false)
		s.dealcard(1,false)
		s.dealcard(1,false)
		local pg=Group.FromCards(Duel.GetFieldCard(0,LOCATION_MZONE,1),Duel.GetFieldCard(1,LOCATION_MZONE,0),Duel.GetFieldCard(1,LOCATION_MZONE,1))
		Duel.ChangePosition(pg,POS_FACEUP_ATTACK)
		s.iswin1()
	end
end
local A=1103515245
local B=12345
local M=32767
function s.rollrandom(min,max)
	if not s.random then
		local g=Duel.GetFieldGroup(0,0xff,0xff):RandomSelect(2,1)
		s.random=g:GetFirst():GetCode()+Duel.GetTurnCount()+Duel.GetFieldGroupCount(1,LOCATION_GRAVE,0)
	end
	min=tonumber(min)
	max=tonumber(max)
	s.random=((s.random*A+B)%M)/M
	if min~=nil then
		if max==nil then
			return math.floor(s.random*min)+1
		else
			max=max-min+1
			return math.floor(s.random*max+min)
		end
	end
	return s.random
end
function s.changecardcode(c)
	local availableIndexes={}
	for i=1,#s.carddeck do
		if not s.drawnIndexes[i] then
			table.insert(availableIndexes,i)
		end
	end
	if #availableIndexes==0 then
		Debug.Message("卡组已经空了")
		s.drawnIndexes={}
		for i=1,#s.carddeck do
			if not s.drawnIndexes[i] then
				table.insert(availableIndexes,i)
			end
		end
	end
	local randIndex=s.rollrandom(1,#availableIndexes)
	local chosenIndex=availableIndexes[randIndex]
	s.drawnIndexes[chosenIndex]=true
	local code=s.carddeck[chosenIndex]
	c:SetEntityCode(id,true)
	c:SetCardData(CARDDATA_CODE,code)
	c:ReplaceEffect(code,0)
end
function s.dealcard(tp,bool)
	local loc=LOCATION_MZONE
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then loc=LOCATION_SZONE end
	local seq=0
	for i=0,4 do
		if Duel.CheckLocation(tp,loc,i) then
			seq=i
			break
		end
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then
		Duel.SendtoDeck(Duel.CreateToken(tp,id),tp,0,REASON_RULE) 
	end
	local mc=Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetFirst()
	Duel.MoveToField(mc,tp,tp,loc,POS_FACEDOWN_ATTACK,false,2^seq)
	s.changecardcode(mc)
	if bool then Duel.ChangePosition(mc,POS_FACEUP_ATTACK) end
	local e0=Effect.CreateEffect(mc)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(TYPE_NORMAL+TYPE_MONSTER)
	mc:RegisterEffect(e0,true)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	mc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_RACE)
	e2:SetValue(RACE_ALL)
	mc:RegisterEffect(e2,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e3:SetValue(0xff)
	mc:RegisterEffect(e3,true)
	local lv=mc:GetOriginalCode()%20
	if lv>10 then
		lv=10
	elseif lv==1 then
		lv=11
	end
	local e1=Effect.CreateEffect(mc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetLabel(lv)
	e1:SetValue(s.getlv)
	mc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	mc:RegisterEffect(e2,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	mc:RegisterEffect(e3,true)
end
function s.getlv(e,c)
	local lv=e:GetLabel()
	if lv==11 and s.getscore(c:GetControler(),c)>=11 then return 1 end
	return lv
end
function s.cfilter(c)
	return c:GetOriginalCode()%20~=1
end
function s.adjust(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_ONFIELD,0,nil)
		local g1=g:Filter(s.cfilter,nil)
		local g2=g:Filter(aux.TRUE,g1)
		local num=0
		for tc in aux.Next(g1) do
			local lv=tc:GetOriginalCode()%20
			if lv>10 then lv=10 end
			num=num+lv
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(lv)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			tc:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_LEVEL)
			tc:RegisterEffect(e3,true)
		end
		for tc in aux.Next(g2) do	   
			local lv=1
			if num+g2:GetCount()<=11 then
				lv=11
			end
			num=num+lv
		end
	end
	--Duel.RaiseEvent(Group.CreateGroup(),EVENT_CUSTOM+id+s.step,e,0,1,1,0)
end
function s.getscore(tp,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,c)
	local g1=g:Filter(s.cfilter,nil)
	local g2=g:Filter(aux.TRUE,g1)
	local num=0
	for tc in aux.Next(g1) do
		local lv=tc:GetOriginalCode()%20
		if lv>10 then lv=10 end
		num=num+lv
	end
	for tc in aux.Next(g2) do	   
		local lv=1
		if num+g2:GetCount()<=11 then
			lv=11
		end
		num=num+lv
	end
	return num
end
function s.iswin1()
	local iscontinue=true
	while iscontinue do
		local score=s.getscore(1)
		if score>21 then
			iscontinue=false
			Duel.Hint(HINT_MESSAGE,0,aux.Stringid(id,10))
			Duel.Hint(HINT_MESSAGE,1,aux.Stringid(id,10))
			Duel.Win(0,0x0)
		elseif score~=21 and Duel.SelectYesNo(1,aux.Stringid(id,9)) then
			s.dealcard(1,true)
			--Duel.RaiseEvent(Group.CreateGroup(),EVENT_CUSTOM+id+1,e,0,1,1,0)  
		else
			iscontinue=false
			--Debug.ShowHint(".达拉崩巴斑得贝迪卜多比鲁翁>")
			Duel.ChangePosition(Duel.GetFieldCard(0,LOCATION_MZONE,0),POS_FACEUP_ATTACK)
			s.iswin2()
		end
	end
end
function s.iswin2() 
	local iscontinue=true
	while iscontinue do
		local score=s.getscore(0)
		if score>21 then
			iscontinue=false
			Duel.Hint(HINT_MESSAGE,0,aux.Stringid(id,10))
			Duel.Hint(HINT_MESSAGE,1,aux.Stringid(id,10))
			Duel.Win(1,0x0)
		elseif score<17 then
			s.dealcard(0,true)  
		else
			iscontinue=false
			if s.getscore(1)>s.getscore(0) then
				Duel.Hint(HINT_MESSAGE,0,aux.Stringid(id,11))
				Duel.Hint(HINT_MESSAGE,1,aux.Stringid(id,12))
				Duel.Win(1,0x0)
			elseif s.getscore(1)<s.getscore(0) then
				Duel.Hint(HINT_MESSAGE,0,aux.Stringid(id,12))
				Duel.Hint(HINT_MESSAGE,1,aux.Stringid(id,11))
				Duel.Win(0,0x0)
			else
				--Debug.ShowHint("达拉崩巴斑得贝迪卜多比鲁翁>")
				Duel.SendtoDeck(Duel.GetFieldGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD),tp,0,REASON_RULE)
				s.dealcard(0,false)
				s.dealcard(0,false)
				s.dealcard(1,false)
				s.dealcard(1,false)
				local pg=Group.FromCards(Duel.GetFieldCard(0,LOCATION_MZONE,1),Duel.GetFieldCard(1,LOCATION_MZONE,0),Duel.GetFieldCard(1,LOCATION_MZONE,1))
				Duel.ChangePosition(pg,POS_FACEUP_ATTACK)
				s.iswin1()
				--Duel.Win(PLAYER_NONE,0x0)
			end
		end
	end
end