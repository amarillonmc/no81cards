--无序
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--aux.AddFusionProcFunRep(c,s.ffilter,6,false)
	--material limit
	--local e0=Effect.CreateEffect(c)
	--e0:SetType(EFFECT_TYPE_SINGLE)
	--e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e0:SetCode(EFFECT_MATERIAL_LIMIT)
	--e0:SetValue(s.matlimit)
	--c:RegisterEffect(e0)
	--spsummon condition
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCode(EFFECT_SPSUMMON_CONDITION)
	e01:SetValue(aux.fuslimit)
	c:RegisterEffect(e01)
	--tribute check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.valcheck)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot target
	local e31=e2:Clone()
	e31:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e31)
	--indes
	local e32=e2:Clone()
	e32:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e32)
	--change effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(id)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	c:RegisterEffect(e4)
	--change lv
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(s.lvop)
	c:RegisterEffect(e5)
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e6:SetValue(LOCATION_DECK)
	c:RegisterEffect(e6)
	--change target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.atkcon)
	e7:SetOperation(s.atkop)
	c:RegisterEffect(e7)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:SetRange(LOCATION_EXTRA)
		ge1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
		ge1:SetOperation(s.fuop)
		Duel.RegisterEffect(ge1,0)
		
		s[0]=0
		s[1]=0
		local _SelectMatchingCard=Duel.SelectMatchingCard
		local _SelectReleaseGroup=Duel.SelectReleaseGroup
		local _SelectReleaseGroupEx=Duel.SelectReleaseGroupEx
		local _SelectSubGroup=Group.SelectSubGroup
		local _SelectTarget=Duel.SelectTarget
		local _SelectTribute=Duel.SelectTribute
		local _SelectUnselect=Group.SelectUnselect
		local _DiscardHand=Duel.DiscardHand
		local _DRemoveOverlayCard=Duel.RemoveOverlayCard
		local _CRemoveOverlayCard=Card.RemoveOverlayCard
		local _FilterSelect=Group.FilterSelect
		local _Select=Group.Select
		
		function Duel.SelectMatchingCard(sp,f,p,s,o,min,max,nc,...)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local g=Duel.GetMatchingGroup(f,p,s,o,nc,...)
				return g:Select(sp,min,max,nc)
			else
				return _SelectMatchingCard(sp,f,p,s,o,min,max,nc,...)
			end
		end
		function Duel.SelectReleaseGroup(sp,f,min,max,nc,...)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local g=s.filter(Duel.GetReleaseGroup(sp),f,nil,...)
				return g:Select(sp,min,max,nc)
			else
				return _SelectReleaseGroup(sp,f,min,max,nc,...)
			end
		end
		function Duel.SelectReleaseGroupEx(sp,f,min,max,nc,...)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local g=s.filter(Duel.GetReleaseGroup(sp,true),f,nil,...)
				return g:Select(sp,min,max,nc)
			else
				return _SelectReleaseGroupEx(sp,f,min,max,nc,...)
			end
		end
		
		function Group.SelectSubGroup(g,tp,f,cancelable,min,max,...)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				return g:Select(tp,min,max,nil)
			else
				return _SelectSubGroup(g,tp,f,cancelable,min,max,...) 
			end
		end
		function Duel.SelectTarget(sp,f,p,s,o,min,max,nc,...)
			if Duel.IsPlayerAffectedByEffect(0,id) then
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
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local f=function(c) return Duel.GetMZoneCount(top,c,sp)>0 end
				local f2=function(c,ac) return Duel.GetMZoneCount(top,c,sp)>0 and (Duel.GetTributeGroup(ac):IsContains(c) or not c:IsOnField()) end
				local g=Duel.GetTributeGroup(ac):Filter(f,nil)
				if mg then g=mg:Filter(f2,nil,ac) end
				return g:Select(sp,min,max,nil)
			else
				return _SelectTribute(sp,ac,min,max,mg,top)
			end
		end
		function Group.SelectUnselect(cg,sg,tp,finish,cancel,min,max)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				if finish then return end
				if not cg or cg:GetCount()<=0 then return end   
				local tc=cg:RandomSelect(tp,1)
				return tc
			else
				return _SelectUnselect(cg,sg,tp,finish,cancel,min,max)
			end
		end
		function Duel.DiscardHand(sp,f,min,max,r,nc,...)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local dg=s.filter(Duel.GetFieldGroup(sp,LOCATION_HAND,0),f,nc,...)
				dg=dg:Select(sp,min,max,nc)
				return Duel.SendtoGrave(dg,r)
			else
				return _DiscardHand(sp,f,min,max,r,nc,...)
			end
		end
		function Duel.RemoveOverlayCard(sp,s,o,min,max,r)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local og=Duel.GetOverlayGroup(sp,s,o)
				og=og:Select(sp,min,max,nil)
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
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local og=oc:GetOverlayGroup()
				og=og:Select(sp,min,max,nil)
				local e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
				local ct=Duel.SendtoGrave(og,r)
				if ct>0 and e then Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0) end
				return ct
			else
				return _CRemoveOverlayCard(oc,sp,min,max,r)
			end
		end
		function Group.FilterSelect(g,sp,f,min,max,nc,...)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local fg=s.filter(g,f,nc,...)
				return fg:Select(sp,min,max,nc)
			else
				return _FilterSelect(g,sp,f,min,max,nc,...)
			end
		end
		function Group.Select(g,sp,min,max,nc)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local ng=g:Clone()
				if aux.GetValueType(nc)=="Card" then ng:RemoveCard(nc) end
				if aux.GetValueType(nc)=="Group" then ng:Sub(nc) end
				Duel.Hint(HINT_CARD,0,id)
				--local ct=Duel.GetFlagEffectLabel(sp,m)
				--Duel.SetFlagEffectLabel(sp,m,ct+1)
				s[sp]=s[sp]+1
				return ng:RandomSelect(sp,s.roll(min,max))
			else
				return _Select(g,sp,min,max,nc)
			end
		end

		local _SpecialSummonStep=Duel.SpecialSummonStep
		local _SpecialSummon=Duel.SpecialSummon
		local _Summon=Duel.Summon
		local _MSet=Duel.MSet
		local _SelectDisableField=Duel.SelectDisableField
		local _SelectField=Duel.SelectField
		function Duel.SpecialSummonStep(c,sumt,sump,tp,noc,nol,pos,zone)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local zonet={0x01,0x02,0x04,0x08,0x10,0x20,0x40}
				if not c:IsLocation(LOCATION_EXTRA) then zonet={0x01,0x02,0x04,0x08,0x10} end
				local zoneToRemove = {}
				if zone==nil then 
					zone=0x7f
				end
				for i,v in pairs(zonet) do
					if not Duel.CheckLocation(tp,LOCATION_MZONE,math.log(v,2)) or v|zone ==0 then
						table.insert(zoneToRemove,i)
					end
				end
				for i = #zoneToRemove,1,-1 do
					table.remove(zonet,zoneToRemove[i])
				end
				zone=zonet[s.roll(1,#zonet)]
				Duel.Hint(HINT_ZONE,tp,zone)
			end
			if zone==nil then zone=0xff end
			return _SpecialSummonStep(c,sumt,sump,tp,noc,nol,pos,zone)
		end
		function Duel.SpecialSummon(tg,sumt,sump,tp,noc,nol,pos,zone)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local num=0
				if aux.GetValueType(tg)=="Card" then
					if Duel.SpecialSummonStep(tg,sumt,sump,tp,noc,nol,pos,zone) then
						num=1
					end
					Duel.SpecialSummonComplete()
					return num
				end
				if aux.GetValueType(tg)=="Group" then   
					for tc in aux.Next(tg) do
						if Duel.SpecialSummonStep(tc,sumt,sump,tp,noc,nol,pos,zone) then
							num=num+1
						end
					end
					Duel.SpecialSummonComplete()
				end
				return num
			else
				if zone==nil then zone=0xff end
				return _SpecialSummon(tg,sumt,sump,tp,noc,nol,pos,zone) 
			end
		end

		function Duel.Summon(tp,c,ign,se,min,zone)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local zonet={0x01,0x02,0x04,0x08,0x10}
				local zoneToRemove = {}
				if zone==nil then 
					zone=0x1f
				end
				for i,v in pairs(zonet) do
					if not (Duel.CheckLocation(tp,LOCATION_MZONE,math.log(v,2)) or Duel.CheckTribute(c,1,nil,nil,nil,v) and c:IsSummonable(ign,se,1,v)) or v|zone ==0 then
						table.insert(zoneToRemove,i)
					end
				end
				for i = #zoneToRemove,1,-1 do
					table.remove(zonet,zoneToRemove[i])
				end
				zone=zonet[s.roll(1,#zonet)]
				Duel.Hint(HINT_ZONE,tp,zone)
			end
			if min==nil then min=0 end
			if zone==nil then zone=0x1f end
			_Summon(tp,c,ign,se,min,zone)
		end
		function Duel.MSet(tp,c,ign,e,min,zone)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local zonet={0x01,0x02,0x04,0x08,0x10}
				local zoneToRemove = {}
				if zone==nil then 
					zone=0x1f
				end
				for i,v in pairs(zonet) do
					if not (Duel.CheckLocation(tp,LOCATION_MZONE,math.log(v,2)) or Duel.CheckTribute(c,1,nil,nil,nil,v) and c:IsMSetable(ign,se,1,v)) or v|zone ==0 then
						table.insert(zoneToRemove,i)
					end
				end
				for i = #zoneToRemove,1,-1 do
					table.remove(zonet,zoneToRemove[i])
				end
				zone=zonet[s.roll(1,#zonet)]
				Duel.Hint(HINT_ZONE,tp,zone)
			end
			if min==nil then min=0 end
			if zone==nil then zone=0x1f end
			_MSet(tp,c,ign,se,min,zone)
		end
		function Duel.SelectDisableField(tp,count,sl,ol,filter)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local zonet=0
				if sl&LOCATION_SZONE>0 then
					if Duel.GetMasterRule()==3 then zonet=zonet|0xdf000000
					else zonet=zonet|0x1f000000 end
				end
				if sl&LOCATION_MZONE>0 then zonet=zonet|0x7f0000 end

				if ol&LOCATION_SZONE>0 then
					if Duel.GetMasterRule()==3 then zonet=zonet|0xdf00
					else zonet=zonet|0x1f00 end
				end
				if ol&LOCATION_FZONE>0 then zonet=zonet|0x2000 end
				if ol&LOCATION_MZONE>0 then zonet=zonet|0x7f end				
				if filter~=nil then zonet=zonet&~filter end
				local binary_string = ""
				for i = 31,0,-1 do
					local bit_value=(zonet>>i)&1
					binary_string=binary_string..bit_value
				end
				local result={}
				local bit_position=1
				for i = #binary_string,1,-1 do
					local bit_value=tonumber(binary_string:sub(i,i))
					if bit_value==1 and s.LocationIsAble(tp,bit_position) then
						table.insert(result,bit_position)
					end
					bit_position=bit_position*2
				end 
				if #result<count then return end
				local rz=0
				for i=1,count do
					local k=s.roll(1,#result)
					rz=rz+result[k]  
					table.remove(result,k)
				end
				return rz
			else
				return _SelectDisableField(tp,count,s,o,filter)
			end
		end
		function Duel.SelectField(tp,count,sl,ol,filter)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local zonet=0
				if sl&LOCATION_SZONE>0 then
					if Duel.GetMasterRule()==3 then zonet=zonet|0xff000000
					else zonet=zonet|0x3f000000 end
				end
				if sl&LOCATION_FZONE>0 then zonet=zonet|0x20000000 end
				if sl&LOCATION_MZONE>0 then zonet=zonet|0x7f0000 end

				if ol&LOCATION_SZONE>0 then 
					if Duel.GetMasterRule()==3 then zonet=zonet|0xff00
					else zonet=zonet|0x3f00 end
				end
				if ol&LOCATION_FZONE>0 then zonet=zonet|0x2000 end
				if ol&LOCATION_MZONE>0 then zonet=zonet|0x7f end				
				if filter~=nil then zonet=zonet&~filter end
				local binary_string = ""
				for i = 31,0,-1 do
					local bit_value=(zonet>>i)&1
					binary_string=binary_string..bit_value
				end
				local result={}
				local bit_position=1
				for i = #binary_string,1,-1 do
					local bit_value=tonumber(binary_string:sub(i,i))
					if bit_value==1 then
						table.insert(result,bit_position)
					end
					bit_position=bit_position*2
				end 
				if #result<count then return end
				local rz=0
				for i=1,count do
					local k=s.roll(1,#result)
					rz=rz+result[k]  
					table.remove(result,k)
				end
				Debug.Message(rz)
				return rz
			else
				return _SelectField(tp,count,s,o,filter)
			end   
		end
		local _AnnounceAttribute=Duel.AnnounceAttribute
		local _AnnounceCoin=Duel.AnnounceCoin
		local _AnnounceLevel=Duel.AnnounceLevel
		local _AnnounceNumber=Duel.AnnounceNumber
		local _AnnounceRace=Duel.AnnounceRace
		local _AnnounceType=Duel.AnnounceType
		function Duel.AnnounceAttribute(p,count,att)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local attt={0x01,0x02,0x04,0x08,0x10,0x20,0x40}
				local AttToRemove={}
				for i,v in pairs(attt) do
					if v|att ==0 then
						table.insert(AttToRemove,i)
					end
				end
				for i = #AttToRemove,1,-1 do
					table.remove(attt,AttToRemove[i])
				end
				local catt=0
				if count>#attt then return end
				for i=1,count do
					local k=s.roll(1,#attt)
					catt=catt+attt[k]
					table.remove(attt,k)
				end
				Duel.Hint(HINT_ATTRIB,1,catt)
				Duel.Hint(HINT_ATTRIB,0,catt)
				return catt
			else
				_AnnounceAttribute(p,count,att)
			end
		end  
		function Duel.AnnounceCoin(p,...)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local i =s.roll(0,1)
				Duel.Hint(HINT_OPSELECTED,1,aux.Stringid(id,i+4))
				Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(id,i+4))
				return i
			else
				_AnnounceCoin(p,...)
			end
		end  
		function Duel.AnnounceLevel(p,min,max,...)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				if min==nil then min=1 end
				if max==nil then max=12 end
				local lvnum = {}					 
				for v=min,max do
					for i=1,select("#",...) do
						local val = select(i,...)
						if v==val then
							break
						end  
					end   
					table.insert(lvnum,v)   
				end
				local clv=lvnum[s.roll(1,#lvnum)]
				Duel.Hint(HINT_NUMBER,1,clv)
				Duel.Hint(HINT_NUMBER,0,clv)
				return clv
			else
				if min and max then
					_AnnounceLevel(p,min,max,...)
				else if min then _AnnounceLevel(p,min)
				else _AnnounceLevel(p) end end
			end
		end  
		function Duel.AnnounceNumber(p,...)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local numt = {...}
				local cno = math.random(select("#", ...))
				Duel.Hint(HINT_NUMBER,1,numt[cno])
				Duel.Hint(HINT_NUMBER,0,numt[cno])
				return numt[cno],cno
			else
				_AnnounceNumber(p,...)
			end
		end
		function Duel.AnnounceRace(p,count,ra)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local rat={0x1,0x2,0x4,0x8,0x10,0x20,0x40,0x80,0x100,0x200,0x400,0x800,0x1000,0x2000,0x4000,0x8000,0x10000,0x20000,0x40000,0x80000,0x100000,0x200000,0x400000,0x800000,0x100000,0x200000}
				local raToRemove={}
				for i,v in pairs(rat) do
					if v|ra ==0 then
						table.insert(raToRemove,i)
					end
				end
				for i = #raToRemove,1,-1 do
					table.remove(rat,raToRemove[i])
				end
				local cra=0
				if count>#rat then return end
				for i=1,count do
					local k=s.roll(1,#rat)
					cra=cra+rat[k]
					table.remove(rat,k)
				end
				Duel.Hint(HINT_RACE,1,cra)
				Duel.Hint(HINT_RACE,0,cra)
				return cra
			else
				_AnnounceRace(p,count,ra)
			end
		end  
		function Duel.AnnounceType(p,...)
			if Duel.IsPlayerAffectedByEffect(0,id) then
				local i=s.roll(0,2)
				Duel.Hint(HINT_OPSELECTED,1,aux.Stringid(id,i+1))
				Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(id,i+1))
				return i
			else
				_AnnounceType(p,...)
			end
		end
		
	end
	
end
local Fusg={{},{}}
local A=1103515245
local B=12345
local M=32767
function s.LocationIsAble(tp,bit_position)
	if bit_position>0xff0000 then return Duel.CheckLocation(1-tp,LOCATION_SZONE,math.log(bit_position>>24,2)) end
	if bit_position<=0xff0000 and bit_position>0xff00 then return Duel.CheckLocation(1-tp,LOCATION_MZONE,math.log(bit_position>>16,2)) end
	if bit_position<=0xff00 and bit_position>0xff then return Duel.CheckLocation(tp,LOCATION_SZONE,math.log(bit_position>>8,2)) end
	if bit_position<=0xff then return Duel.CheckLocation(tp,LOCATION_MZONE,math.log(bit_position,2)) end
end
function s.roll(min,max)
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
		s.r=result&0xffffffff	   
	end
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
function s.filter(g,f,nc,...)
	if aux.GetValueType(f)=="function" then return g:Filter(f,nc,...) end
	local ng=g:Clone()
	if aux.GetValueType(nc)=="Card" then ng:RemoveCard(nc) end
	if aux.GetValueType(nc)=="Group" then ng:Sub(nc) end
	return ng
end
function s.ffilter(c,fc,sub,mg,sg)
	if not sg then return true end
	return not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())
end
function s.matlimit(e,c,fc,st)
	if st~=SUMMON_TYPE_FUSION then return true end
	local code=c:GetFusionCode()
	local ftable=Fusg[e:GetHandler():GetOwner()+1]
	for i=1,6 do
		if ftable[i]==code then return true end
	end
	return false
end
function s.fuop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	for p=0,1 do
		Group.Merge(g,Duel.GetFieldGroup(p,0xff,0):RandomSelect(p,2))
		local rg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,p,LOCATION_EXTRA,0,nil,id)
		if rg:GetCount()>0 then
			local g1=Duel.GetFieldGroup(p,LOCATION_DECK+LOCATION_HAND,0):Filter(Card.IsType,nil,TYPE_MONSTER)
			if g1:GetClassCount(Card.GetCode)<6 then return end
			local fg=Group.CreateGroup()
			local tc=g1:GetFirst()
			while tc and fg:GetCount()<6 do
				g1:RemoveCard(tc)
				if fg:Filter(Card.IsCode,nil,tc:GetCode()):GetCount()==0 then fg:AddCard(tc) end
				tc=g1:RandomSelect(p,1):GetFirst()
			end
			if fg:GetCount()==6 then
				Group.Merge(g,fg)
				local cc=fg:GetFirst()
				for i=1,6 do
					Fusg[p+1][i]=cc:GetCode()
					cc=fg:GetNext()
				end
				rg:ForEach(s.addfu,p)
				Duel.ConfirmCards(p,fg)
			end
		end
	end
	if not s.r then
		local result=0
		local tc=g:GetFirst()
		while tc do
			result=result+tc:GetCode()
			tc=g:GetNext()
		end
		g:DeleteGroup()  
		s.r=result&0xffffffff
	end
end

function s.addfu(c,p)
	aux.AddFusionProcMixRep(c,true,true,Fusg[p+1][1],1,1,Fusg[p+1][2],Fusg[p+1][3],Fusg[p+1][4],Fusg[p+1][5],Fusg[p+1][6])
	local mt =getmetatable(c)
	for i=1,6 do
		local code=Fusg[p+1][i]
		mt.material[code] = false
	end
end
function s.valcheck(e,c)
	local mg=c:GetMaterial()
	local tc=mg:GetFirst()
	local atk=0
	local def=0
	while tc do
		if tc:GetTextAttack()>0 then atk=atk+tc:GetTextAttack() end
		if tc:GetTextDefense()>0 then def=def+tc:GetTextDefense() end
		local re1=Effect.CreateEffect(c)
		re1:SetType(EFFECT_TYPE_SINGLE)
		re1:SetCode(EFFECT_ADD_RACE)
		re1:SetValue(tc:GetRace())
		re1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(re1)
		local re2=re1:Clone()
		re2:SetCode(EFFECT_ADD_ATTRIBUTE)
		re2:SetValue(tc:GetAttribute())
		c:RegisterEffect(re2)
		tc=mg:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(def)
	c:RegisterEffect(e2)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num = s.roll(1,12)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(num)
	c:RegisterEffect(e1)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(0,id)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local ac=Duel.GetAttacker()
	local tc=Duel.SelectMatchingCard(ac:GetControler(),nil,ac:GetControler(),0,LOCATION_MZONE,1,1,nil):GetFirst()
	if not Duel.GetAttacker():IsImmuneToEffect(e) then
		Duel.ChangeAttackTarget(tc)
	end
end
