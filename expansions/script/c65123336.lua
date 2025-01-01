--斗地主
local s,id,o=GetID()
function s.initial_effect(c)
	if not _G.dealergame then
		_G.dealergame=true
		s.lastcard=Group.CreateGroup()
		local ge0=Effect.CreateEffect(c)
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
local Single=1
local Pair=2
local ThreeOfAKind=3
local Bomb=4
local ThreeWithOne=5
local ThreeWithTwo=6
local FourWithTwo=7
local Straight=8
local KingBomb=9
local Pairs=10
local Flight0=11
local Flight1=12
local Flight2=13
local playercount=2
local landlord=1
function s.startop(e,tp,eg,ep,ev,re,r,rp)
	if _G.dealerplayer then
		local c=e:GetHandler()
		Duel.SendtoExtraP(c,1,REASON_RULE)
		Debug.Message("发牌姬提示：发牌完成后请不要随意点击洗牌！如果牌的顺序被打乱了，可以在自己回合点击额外卡组的发牌姬重新整理手卡")
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
		e1:SetOperation(s.sortop)
		c:RegisterEffect(e1,true)
		s.carddeck={}
		s.drawnIndexes={}
		s.IsHuman={false,false,false,false}
		s.step=1
		for i=0,3 do
			for j=1,13 do
				table.insert(s.carddeck,65123100+20*i+j)
			end
		end
		table.insert(s.carddeck,65123176)
		table.insert(s.carddeck,65123177)
		s.skip()
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PREDRAW)
		ge0:SetOperation(s.startop2)
		Duel.RegisterEffect(ge0,0)
		--rule
		--cannot set
		local re0=Effect.GlobalEffect()
		re0:SetType(EFFECT_TYPE_FIELD)
		re0:SetCode(EFFECT_CANNOT_SSET)
		re0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		re0:SetTargetRange(1,1)
		re0:SetTarget(aux.TRUE)
		Duel.RegisterEffect(re0,0)
		local re1=Effect.GlobalEffect()
		re1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		re1:SetType(EFFECT_TYPE_FIELD)
		re1:SetCode(EFFECT_CANNOT_BP)
		re1:SetTargetRange(1,1)
		Duel.RegisterEffect(re1,0)
		local re2=Effect.GlobalEffect()
		re2:SetType(EFFECT_TYPE_FIELD)
		re2:SetCode(EFFECT_HAND_LIMIT)
		re2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		re2:SetTargetRange(1,1)
		re2:SetValue(100)
		Duel.RegisterEffect(re2,0)

		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(s.handcon)
		e1:SetOperation(s.handop)
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		ge1:SetLabelObject(e1)
		Duel.RegisterEffect(ge1,0)
		--must use
		local e2=e1:Clone()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCondition(s.handcon2)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		ge2:SetLabelObject(e2)
		Duel.RegisterEffect(ge2,0)
	end
	e:Reset()
end
function s.cfilter(c)
	return c:GetOriginalCode()==id and c:IsFaceup()
end
function s.startop2(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	if Duel.IsExistingMatchingCard(s.cfilter,1,LOCATION_EXTRA,0,1,nil) then
		s.dealcard2(17,0)
		s.dealcard2(17,1)
		s.skip()
	else
		Debug.Message("多人模式测试中...")
		playercount=4
		local pc=Duel.CreateToken(0,id)
		Duel.SendtoExtraP(pc,1,REASON_RULE)
		local e1=Effect.CreateEffect(pc)
		e1:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
		e1:SetOperation(s.sortop)
		pc:RegisterEffect(e1,true)
		if s.humancheck(0) then
			s.IsHuman[1]=true
			s.dealcard2(17,0)		  
		else
			landlord=2
			Debug.Message("1号位玩家被识别为人机！")
		end
		if s.humancheck(1) then
			s.IsHuman[2]=true
			s.dealcard2(17,1)
		else			
			Debug.Message("2号位玩家被识别为人机！")
		end
		s.skip(2)
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PREDRAW)
		ge0:SetOperation(s.startop3)
		Duel.RegisterEffect(ge0,0)
	end
end
function s.humancheck(tp)
	if Duel.SelectYesNo(tp,1214) then
		return false 
	else
		return true
	end
end
function s.skip(count)
	if not count then count=1 end
	local p=Duel.GetTurnPlayer()
	turn1=(count-count%2)/2+count%2
	turn2=(count-count%2)/2
	Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,count)
	Duel.RegisterFlagEffect(1,id,RESET_PHASE+PHASE_END,0,count)
	Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE+PHASE_END,turn1)
	Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE+PHASE_END,turn1)
	Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,turn1)
	Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_END,turn1,1)
	Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,turn1)
	if turn2>0 then
		Duel.SkipPhase(1-p,PHASE_DRAW,RESET_PHASE+PHASE_END,turn2)
		Duel.SkipPhase(1-p,PHASE_STANDBY,RESET_PHASE+PHASE_END,turn2)
		Duel.SkipPhase(1-p,PHASE_MAIN1,RESET_PHASE+PHASE_END,turn2)
		Duel.SkipPhase(1-p,PHASE_BATTLE,RESET_PHASE+PHASE_END,turn2,1)
		Duel.SkipPhase(1-p,PHASE_MAIN2,RESET_PHASE+PHASE_END,turn2)
	end
