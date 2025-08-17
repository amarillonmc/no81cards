--随兴
local cm,m=GetID()
function cm.initial_effect(c)
	--random
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.sccost)
	e1:SetOperation(cm.scop)
	c:RegisterEffect(e1)
	if not GO_RANDOM then
		GO_RANDOM=true
		cm[0]=0
		cm[1]=0
		cm.blacklist={}
		local _SelectMatchingCard=Duel.SelectMatchingCard
		local _SelectReleaseGroup=Duel.SelectReleaseGroup
		local _SelectReleaseGroupEx=Duel.SelectReleaseGroupEx
		local _SelectTarget=Duel.SelectTarget
		local _SelectTribute=Duel.SelectTribute
		local _DiscardHand=Duel.DiscardHand
		local _DRemoveOverlayCard=Duel.RemoveOverlayCard
		local _CRemoveOverlayCard=Card.RemoveOverlayCard
		local _FilterSelect=Group.FilterSelect
		local _Select=Group.Select
		pnfl_CancelableSelect=Group.CancelableSelect
		local _CancelableSelect=Group.CancelableSelect
		local _SelectUnselect=Group.SelectUnselect
		local function Local_RandomSelect(g,tp,ct)
			local cg=g:Clone()
			local sg=Group.CreateGroup()
			if aux.GetValueType(g)~="Group" or #g<=0 then return sg end
			if ct>#g then ct=#g end
			if not cm.r then
				cm.r=Duel.GetFieldGroup(0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_EXTRA):GetSum(Card.GetCode)
			end
			while #sg<ct do
				local id=cm.roll(0,#cg)
				local tc=cg:GetFirst()
				if id>1 then
					for i=1,id-1,1 do tc=cg:GetNext() end
				end
				sg:AddCard(tc)
				cg:RemoveCard(tc)
			end
			return sg
		end
		function Duel.SelectMatchingCard(sp,f,p,s,o,min,max,nc,...)
			if Duel.GetFlagEffect(0,m)>0 and min==1 and max==1 then
				local g=Duel.GetMatchingGroup(f,p,s,o,nc,...)
				return g:Select(sp,min,max,nc)
			else
				return _SelectMatchingCard(sp,f,p,s,o,min,max,nc,...)
			end
		end
		function Duel.SelectReleaseGroup(sp,f,min,max,nc,...)
			if Duel.GetFlagEffect(0,m)>0 and min==1 and max==1 then
				local g=cm.filter(Duel.GetReleaseGroup(sp,false),f,nil,...)
				return g:Select(sp,min,max,nc)
			else
				return _SelectReleaseGroup(sp,f,min,max,nc,...)
			end
		end
		function Duel.SelectReleaseGroupEx(sp,f,min,max,r,bool,nc,...)
			if Duel.GetFlagEffect(0,m)>0 and min==1 and max==1 then
				local g=cm.filter(Duel.GetReleaseGroup(sp,true),f,nil,...)
				return g:Select(sp,min,max,nc)
			else
				return _SelectReleaseGroupEx(sp,f,min,max,r,bool,nc,...)
			end
		end
		function Duel.SelectTarget(sp,f,p,s,o,min,max,nc,...)
			if Duel.GetFlagEffect(0,m)>0 and min==1 and max==1 then
				local e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
				local tgf=function(c,...) return (not f or f(c,...)) and c:IsCanBeEffectTarget(e) end
				local g=Duel.GetMatchingGroup(tgf,p,s,o,nc,...)
				local tg=g:Select(sp,min,max,nc)
				Duel.SetTargetCard(tg)
				return tg
			else
				return _SelectTarget(sp,f,p,s,o,min,max,nc,...)
			end
		end
		function Duel.SelectTribute(sp,ac,min,max,mg,top)
			if Duel.GetFlagEffect(0,m)>0 and min==1 and max==1 then
				local f=function(c) return Duel.GetMZoneCount(top,c,sp)>0 end
				local f2=function(c,ac) return Duel.GetMZoneCount(top,c,sp)>0 and (Duel.GetTributeGroup(ac):IsContains(c) or not c:IsOnField()) end
				local g=Duel.GetTributeGroup(ac):Filter(f,nil)
				if mg then g=mg:Filter(f2,nil,ac) end
				return g:Select(sp,min,max,nil)
			else
				return _SelectTribute(sp,ac,min,max,mg,top)
			end
		end
		function Duel.DiscardHand(sp,f,min,max,r,nc,...)
			if Duel.GetFlagEffect(0,m)>0 and min==1 and max==1 then
				local dg=cm.filter(Duel.GetFieldGroup(sp,LOCATION_HAND,0),f,nc,...)
				dg=dg:Select(sp,min,max,nc)
				return Duel.SendtoGrave(dg,r)
			else
				return _DiscardHand(sp,f,min,max,r,nc,...)
			end
		end
		function Duel.RemoveOverlayCard(sp,s,o,min,max,r)
			if Duel.GetFlagEffect(0,m)>0 and min==1 and max==1 then
				local og=Duel.GetOverlayGroup(sp,s,o)
				Duel.Hint(HINT_CARD,0,m)
				cm[sp]=cm[sp]+1
				og=Local_RandomSelect(og,sp,1)
				local e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
				local dc=og:GetFirst()
				local c=nil
				if dc then c=dc:GetOverlayTarget() end
				local ct=Duel.SendtoGrave(og,r)
				if c and e then Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0) end
				return ct
			else
				return _DRemoveOverlayCard(sp,s,o,min,max,r)
			end
		end
		function Card.RemoveOverlayCard(oc,sp,min,max,r)
			if Duel.GetFlagEffect(0,m)>0 and min==1 and max==1 then
				local og=oc:GetOverlayGroup()
				Duel.Hint(HINT_CARD,0,m)
				cm[sp]=cm[sp]+1
				og=Local_RandomSelect(og,sp,1)
				local e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
				local ct=Duel.SendtoGrave(og,r)
				if ct>0 and e then Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0) end
				return ct
			else
				return _CRemoveOverlayCard(oc,sp,min,max,r)
			end
		end
		function Group.FilterSelect(g,sp,f,min,max,nc,...)
			if Duel.GetFlagEffect(0,m)>0 and min==1 and max==1 then
				local fg=cm.filter(g,f,nc,...)
				return fg:Select(sp,min,max,nc)
			else
				return _FilterSelect(g,sp,f,min,max,nc,...)
			end
		end
		function Group.Select(g,sp,min,max,nc)
			if Duel.GetFlagEffect(0,m)>0 and min==1 and max==1 then
				local ng=g:Clone()
				if aux.GetValueType(nc)=="Card" then ng:RemoveCard(nc) end
				if aux.GetValueType(nc)=="Group" then ng:Sub(nc) end
				Duel.Hint(HINT_CARD,0,m)
				--local ct=Duel.GetFlagEffectLabel(sp,m)
				--Duel.SetFlagEffectLabel(sp,m,ct+1)
				cm[sp]=cm[sp]+1
				local tg=ng:RandomSelect(sp,1)
				if tg:GetFirst() and tg:GetFirst():IsLocation(LOCATION_DECK+LOCATION_EXTRA) then Duel.ConfirmCards(sp,tg) end
				return tg
			elseif Duel.GetFlagEffect(0,m)>0 and min<=0 and max==1 then
				local ng=g:Clone()
				if aux.GetValueType(nc)=="Card" then ng:RemoveCard(nc) end
				if aux.GetValueType(nc)=="Group" then ng:Sub(nc) end	
				if not Duel.SelectYesNo(sp,aux.Stringid(m,2)) then return Group.CreateGroup() end
				Duel.Hint(HINT_CARD,0,m)
				--local ct=Duel.GetFlagEffectLabel(sp,m)
				--Duel.SetFlagEffectLabel(sp,m,ct+1)
				cm[sp]=cm[sp]+1
				local tg=ng:RandomSelect(sp,1)
				if tg:GetFirst() and tg:GetFirst():IsLocation(LOCATION_DECK+LOCATION_EXTRA) then Duel.ConfirmCards(sp,tg) end
				return tg
			else
				return _Select(g,sp,min,max,nc)
			end
		end
		function Group.CancelableSelect(g,sp,min,max,nc)
			if Duel.DisableActionCheck then Duel.DisableActionCheck(true) end
			if Duel.GetFlagEffect(0,m)>0 and min<=1 and max==1 then
				local ng=g:Clone()
				if aux.GetValueType(nc)=="Card" then ng:RemoveCard(nc) end
				if aux.GetValueType(nc)=="Group" then ng:Sub(nc) end	
				if not Duel.SelectYesNo(sp,aux.Stringid(m,2)) then return nil end
				Duel.Hint(HINT_CARD,0,m)
				--local ct=Duel.GetFlagEffectLabel(sp,m)
				--Duel.SetFlagEffectLabel(sp,m,ct+1)
				cm[sp]=cm[sp]+1
				local tg=ng:RandomSelect(sp,1)
				if tg:GetFirst() and tg:GetFirst():IsLocation(LOCATION_DECK+LOCATION_EXTRA) then Duel.ConfirmCards(sp,tg) end
				if Duel.DisableActionCheck then Duel.DisableActionCheck(false) end
				return tg
			else
				if Duel.DisableActionCheck then Duel.DisableActionCheck(false) end
				return _CancelableSelect(g,sp,min,max,nc)
			end
		end
		function Group.SelectUnselect(cg,sg,sp,finish,cancel,...)
			if Duel.GetFlagEffect(0,m)>0 then return _SelectUnselect(cg,sg,sp,finish,false,...) end
			return _SelectUnselect(cg,sg,sp,finish,cancel,...)
		end
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function cm.filter(g,f,nc,...)
	if aux.GetValueType(f)=="function" then return g:Filter(f,nc,...) end
	local ng=g:Clone()
	if aux.GetValueType(nc)=="Card" then ng:RemoveCard(nc) end
	if aux.GetValueType(nc)=="Group" then ng:Sub(nc) end
	return ng
