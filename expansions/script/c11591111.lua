--春秋蝉
local s,id,o=GetID()
function s.initial_effect(c)
	s.savedata={{},{}}
	--save
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(s.save)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--load
	if not s.globle_check then
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge0:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
		ge0:SetTargetRange(1,0)
		ge0:SetCondition(s.wd)
		ge0:SetValue(1)
		Duel.RegisterEffect(ge0,0)
		Duel.RegisterEffect(ge0,1)

		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(s.IsLpZone)
		ge1:SetOperation(s.LpZoneop)
		Duel.RegisterEffect(ge1,0)

		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PREDRAW)
		ge2:SetCountLimit(1)
		ge2:SetOperation(s.drop)
		Duel.RegisterEffect(ge2,0)

		s.Win=Duel.Win
		function Duel.Win(p,r)
			if #s.savedata[2-p]>0 and Duel.TossCoin(p,1)==1 then
				s.loaddata(1-p)
			else
				s.Win(p,r)
			end
		end
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
local A=1103515245
local B=12345
local M=32767
function s.roll(min,max)
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
function s.loaddata(tp)
	Duel.Hint(HINT_CARD,0,id)
	if #s.savedata[tp+1]==0 then return end
	local ram=s.roll(1,#s.savedata[tp+1])
	s.loadcard(s.savedata[tp+1][ram])
end
function get_save_location(c)
	if c:IsLocation(LOCATION_PZONE) then return LOCATION_PZONE
	else return c:GetLocation() end
end
function get_save_sequence(c)
	if c:IsOnField() then return c:GetSequence()
	else return 0 end
end
function s.save(e,tp)
	data={
		lp={Duel.GetLP(0),Duel.GetLP(1)},
		turn=Duel.GetTurnCount(),
		cards={{},{}},  
	}
	for p=0,1 do
		local sg=Duel.GetMatchingGroup(nil,p,0xfe,0,nil)		
		local cid=0
		for tc in aux.Next(sg) do
			cid=cid+1
			local cdata={
				id=cid,
				card=tc,
				location=get_save_location(tc),
				sequence=get_save_sequence(tc),
				position=tc:GetPosition(),
				overlay_cards={},
				counter={}
			}
			if tc:GetCounter(0)>0 then
				for counter=1,65535 do
					local ct=tc:GetCounter(counter)
					if ct>0 then
						table.insert(cdata.counter,{
							type=counter,
							count=ct
						})
					end
				end
			end
			local og=tc:GetOverlayGroup()
			for oc in aux.Next(og) do
				cid=cid+1
				table.insert(cdata.overlay_cards, {
					id=cid,
					card=oc,
					summon_type=oc:GetSummonType(),
					summon_location=oc:GetSummonLocation(),
				})
			end
			table.insert(data.cards[p+1],cdata)
		end
	end
	table.insert(s.savedata[tp+1],data)
end
function s.wd(e,tp)
	return Duel.GetFlagEffect(tp,id)==0
end
function s.IsLpZone(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(0)<=0 or Duel.GetLP(1)<=0
end
function s.LpZoneop()
		local roll=s.roll(1,9)
	for p=0,1 do
		if Duel.GetLP(p)<=0 and Duel.GetFlagEffect(p,id)==0 and #s.savedata[p+1]>0 and Duel.TossCoin(p,1)==1 then

		if not Duel.GetFlagEffect(tp,22349371) or Duel.GetFlagEffect(tp,22349371)<1 then
		if roll==1 then  Debug.Message("很简单，我成尊不就是了。")
		elseif roll==2 then Debug.Message("早岁已知世事艰，仍许飞鸿荡云间。")
		elseif roll==3 then Debug.Message("一路寒风身如絮，命海沉浮客独行。")
		elseif roll==4 then Debug.Message("千磨万击心铸铁，殚精竭虑铸一剑。")
		elseif roll==5 then Debug.Message("今朝剑指叠云处，炼蛊炼人还炼天！")
		elseif roll==6 then Debug.Message("落魄谷中寒风吹，春秋蝉鸣少年归。")
		elseif roll==7 then Debug.Message("荡魂山处石人泪，定仙游走魔向北。")
		elseif roll==8 then Debug.Message("逆流河上万仙退，爱情不敌坚持泪。")
		elseif roll==9 then Debug.Message("宿命天成命中败。仙尊悔而我不悔。") end
		Duel.RegisterFlagEffect(tp,22349371,RESET_CHAIN,0,1,1) end

			s.loaddata(p)
		else

		if not Duel.GetFlagEffect(tp,22348371) or Duel.GetFlagEffect(tp,22348371)<1 then
		if roll==1 then  Debug.Message("不过是些许风霜罢了。")
		elseif roll==2 then Debug.Message("当真是，朝如青丝暮成雪，是非成败转头空。")
		elseif roll==3 then Debug.Message("这世间真是英杰无数，天下英雄如过江之鲫。")
		elseif roll==4 then Debug.Message("因为困难多壮志，不教红尘惑坚心。")
		elseif roll==5 then Debug.Message("今身暂且栖草头，它日狂歌踏山河！")
		elseif roll==6 then Debug.Message("岂不是天无绝人之路？只要我想走，路就在脚下！")
		elseif roll==7 then Debug.Message("阳莽憾陨谁无败？卷土重来再称王。")
		elseif roll==8 then Debug.Message("今日暂且展翼去，明朝登仙笞凤凰")
		elseif roll==9 then Debug.Message("我已走在路上,纵死不悔。") end
		Duel.RegisterFlagEffect(tp,22348371,RESET_CHAIN,0,1,1) end

			Duel.RegisterFlagEffect(p,id,0,0,1)
		end
	end
end
function s.drop()
	local p=Duel.GetTurnPlayer()
	if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)==0 and Duel.GetDrawCount(p)>0 
	and #s.savedata[p+1]>0 and Duel.TossCoin(p,1)==1 then
		s.loaddata(p)
	end
end 
function s.loadcard(data)
	local cg=Duel.GetFieldGroup(0,0xff,0xff)
	for tc in aux.Next(cg) do
		local og=tc:GetOverlayGroup()
		if #og>0 then Duel.SendtoDeck(og,nil,SEQ_DECKSHUFFLE,REASON_RULE) end
	end
	local g=Duel.GetFieldGroup(0,0xfe,0xfe)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	for p=0,1 do
		Duel.SetLP(p,data.lp[p+1])
		for i,cdata in ipairs(data.cards[p+1]) do
			local tc=cdata.card
			if tc then
				if cdata.location==LOCATION_HAND then
					Duel.SendtoHand(tc,p,REASON_RULE)
				elseif cdata.location==LOCATION_GRAVE then
					Duel.SendtoGrave(tc,REASON_RULE)
				elseif cdata.location==LOCATION_REMOVED then
					Duel.Remove(tc,cdata.position,REASON_RULE)
				elseif cdata.location==LOCATION_EXTRA then
					if tc:IsLocation(LOCATION_DECK) then Duel.SendtoExtraP(tc,p,REASON_RULE) end
				elseif cdata.location&LOCATION_ONFIELD>0 then
					if cdata.sequence>=5 then Duel.SendtoExtraP(tc,p,REASON_RULE) end
					if not Duel.MoveToField(tc,p,p,cdata.location,cdata.position,true,2^cdata.sequence) then Duel.SendtoGrave(tc,REASON_RULE) end
					for _,counter in ipairs(cdata.counter) do
						tc:AddCounter(counter.type,counter.count)
					end
					for _,ocards in ipairs(cdata.overlay_cards) do
						Duel.Overlay(tc,ocards.card)
					end
				end
			end
		end
	end
end