end
function s.skiptoplayer(pid)
	local turn=4-(Duel.GetTurnCount()-pid+playercount)%playercount
	if turn==4 then return end
	s.skip(turn)
end
function s.startop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(Duel.GetTurnPlayer(),id)>0 then return end
	e:Reset()
	if s.humancheck(0) then
		s.IsHuman[3]=true
	else
		Debug.Message("3号位玩家被识别为人机！")
	end
	if s.humancheck(1) then
		s.IsHuman[4]=true
	else
		Debug.Message("4号位玩家被识别为人机！")	  
	end
	local count=0   
	for i=1,4 do
		if s.IsHuman[i]==true then
			count=count+1
		end
	end
	if count~=3 then
		Debug.Message("人机的数量似乎有些不太对劲...让我们重新开始这一局")
		Duel.Win(PLAYER_NONE,0x0)
	else
		if s.IsHuman[3]==true then s.dealcard2(17,0) end
		if s.IsHuman[4]==true then s.dealcard2(17,1) end
		s.skiptoplayer(landlord)
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PREDRAW)
		ge0:SetOperation(s.landlords)
		Duel.RegisterEffect(ge0,0)
	end
end
function s.landlords(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetTurnCount()-1)%playercount+1==landlord then
		Debug.Message(landlord.."号位玩家成为地主！")
		s.dealcard(3,Duel.GetTurnPlayer())
		e:Reset()
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
	if c then
		local code=s.carddeck[chosenIndex]
		c:SetEntityCode(id,true)
		c:SetCardData(CARDDATA_CODE,code)
		c:ReplaceEffect(code,0)
	end
	return s.carddeck[chosenIndex]
end
function s.sortcompare(a,b)
	local pa=s.getpoint(a)
	local pb=s.getpoint(b)
	return pa>pb or pa==pb and a>b
end
function s.dealcard(count,tp)
	if not tp then tp=Duel.GetTurnPlayer() end
	for i=1,count do
		local seq=(i-1)%5
		local loc=i%10<=5 and LOCATION_MZONE or LOCATION_SZONE	
		local mc=Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetFirst()
		if not mc then mc=Duel.CreateToken(tp,id) end
		Duel.MoveToField(mc,tp,tp,loc,POS_FACEUP_ATTACK,false,2^seq) 
		s.changecardcode(mc)
		if i%10==0 then
			local mg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
			Duel.ConfirmCards(0,mg)
			Duel.ConfirmCards(1,mg)
			Duel.SendtoHand(mg,tp,REASON_RULE)
		end
	end
	local mg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	Duel.ConfirmCards(0,mg)
	Duel.ConfirmCards(1,mg)
	Duel.SendtoHand(mg,tp,REASON_RULE)
	s.sortop(nil,tp)
end
function s.dealcard2(count,tp)
	if not tp then tp=Duel.GetTurnPlayer() end
	local codetable={}
	for i=1,count do
		table.insert(codetable,s.changecardcode())
	end
	table.sort(codetable,s.sortcompare)
	local oc=Duel.GetFieldGroup(tp,LOCATION_EXTRA,LOCATION_EXTRA):GetFirst()
	if oc then
		local g=Group.CreateGroup()
		local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		for i=1,count do
			local mc=dg:GetFirst()
			if not mc then
				mc=Duel.CreateToken(tp,id)
				Duel.SendtoDeck(mc,tp,0,REASON_RULE)
			end
			dg:RemoveCard(mc)
			g:AddCard(mc)
		end
		Duel.DisableShuffleCheck()
		local tc=g:GetFirst()
		for i=count,1,-1 do
			Duel.Overlay(oc,tc)
			local code=codetable[i]
			tc:SetEntityCode(id,true)
			tc:SetCardData(CARDDATA_CODE,code)
			tc:ReplaceEffect(code,0)
			Duel.DisableShuffleCheck()
			Duel.SendtoDeck(tc,tp,0,REASON_RULE)
			tc=g:GetNext()
		end
		Duel.Draw(tp,count,REASON_RULE)
		--Duel.ShuffleHand(tp)
	else
		s.dealcard(tp)
	end
end
function s.getpoint(c)
	if aux.GetValueType(c)=="Card" then
		local point=c:GetOriginalCode()%20
		if point==1 or point==2 then point=point+13 end
		return point
	elseif aux.GetValueType(c)=="number" then
		local point=c%20
		if point==1 or point==2 then point=point+13 end
		return point
	end
	return 0
end
function s.neop(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		Duel.NegateActivation(i)
	end
	Duel.SendtoGrave(Duel.GetFieldGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD),REASON_RULE)
	s.lastcard:Clear()
	