end
function cm.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,m)==0 then
		Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,2)
		Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,2)
	end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetCountLimit(1)
	e0:SetReset(RESET_PHASE+PHASE_END,2)
	e0:SetOperation(cm.spop)
	Duel.RegisterEffect(e0,tp)
end
local A=1103515245
local B=12345
local M=32767 --1073741824
function cm.roll(min,max)
	min=tonumber(min)
	max=tonumber(max)
	cm.r=((cm.r*A+B)%M)/M
	if min~=nil then
		if max==nil then
			return math.floor(cm.r*min)+1
		else
			max=max-min+1
			return math.floor(cm.r*max)+min
		end
	end
	return cm.r
end
--if Duel.GetRandomNumber then cm.roll=Duel.GetRandomNumber end
function cm.list(code)
	for _,codes in pairs(cm.blacklist) do
		if codes==code then return true end
	end
	return false
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=cm[tp]--Duel.GetFlagEffectLabel(tp,m)
	local ct2=cm[1-tp]--Duel.GetFlagEffectLabel(1-tp,m)
	--Duel.SetFlagEffectLabel(tp,m,0)
	--Duel.SetFlagEffectLabel(1-tp,m,0)
	if not ct1 or not ct2 or (ct1==0 and ct2==0) then return end
	if not cm.r then
		--[[local result=0
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
		cm.r=result&0xffffffff--]]
		cm.r=Duel.GetFieldGroup(0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_EXTRA):GetSum(Card.GetCode)
	end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local ng1=Group.CreateGroup()
	local ng2=Group.CreateGroup()
	local ac=nil
	local _TGetID=GetID
	if ct1>0 then
		ct1=math.min(ct1,85)
		local tab1={}
		for i=1,ct1 do
			while not ac do
				local int=cm.roll(1,132000016)
				--continuously updated
				if int>132000000 and int<132000014 then int=int+739100000 end
				if int==132000014 then int=460524290 end
				if int==132000015 then int=978210027 end
				if int==132000016 then int=250000000 end
				if KOISHI_CHECK then
					local cc,ca,ctype=Duel.ReadCard(int,CARDDATA_CODE,CARDDATA_ALIAS,CARDDATA_TYPE)
					if cc then
						local dif=cc-ca
						local real=0
						if dif>-10 and dif<10 then
							real=ca
						else
							real=cc
						end
						if ctype&TYPE_TOKEN==0 and not cm.list(real) then
							ac=real
						end
					end
				else
					if not _G["c"..int] then
						_G["c"..int]={}
						_G["c"..int].__index=_G["c"..int]
					end
					GetID=function()
						return _G["c"..int],int,int<100000000 and 1 or 100
					end
					if pcall(function() Duel.LoadScript("c"..int..".lua") end) then
						_G["c"..int]=nil
						local bool,token=pcall(Duel.CreateToken,tp,int)
						if bool and not token:IsType(TYPE_TOKEN) then
							ac=token:GetCode()
						end
					end
				end
			end
			table.insert(tab1,ac)
			table.insert(cm.blacklist,ac)
			ac=nil
		end
		for i=1,ct1 do
			Duel.Hint(HINT_CARD,0,tab1[i])
			g1:AddCard(Duel.CreateToken(tp,tab1[i]))
		end
		if #g1>0 then
			--if KOISHI_CHECK then Duel.ConfirmCards(tp,g1) end
			local codes={}
			for tc in aux.Next(g1) do
				local code=tc:GetCode()
				table.insert(codes,code)
			end
			table.sort(codes)
			if aux.GetValueType(codes[1])=="number" then
				local afilter={codes[1],OPCODE_ISCODE}
				if #codes>1 then
					for i=2,#codes do
						table.insert(afilter,codes[i])
						table.insert(afilter,OPCODE_ISCODE)
						table.insert(afilter,OPCODE_OR)
					end
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
				local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
				--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				--local sg=g1:SelectSubGroup(tp,aux.TRUE,false,1,1)
				ng1=g1:Filter(Card.IsCode,nil,ac)
				g1:Sub(ng1)
				Duel.SendtoHand(ng1,tp,REASON_EFFECT)
				Duel.SendtoDeck(g1,tp,2,REASON_EFFECT)
			end
		end
	end
	if ct2>0 then
		ct2=math.min(ct2,85)
		local tab2={}
		for i=1,ct2 do
			while not ac do
				local int=cm.roll(1,132000016)
				--continuously updated
				if int>132000000 and int<132000014 then int=int+739100000 end
				if int==132000014 then int=460524290 end
				if int==132000015 then int=978210027 end
				if int==132000016 then int=250000000 end
				if KOISHI_CHECK then
					local cc,ca,ctype=Duel.ReadCard(int,CARDDATA_CODE,CARDDATA_ALIAS,CARDDATA_TYPE)
					if cc then
						local dif=cc-ca
						local real=0
						if dif>-10 and dif<10 then
							real=ca
						else
							real=cc
						end
						if ctype&TYPE_TOKEN==0 and not cm.list(real) then
							ac=real
						end
					end
				else
					if not _G["c"..int] then
						_G["c"..int]={}
						_G["c"..int].__index=_G["c"..int]
					end
					GetID=function()
						return _G["c"..int],int,int<100000000 and 1 or 100
					end
					if pcall(function() Duel.LoadScript("c"..int..".lua") end) then
						_G["c"..int]=nil
						local bool,token=pcall(Duel.CreateToken,1-tp,int)
						if bool and not token:IsType(TYPE_TOKEN) then
							ac=token:GetCode()
						end
					end
				end
			end
			table.insert(tab2,ac)
			table.insert(cm.blacklist,ac)
			ac=nil
		end
		for i=1,ct2 do
			Duel.Hint(HINT_CARD,0,tab2[i])
			g2:AddCard(Duel.CreateToken(1-tp,tab2[i]))
		end
		if #g2>0 then
			--if KOISHI_CHECK then Duel.ConfirmCards(1-tp,g2) end
			local codes={}
			for tc in aux.Next(g2) do
				local code=tc:GetCode()
				table.insert(codes,code)
			end
			table.sort(codes)
			if aux.GetValueType(codes[1])=="number" then
				local afilter={codes[1],OPCODE_ISCODE}
				if #codes>1 then
					for i=2,#codes do
						table.insert(afilter,codes[i])
						table.insert(afilter,OPCODE_ISCODE)
						table.insert(afilter,OPCODE_OR)
					end
				end
				local ac=afilter[1]
				if cm[3-tp] or not Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
					cm[3-tp]=true
					Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CODE)
					ac=Duel.AnnounceCard(1-tp,table.unpack(afilter))
				end
				--Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
				--local sg=g2:SelectSubGroup(1-tp,aux.TRUE,false,1,1)
				ng2=g2:Filter(Card.IsCode,nil,ac)
				g2:Sub(ng2)
				Duel.SendtoHand(ng2,1-tp,REASON_EFFECT)
				Duel.SendtoDeck(g2,1-tp,2,REASON_EFFECT)
			end
		end
	end
	GetID=_TGetID
	g1=g1:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	g2=g2:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	ng1=ng1:Filter(Card.IsLocation,nil,LOCATION_HAND)
	ng2=ng2:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #g1>0 then Duel.ConfirmCards(1-tp,g1) end
	if #g2>0 then Duel.ConfirmCards(tp,g2) end
	if #ng1>0 then Duel.ConfirmCards(1-tp,ng1) end
	if #ng2>0 then Duel.ConfirmCards(tp,ng2) end
end