end
function s.pairfilter(c,point)
	return s.getpoint(c)==point or c:GetCode()%20==point
end
function s.flightable(c,table,count)
	local point=c:GetCode()%20
	 for _,v in ipairs(table) do
		if v>=point and v<=point+count-1 then
			return true
		end
	end
	return false
end
function s.straightfilter(c,min,max,cp)
	local point=c:GetCode()%20
	return point~=cp and (point>=min and point<=max or point==1 and max==14)
end
function s.checkStraight(c,g)
	local codetable={}
	for i=1,14 do
		codetable[i]=false
	end
	for tc in aux.Next(g) do
		local point=tc:GetCode()%20
		if point==1 then codetable[14]=true end
		codetable[point]=true
	end
	local count=0
	local cpoint=c:GetCode()%20
	local min=math.max(1,cpoint-4)
	local max=math.min(14,cpoint+4)
	for i=min,max do
		if codetable[i]==true then
			count=count+1		
		else
			if count>=5 then
				return true,i-count,i-1
			end
			count=0
		end
	end
	if count>=5 then
		return true,max-count+1,max
	end
	if cpoint==1 then
		for i=10,14 do
			if codetable[i]~=true then
				return false
			end
		end
		return true,10,14
	end
	return false,nil,nil
end
function s.checkStraight2(point,g)
	local codetable={}
	for i=1,15 do
		codetable[i]=false
	end
	for tc in aux.Next(g) do
		local point=tc:GetCode()%20
		if point==1 then codetable[14]=true end
		codetable[point]=true
	end
	local count=0
	local cardtable={}
	for i=point+1,15 do
		if codetable[i]==true then
			count=count+1
		else
			if count>=5 then
				table.insert(cardtable,{min=i-count,max=i-1})
			end
			count=0
		end
	end
	return cardtable
end
function s.fstraight(g,c)
	return g:IsContains(c) and g:GetClassCount(s.getpoint)==g:GetCount()
end
function s.pointdown(c,point)
	return s.getpoint(c)<point
end
function s.pointsame(c,point)
	return s.getpoint(c)==point
end
function s.pointup(c,point)
	return s.getpoint(c)>point
end
function s.updownfilter(c,min,max)
	local point=c:GetCode()%20
	if max==1 and point==13 then return true end
	return point==max+1 or point==min-1
end
function s.fpair(g)
	return g:GetClassCount(s.getpoint)==1
end
function s.fpair1(g,hg)
	local eg=hg:Filter(aux.TRUE,g)
	return g:GetClassCount(s.getpoint)==1 and eg:GetCount()>0
end
function s.fpair2(g,hg)
	local eg=hg:Filter(aux.TRUE,g)
	return g:GetClassCount(s.getpoint)==1 and eg:CheckSubGroup(s.fpair,2,2)
end
function s.fflight(g,hg)
	local eg=hg:Filter(aux.TRUE,g)	
	return g:GetClassCount(s.getpoint)==1 and eg:CheckSubGroup(s.fpair,3,3)
end
function s.handcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandlerPlayer()==Duel.GetTurnPlayer()
end
function s.handcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandlerPlayer()==Duel.GetTurnPlayer() and Duel.GetFlagEffect(Duel.GetTurnPlayer(),id)==0
end
function s.handop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetTurnPlayer()
	local pid=(Duel.GetTurnCount()-1)%playercount+1
	local point=s.getpoint(c)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	local sg=Group.FromCards(c)
	local cg=g:Filter(s.pairfilter,c,point)
	local cardtype=Single
	local isstraight,min,max=s.checkStraight(c,g)
	if isstraight then  
		cg:Merge(g:Filter(s.straightfilter,c,min,max,c:GetCode()%20))
	end
	if point==16 or point==17 then
		cg:Merge(g:Filter(s.pointsame,c,33-point))
	end
	while true do
		local sc=cg:SelectUnselect(sg,p,true,true,0,1)
		if sc then
			if sg:IsContains(sc) then return end
			sg:AddCard(sc)
			cg:RemoveCard(sc)
			if s.getpoint(sc)==16 or s.getpoint(sc)==17 then
				cardtype=KingBomb
				cg:Clear()
			elseif s.getpoint(sc)==point then
				cardtype=sg:GetCount()
				cg=cg:Filter(s.pairfilter,c,s.getpoint(sc))
			else
				local cpoint=sc:GetCode()%20
				cardtype=Straight
				min=math.max(min,cpoint-4)
				if cpoint==1 then max=14 else max=math.min(max,cpoint+4) end
				cg=cg:Filter(s.straightfilter,c,min,max,c:GetCode()%20)
				cg=cg:Filter(s.straightfilter,c,min,max,cpoint)
			end
		else
			if cardtype==Straight and sg:GetCount()<5 then return end
			break
		end
	end
	local eg=g:Filter(aux.TRUE,sg)
	if cardtype==ThreeOfAKind and eg:GetCount()>0 and Duel.SelectYesNo(p,aux.Stringid(id,2)) then
		while sg:GetCount()<5 do
			local sc=eg:SelectUnselect(sg,p,true,true,0,1)
			if sc then
				if sg:IsContains(sc) then return end
				sg:AddCard(sc)
				eg:RemoveCard(sc)
				eg=eg:Filter(s.pairfilter,c,s.getpoint(sc))
			else
				break
			end
		end
		cardtype=sg:GetCount()==4 and ThreeWithOne or ThreeWithTwo
	end
	local fmax=c:GetCode()%20
	local fmin=c:GetCode()%20
	eg=g:Filter(aux.TRUE,sg)
	local fg=g:Filter(s.updownfilter,sg,fmin,fmax)
	while (cardtype==ThreeOfAKind or cardtype==Flight0) and fg:CheckSubGroup(s.fpair,3,3) and Duel.SelectYesNo(p,aux.Stringid(id,3)) do  
		mg=fg:SelectSubGroup(p,s.fpair1,true,3,3,eg)
		if mg and mg:GetCount()==3 then
			local cpoint=mg:GetFirst():GetCode()%20
			fmin=math.min(fmin,cpoint)
			fmax=math.max(fmax,cpoint)
			sg:Merge(mg)
			cardtype=Flight0
			fg=g:Filter(s.updownfilter,sg,fmin,fmax)
			eg=g:Filter(aux.TRUE,sg)
		else
			break
		end
	end
	while (cardtype==ThreeWithOne or cardtype==Flight1) and fg:CheckSubGroup(s.fpair1,3,3,eg) and Duel.SelectYesNo(p,aux.Stringid(id,3)) do  
		mg=fg:SelectSubGroup(p,s.fpair1,true,3,3,eg)
		if mg and mg:GetCount()==3 then
			local cpoint=mg:GetFirst():GetCode()%20
			fmin=math.min(fmin,cpoint)
			fmax=math.max(fmax,cpoint)
			mg:Merge(g:Select(p,1,1,Group.__add(mg,sg)))
			sg:Merge(mg)
			cardtype=Flight1
			fg=g:Filter(s.updownfilter,sg,fmin,fmax)
			eg=g:Filter(aux.TRUE,sg)
		else
			break
		end
	end
	while (cardtype==ThreeWithTwo or cardtype==Flight2) and fg:CheckSubGroup(s.fpair2,3,3,eg) and Duel.SelectYesNo(p,aux.Stringid(id,3)) do  
		mg=fg:SelectSubGroup(p,s.fpair2,true,3,3,eg)
		if mg and mg:GetCount()==3 then
			local cpoint=mg:GetFirst():GetCode()%20
			fmin=math.min(fmin,cpoint)
			fmax=math.max(fmax,cpoint)
			mg:Merge(g:Filter(aux.TRUE,Group.__add(mg,sg)):SelectSubGroup(p,s.fpair,true,2,2))
			sg:Merge(mg)
			cardtype=Flight2
			fg=g:Filter(s.updownfilter,sg,fmin,fmax)
			eg=g:Filter(aux.TRUE,sg)
		else
			break
		end
	end
	if cardtype==Bomb and eg:GetCount()>=2 and Duel.SelectYesNo(p,aux.Stringid(id,4)) then
		mg=eg:Select(p,2,2,nil)
		if mg and mg:GetCount()==2 then
			sg:Merge(mg)
			cardtype=FourWithTwo
		end
	end
	if cardtype==Straight then point=min end
	if cardtype==Flight1 then point=fmin end
	s.lastcard=sg
	s.movecard(cardtype,sg)
	s.skip()
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge0:SetCode(EVENT_PREDRAW)
	ge0:SetLabel(cardtype,point,pid)
	ge0:SetOperation(s.chainop)
	Duel.RegisterEffect(ge0,0)
end
function s.movecard(cardtype,mg)
	local p=Duel.GetTurnPlayer()
	local g=Duel.GetFieldGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_RULE) end
	if cardtype==Single then
		Duel.MoveToField(mg:GetFirst(),p,p,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2^2)
	elseif cardtype==Pair then
		local tc=mg:GetFirst()
		for i=1,2 do		   
			Duel.MoveToField(tc,p,p,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2^i)
			tc=mg:GetNext()
		end
	elseif cardtype==ThreeOfAKind then
		local tc=mg:GetFirst()
		for i=1,3 do
			Duel.MoveToField(tc,p,p,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2^i)
			tc=mg:GetNext()
		end
	elseif cardtype==Bomb then
		local tc=mg:GetFirst()
		for i=0,3 do
			Duel.MoveToField(tc,p,p,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2^i)
			tc=mg:GetNext()
		end
	elseif cardtype==ThreeWithOne then
		local mg1=mg:GetMaxGroup(s.getpoint)
		if mg1:GetCount()<3 then mg1=mg:GetMinGroup(s.getpoint) end
		local tc=mg1:GetFirst()
		for i=0,2 do
			Duel.MoveToField(tc,p,p,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2^i)
			tc=mg1:GetNext()
		end
		local mg2=mg:Filter(aux.TRUE,mg1)
		local tc=mg2:GetFirst()
		Duel.MoveToField(tc,p,p,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2^3)
	elseif cardtype==ThreeWithTwo then
		local mg1=mg:GetMaxGroup(s.getpoint)
		if mg1:GetCount()<3 then mg1=mg:GetMinGroup(s.getpoint) end
		local tc=mg1:GetFirst()
		for i=0,2 do
			Duel.MoveToField(tc,p,p,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2^i)
			tc=mg1:GetNext()
		end
		local mg2=mg:Filter(aux.TRUE,mg1)
		local tc=mg2:GetFirst()
		for i=3,4 do
			Duel.MoveToField(tc,p,p,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2^i)
			tc=mg2:GetNext()
		end
	elseif cardtype==FourWithTwo then
		local mg1=mg:GetMaxGroup(s.getpoint)
		if mg1:GetCount()<4 then mg1=mg:GetMinGroup(s.getpoint) end
		local tc=mg1:GetFirst()
		for i=0,3 do
			Duel.MoveToField(tc,p,p,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2^i)
			tc=mg1:GetNext()
		end
		local mg2=mg:Filter(aux.TRUE,mg1)
		local tc=mg2:GetFirst()
		for i=0,1 do
			Duel.MoveToField(tc,p,p,LOCATION_SZONE,POS_FACEUP,false,2^i)
			tc=mg2:GetNext()
		end
	elseif cardtype==KingBomb then
		local tc=mg:GetFirst()
		Duel.MoveToField(tc,p,p,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2^1)
		Duel.MoveSequence(tc,5)
		tc=mg:GetNext()
		Duel.MoveToField(tc,p,p,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2^3)
		Duel.MoveSequence(tc,6)
	elseif cardtype==Straight then
		for i=0,4 do
			local tc=mg:GetMinGroup(s.getpoint):GetFirst()
			Duel.MoveToField(tc,p,p,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2^i)
			mg:RemoveCard(tc)
		end
	elseif cardtype==Flight0 then
		local count=mg:GetCount()/3
		for i=1,count do
			local mg1=mg:GetMaxGroup(s.getpoint)
			local loc=i%2==1 and LOCATION_MZONE or LOCATION_SZONE
			if i<=2 then
				local tc=mg1:GetFirst()
				for j=1,3 do
					Duel.MoveToField(tc,p,p,loc,POS_FACEUP_ATTACK,false,2^j)
					tc=mg1:GetNext()
				end
			else
				local tc=mg1:GetFirst()
				for j=1,3 do
					Duel.MoveToField(tc,p,1-p,loc,POS_FACEUP_ATTACK,false,2^(4-j))
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_CONTROL)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e1:SetValue(1-p)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					tc:RegisterEffect(e1,true)
					tc=mg1:GetNext()
				end
			end
			mg=mg:Filter(aux.TRUE,mg1)
		end
		if count>=3 then
			Debug.Message("完成成就：卢食传说")
			Debug.Message("把牌出到对方场上")
		end
	elseif cardtype==Flight1 then
		local mgtable1={}
		local mgtable2={}
		local count=mg:GetCount()/4
		while #mgtable1<count do
			local mg1=mg:GetMaxGroup(s.getpoint)
			if mg1:GetCount()==3 then
				table.insert(mgtable1,mg1)
			elseif mg1:GetCount()==1 then
				table.insert(mgtable2,mg1)
			elseif mg1:GetCount()==2 then
				local rc=mg1:GetFirst()
				table.insert(mgtable2,Group.FromCards(rc))
				table.insert(mgtable2,mg1:Filter(aux.TRUE,rc))
			elseif mg1:GetCount()==4 then
				local rc=mg1:GetFirst()
				table.insert(mgtable2,Group.FromCards(rc))
				table.insert(mgtable1,mg1:Filter(aux.TRUE,rc))
			end
			mg=mg:Filter(aux.TRUE,mg1)
		end
		for tc in aux.Next(mg) do
			table.insert(mgtable2,Group.FromCards(tc))
		end
		for i=1,count do
			local loc=i%2==1 and LOCATION_MZONE or LOCATION_SZONE
			if i<=2 then
				local tc=mgtable1[i]:GetFirst()
				for j=0,2 do
					Duel.MoveToField(tc,p,p,loc,POS_FACEUP_ATTACK,false,2^j)
					tc=mgtable1[i]:GetNext()
				end
				local tc=mgtable2[i]:GetFirst()
				Duel.MoveToField(tc,p,p,loc,POS_FACEUP_ATTACK,false,2^3)
			else
				local tc=mgtable1[i]:GetFirst()
				for j=0,2 do
					Duel.MoveToField(tc,p,1-p,loc,POS_FACEUP_ATTACK,false,2^(4-j))
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_CONTROL)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e1:SetValue(1-p)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					tc:RegisterEffect(e1,true)
					tc=mgtable1[i]:GetNext()
				end
				local tc=mgtable2[i]:GetFirst()
				Duel.MoveToField(tc,p,1-p,loc,POS_FACEUP_ATTACK,false,2^1)
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_CONTROL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetValue(1-p)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				tc:RegisterEffect(e1,true)
			end	  
		end
		if count>=3 then
			Debug.Message("完成成就：卢食传说")
			Debug.Message("把牌出到对方场上")
		end
	elseif cardtype==Flight2 then
		local mgtable1={}
		local mgtable2={}
		local count=mg:GetCount()/5
		while #mgtable1<count do
			local mg1=mg:GetMaxGroup(s.getpoint)
			if mg1:GetCount()==3 then
				table.insert(mgtable1,mg1)
			elseif mg1:GetCount()==2 then
				table.insert(mgtable2,mg1)
			elseif mg1:GetCount()==4 then
				local rg=Group.FromCards(mg1:GetFirst(),mg1:GetNext())
				table.insert(mgtable2,rg)
				table.insert(mgtable2,mg1:Filter(aux.TRUE,rg))
			end
			mg=mg:Filter(aux.TRUE,mg1)
		end
		for i=1,count do
			local loc=i%2==1 and LOCATION_MZONE or LOCATION_SZONE
			if i<=2 then
				local tc=mgtable1[i]:GetFirst()
				for j=0,2 do
					Duel.MoveToField(tc,p,p,loc,POS_FACEUP_ATTACK,false,2^j)
					tc=mgtable1[i]:GetNext()
				end
				local tc=mgtable2[i]:GetFirst()
				for j=3,4 do
					Duel.MoveToField(tc,p,p,loc,POS_FACEUP_ATTACK,false,2^j)
					tc=mgtable2[i]:GetNext()
				end
			else
				local tc=mgtable1[i]:GetFirst()
				for j=0,2 do
					Duel.MoveToField(tc,p,1-p,loc,POS_FACEUP_ATTACK,false,2^(4-j))
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_CONTROL)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e1:SetValue(1-p)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					tc:RegisterEffect(e1,true)
					tc=mgtable1[i]:GetNext()
				end
				local tc=mgtable2[i]:GetFirst()
				for j=3,4 do
					Duel.MoveToField(tc,p,1-p,loc,POS_FACEUP_ATTACK,false,2^(4-j))
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_CONTROL)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e1:SetValue(1-p)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					tc:RegisterEffect(e1,true)
					tc=mgtable2[i]:GetNext()
				end		  
			end
		end
		if count>=3 then
			Debug.Message("完成成就：卢食传说")
			Debug.Message("把牌出到对方场上")
		end
	end
	if Duel.GetFieldGroupCount(p,LOCATION_HAND,0)==0 then Duel.Win(p,0xffff,Duel.CreateToken(p,id)) end
end
function s.sortop(e,tp)
	if e then tp=Duel.GetTurnPlayer() end
	local oc=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0):GetFirst()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local count=g:GetCount()
	--Duel.Overlay(oc,g)
	local cg=Group.CreateGroup()
	while g:GetCount()>0 do
		local mg=g:GetMinGroup(s.getpoint)
		while mg:GetCount()>0 do
			local mc=mg:GetMaxGroup(Card.GetCode):GetFirst()
			g:RemoveCard(mc)
			mg:RemoveCard(mc)
			cg:AddCard(mc)
			Duel.DisableShuffleCheck()
			Duel.SendtoDeck(mc,nil,0,REASON_RULE)
			Duel.AdjustAll()
		end
	end
	Duel.Draw(tp,count,REASON_RULE)
end
function s.fbomb(g)
	return g:GetClassCount(s.getpoint)==1 and g:GetCount()==4 or g:IsExists(s.pointsame,1,nil,16) and g:IsExists(s.pointsame,1,nil,17) and g:GetCount()==2
end
function s.fpairs(g,count)
	return g:GetClassCount(s.getpoint)==count
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	local cardtype,point,lastp=e:GetLabel()
	local p=Duel.GetTurnPlayer()
	local pid=(Duel.GetTurnCount()-1)%playercount+1
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	local upg=g:Filter(s.pointup,nil,point)
	if pid~=lastp then
		local ischainable=false
		local ischain=false
		local mg=Group.CreateGroup()
		if cardtype~=KingBomb and cardtype~=Bomb and g:CheckSubGroup(s.fbomb,2,4) and Duel.SelectYesNo(p,aux.Stringid(id,5)) then
			mg=g:SelectSubGroup(p,s.fbomb,true,4,4)
			if mg and mg:GetCount()==4 then
				cardtype=Bomb
				point=s.getpoint(mg:GetFirst())
				ischain=true
			else
				cardtype=KingBomb
				point=17
				ischain=true
			end
		end
		if cardtype==Single and upg:GetCount()>0 then
			ischainable=true
			mg=upg:SelectSubGroup(p,s.fpair,true,1,1)
			if mg and mg:GetCount()==1 then
				point=s.getpoint(mg:GetFirst())
				ischain=true
			end
		elseif cardtype==Pair and upg:CheckSubGroup(s.fpair,2,2) then
			ischainable=true
			mg=upg:SelectSubGroup(p,s.fpair,true,2,2)
			if mg and mg:GetCount()==2 then
				point=s.getpoint(mg:GetFirst())
				ischain=true
			end
		elseif cardtype==ThreeOfAKind and upg:CheckSubGroup(s.fpair,3,3) then
			ischainable=true
			mg=upg:SelectSubGroup(p,s.fpair,true,3,3)
			if mg and mg:GetCount()==3 then
				point=s.getpoint(mg:GetFirst())
				ischain=true
			end
		elseif cardtype==Bomb and upg:CheckSubGroup(s.fpair,4,4) then
			ischainable=true
			mg=upg:SelectSubGroup(p,s.fpair,true,4,4)
			if mg and mg:GetCount()==4 then
				point=s.getpoint(mg:GetFirst())
				ischain=true
			end
		elseif cardtype==ThreeWithOne and upg:CheckSubGroup(s.fpair1,3,3,g) then
			ischainable=true
			mg=upg:SelectSubGroup(p,s.fpair1,true,3,3,g)
			if mg and mg:GetCount()==3 then
				point=s.getpoint(mg:GetFirst())
				mg:Merge(g:Select(p,1,1,mg))  
				ischain=true
			end
		elseif cardtype==ThreeWithTwo and upg:CheckSubGroup(s.fpair2,3,3,g) then
			ischainable=true
			mg=upg:SelectSubGroup(p,s.fpair1,true,3,3,g)
			if mg and mg:GetCount()==3 then
				point=s.getpoint(mg:GetFirst())
				local mg2=g:Filter(aux.TRUE,mg):SelectSubGroup(p,s.fpair,true,2,2)
				mg:Merge(mg2)							
				ischain=true
			end
		elseif cardtype==Flight0 then
			local count=s.lastcard:GetCount()/3
			local gtable={}
			local codetable={}
			local abletable={}
			for i=1,14 do
				codetable[i]=false
			end
			local min
			local cg=upg:GetMaxGroup(s.getpoint)
			while upg:GetCount()>0 do
				if cg:GetCount()>=3 then
					local cpoint=cg:GetFirst():GetCode()%20
					if cpoint==1 then codetable[14]=true end
					codetable[cpoint]=true
					local bool=true
					for i=cpoint,cpoint+count-1 do
						if codetable[i]~=true then bool=false end
					end
					if bool then table.insert(abletable,i) end
				end
				upg=upg:Filter(aux.TRUE,cg)
			end
			if #abletable>0 then
				ischainable=true
				local sg=Group.CreateGroup()
				while sg:GetCount()<count*3 do
					local mg=upg:Filter(s.flightable,nil,abletable,count)
					local sc=mg:SelectUnselect(sg,p,true,true,0,1)
					if sc and not sg:IsContains(sc) then
						local cpoint=s.getpoint(sc)
						for i=13,1,-1 do
							if i>=cpoint then abletable[i]=false else break end
						end
						local tg=mg:Filter(s.pointsame,nil,cpoint)
						mg=mg:Filter(s.flightable,tg,abletable,count)
						if tg:GetCount()==4 then tg=tg:Select(p,3,3,nil) end
						sg:Merge(tg)
					else
						break
					end
				end
				if sg:GetCount()==s.lastcard:GetCount() then
					point=s.getpoint(mg:GetMinGroup():GetFirst())
					ischain=true
				end
			end
		elseif cardtype==Flight1 then
			local count=s.lastcard:GetCount()/4
			local gtable={}
			local codetable={}
			local abletable={}
			for i=1,14 do
				codetable[i]=false
			end
			local min
			local cg=upg:GetMaxGroup(s.getpoint)
			while upg:GetCount()>0 do
				if cg:GetCount()>=3 then
					local cpoint=cg:GetFirst():GetCode()%20
					if cpoint==1 then codetable[14]=true end
					codetable[cpoint]=true
					local bool=true					
					for i=cpoint,cpoint+count-1 do
						eg:Merge()
						if codetable[i]~=true then bool=false end
					end
					local eg=Group.__add(g:Filter(s.pointup,nil,cpoint+count-1),g:Filter(s.pointdown,nil,cpoint))
					if bool and eg:GetCount()>=count then table.insert(abletable,i) end
				end
				upg=upg:Filter(aux.TRUE,cg)
			end
			if #abletable>0 then
				ischainable=true
				local sg=Group.CreateGroup()
				while sg:GetCount()<count*3 do
					local mg=upg:Filter(s.flightable,nil,abletable,count)
					local sc=mg:SelectUnselect(sg,p,true,true,0,1)
					if sc and not sg:IsContains(sc) then
						local cpoint=s.getpoint(sc)
						for i=13,1,-1 do
							if i>=cpoint then abletable[i]=false else break end
						end
						local tg=mg:Filter(s.pointsame,nil,cpoint)
						mg=mg:Filter(s.flightable,tg,abletable,count)
						if tg:GetCount()==4 then tg=tg:Select(p,3,3,nil) end
						sg:Merge(tg)
					else
						break
					end
				end
				local cp=s.getpoint(mg:GetMinGroup():GetFirst())
				sg:Merge(g:Select(p,count,count,sg)) 
				if sg:GetCount()==s.lastcard:GetCount() then
					point=cp
					ischain=true
				end
			end
		elseif cardtype==Flight2 then
			local count=s.lastcard:GetCount()/4
			local gtable={}
			local codetable={}
			local abletable={}
			for i=1,14 do
				codetable[i]=false
			end
			local min
			local cg=upg:GetMaxGroup(s.getpoint)
			while upg:GetCount()>0 do
				if cg:GetCount()>=3 then
					local cpoint=cg:GetFirst():GetCode()%20
					if cpoint==1 then codetable[14]=true end
					codetable[cpoint]=true
					local bool=true					
					for i=cpoint,cpoint+count-1 do
						eg:Merge()
						if codetable[i]~=true then bool=false end
					end
					local eg=Group.__add(g:Filter(s.pointup,nil,cpoint+count-1),g:Filter(s.pointdown,nil,cpoint))
					if bool and eg:CheckSubGroup(s.fpairs,2*count,2*count,count) then
						table.insert(abletable,i)
					end
				end
				upg=upg:Filter(aux.TRUE,cg)
			end
			if #abletable>0 then
				ischainable=true
				local sg=Group.CreateGroup()
				while sg:GetCount()<count*3 do
					local mg=upg:Filter(s.flightable,nil,abletable,count)
					local sc=mg:SelectUnselect(sg,p,true,true,0,1)
					if sc and not sg:IsContains(sc) then
						local cpoint=s.getpoint(sc)
						for i=13,1,-1 do
							if i>=cpoint then abletable[i]=false else break end
						end
						local tg=mg:Filter(s.pointsame,nil,cpoint)
						mg=mg:Filter(s.flightable,tg,abletable,count)
						if tg:GetCount()==4 then tg=tg:Select(p,3,3,nil) end
						sg:Merge(tg)
					else
						break
					end
				end
				local cp=s.getpoint(mg:GetMinGroup():GetFirst())
				local eg=g:Filter(aux.TRUE,sg)
				sg:Merge(eg:SelectSubGroup(p,s.fpairs,true,2*count,2*count,count)) 
				if sg:GetCount()==s.lastcard:GetCount() then
					point=cp
					ischain=true
				end
			end
		elseif cardtype==Straight then  
			local cardtable=s.checkStraight2(point,upg)
			if #cardtable>0 then
				ischainable=true
				local cg=Group.CreateGroup()
				for i,v in ipairs(cardtable) do
					cg:Merge(upg:Filter(s.straightfilter,nil,v.min,v.max,0)) 
				end
				while mg:GetCount()<5 do
					local sc=cg:SelectUnselect(mg,p,true,true,0,1)
					if sc and not cg:IsContains(sc) then
						for i,v in ipairs(cardtable) do
							if sc:GetCode()%20>=v.min and sc:GetCode()%20<=v.max then
								cg=cg:Filter(s.straightfilter,nil,v.min,v.max,sc:GetCode()%20)
								break
							end
						end
						mg:AddCard(sc)
					else
						break
					end
				end
				if mg:GetCount()==5 then
					point=s.getpoint(mg:GetMinGroup():GetFirst())
					ischain=true
				end
			end
		end
		if ischain then
			s.movecard(cardtype,mg)
			lastp=pid
		else
			if not ischainable then
				Duel.SelectYesNo(p,aux.Stringid(id,1))
			end
			local pid=(Duel.GetTurnCount()-1)%playercount+1
			local identity=pid==landlord and "地主" or "农民"
			if s.IsHuman[pid]==true or playercount==2 then Debug.Message(pid.."号位玩家("..identity..")：不要！") end
		end
		local p=Duel.GetTurnPlayer()
		s.skip()
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PREDRAW)
		ge0:SetLabel(cardtype,point,lastp)
		ge0:SetOperation(s.chainop)
		Duel.RegisterEffect(ge0,0)
	else
		local pid=(Duel.GetTurnCount()-1)%playercount+1
		local identity=pid==landlord and "地主" or "农民"
		Debug.Message(pid.."号位玩家("..identity..")的回合")
		local g=Duel.GetFieldGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_RULE) end
	end
	e:Reset()
end