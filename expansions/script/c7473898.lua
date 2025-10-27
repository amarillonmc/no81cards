--仪式送去额外卡组
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(0xff)
	e2:SetOperation(s.adjustop)
	c:RegisterEffect(e2)
	--win
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(0xff)
	e3:SetOperation(s.winadjustop)
	c:RegisterEffect(e3)
	--win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(0xff)
	e4:SetOperation(s.winadjustop2)
	c:RegisterEffect(e4)
	--adjust
	--[[local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)]]
	--move to field
	if Duel.DisableActionCheck then
		--if not s.group then s.group=Group.CreateGroup() end
		--gain tp
		local ct=Duel.GetFieldGroupCount(0,0,LOCATION_DECK+LOCATION_REMOVED)
		local ct2=Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)
		local tp=0
		if ct>0 or ct2>0 then tp=1 end
		--
		if s.global_check and s[tp] and s[tp]==1 then return end
		s.global_check=true
		s[tp]=1
		--to field
		local move=(function()
			local ct=Duel.GetFieldGroupCount(0,0,LOCATION_DECK+LOCATION_REMOVED)
			local ct2=Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)
			local tp=0
			if ct>0 or ct2>0
			then tp=1 end
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
		end)
		--to field
		local activate=(function()
			--Debug.Message("0")
			if s.target(e1,tp,nil,0,0,nil,0,0,0) then 
				--Debug.Message("1")
				s.target(e1,tp,nil,0,0,nil,0,0,1) 
				s.activate(e1,tp,nil,0,0,nil,0,0) 
	
			end
		end)
		local activate2=(function()
			--Debug.Message("1")
			Duel.RaiseEvent(c,EVENT_CUSTOM+71625222,0,0,0,0,0) 
		end)
		Duel.DisableActionCheck(true)
		pcall(move)
		pcall(activate)
		--
		s.initialization(tp)
		Duel.DisableActionCheck(false)
		--
		local _RegisterEffect=Card.RegisterEffect
		function Card.RegisterEffect(rc,eff,bool)
			local int=_RegisterEffect(rc,eff,bool)
			if not s.globle_check and s.filter(rc) --and
				--rc:IsLocation(LOCATION_EXTRA)
				then
				--s.action_check=true
				--s.group:AddCard(rc)
				Duel.DisableActionCheck(true)
				pcall(activate)
				--pcall(Duel.Remove(rc,POS_FACEUP,REASON_EFFECT))
				Duel.DisableActionCheck(false)
				--s.action_check=false
			elseif not s.globle_check and rc:IsLocation(LOCATION_EXTRA) then
				Duel.DisableActionCheck(true)
				pcall(activate)
				Duel.DisableActionCheck(false)
				--[[if rc:GetFieldGroupCount(tp,0xff-LOCATION_EXTRA-LOCATION_REMOVED,0)<40 then
					Duel.Win(1-tp,WIN_REASON_EXODIA)
				end]]
			end
			if not s[tp+3] and Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)>0 and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0 then
				s[tp+3]=1
				Duel.DisableActionCheck(true)
				pcall(activate)
				--Duel.Hint(hint_)
				--Debug.Message("0")
				--pcall(activate2)
				Duel.DisableActionCheck(false)
			end
			--Duel.DisableActionCheck(true)
			--pcall(Duel.Remove(rc,POS_FACEUP,REASON_EFFECT))
			--Duel.DisableActionCheck(false)
			return int
		end
	end
end

function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
	end
	--Debug.Message("3")
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message("5")
	--
	--Debug.Message("4")
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	--s.group:Merge(g)
	--local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local tc_type=tc:GetType()
		tc:SetCardData(CARDDATA_TYPE,TYPE_MONSTER+TYPE_EFFECT+TYPE_SYNCHRO)
		tc:RegisterFlagEffect(id+o,0,0,1,tc_type)
	end
	--Debug.Message("0")
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	--
	s.initialization(tp)
end
function s.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function s.edfilter(c)
	return c:GetFlagEffect(id+o)~=0
end
function s.initialization(tp)
	--
	if (tp==0 and not s.global_select_check1) or (tp==1 and not s.global_select_check2) then
		if tp==0 then
			--Debug.Message("0")
			s.global_select_check1=true
		else 
			--Debug.Message("1")
			s.global_select_check2=true
		end
		--[[local _IsExistingMatchingCard=Duel.IsExistingMatchingCard
		function Duel.IsExistingMatchingCard(func,pl,self,o,num,c_g_n,...)
			local eg=Duel.GetMatchingGroup(func,pl,self,o,c_g_n,...)
			local reg=Duel.GetMatchingGroup(rfilter,pl,LOCATION_REMOVED,LOCATION_REMOVED,c_g_n,...)
			reg=reg:Filter(func,c_g_n,...)
			if #reg<=0 then return _IsExistingMatchingCard(func,pl,self,o,num,c_g_n,...) end
			return eg:IsExists(func,num,c_g_n,...)
		end
		--
		local _IsExistingTarget=Duel.IsExistingTarget
		function Duel.IsExistingTarget(func,pl,self,o,num,c_g_n,...)
			local eg=Duel.GetMatchingGroup(func,pl,self,o,c_g_n,...)
			local reg=Duel.GetMatchingGroup(rfilter,pl,LOCATION_REMOVED,LOCATION_REMOVED,c_g_n,...)
			reg=reg:Filter(func,c_g_n,...)
			if #reg<=0 then return _IsExistingTarget(func,pl,self,o,num,c_g_n,...) end
			return eg:IsExists(func,num,c_g_n,...)
		end]]
		--Debug.Message(s[tp]) -- tp=0,s[tp]=1
		s[100]=10
		--Debug.Message(s[100])
		--[[local _IsType=Card.IsType
		function Card.IsType(card,type)
			if (type&TYPE_RITUAL)~=0 then s[s[100]+1]=1 end
			return _IsType(card,type)
		end]]
		function bit.band(a,b)
			--Debug.Message("114514")
			if (a&0x81)==0x81 and (b&0x81)==0x81 then s[s[100]+1]=1
			--Debug.Message("114514") 
			end
			return a&b
		end
		--[[local _IsCanBeRitualMaterial=Card.IsCanBeRitualMaterial
		function Card.IsCanBeRitualMaterial(c,sc_nil)
			if sc_nil and sc_nil:IsLocation(LOCATION_EXTRA) and sc_nil:IsFacedown() then 
			return true end
			return _IsCanBeRitualMaterial(c,sc_nil)
		end]]
		local _IsCanBeSpecialSummoned=Card.IsCanBeSpecialSummoned
		function Card.IsCanBeSpecialSummoned(card,effect,sumtype,sp,nocheck,nolimit,...)
			if sumtype&SUMMON_TYPE_RITUAL==SUMMON_TYPE_RITUAL and (not s[s[100]+1] or not s[s[100]+1]~=1) then
				s[s[100]+1]=1
			end
			--Debug.Message("114514")
			--Debug.Message(s[100]+2)
			if card:IsType(TYPE_RITUAL) then 
				s[s[100]+2]=1  
				if --s[s[100]+1]==1 and 
					card:IsLocation(LOCATION_EXTRA) then
					return _IsCanBeSpecialSummoned(card,effect,sumtype,sp,nocheck,true,...)
				end
			end
			return _IsCanBeSpecialSummoned(card,effect,sumtype,sp,nocheck,nolimit,...)
		end
		local _SpecialSummonStep=Duel.SpecialSummonStep
		function Duel.SpecialSummonStep(card,sumtype,sp,top,nocheck,nolimit,...)
			if card:IsType(TYPE_RITUAL) and card:IsLocation(LOCATION_EXTRA) and card:IsFacedown() then
				local c_type=card:GetType()
				local _IsType=Card.IsType
				function Card.IsType(ca,type)
					if ca and ca==card then return c_type&type==type end
					return _IsType(ca,type)
				end
				local _GetOriginalType=Card.GetOriginalType
				function Card.GetOriginalType(ca)
					if ca and ca==card then return c_type end
					return _GetOriginalType(ca)
				end
				card:SetCardData(CARDDATA_TYPE,TYPE_SYNCHRO+TYPE_EFFECT+TYPE_MONSTER)
				local boolean=_SpecialSummonStep(card,sumtype,sp,top,nocheck,true,...) 
				card:SetCardData(CARDDATA_TYPE,c_type)
				Card.IsType=_IsType
				Card.GetOriginalType=_GetOriginalType
				return boolean 
			end
			return _SpecialSummonStep(card,sumtype,sp,top,nocheck,nolimit,...)
		end
		local _SpecialSummon=Duel.SpecialSummon
		function Duel.SpecialSummon(card,sumtype,sp,top,nocheck,nolimit,...)
			if aux.GetValueType(card)=="Card" and card:IsType(TYPE_RITUAL) and card:IsLocation(LOCATION_EXTRA) and card:IsFacedown() then
				local c_type=card:GetType()
				local _IsType=Card.IsType
				function Card.IsType(ca,type)
					if ca and ca==card then return c_type&type==type end
					return _IsType(ca,type)
				end
				local _GetOriginalType=Card.GetOriginalType
				function Card.GetOriginalType(ca)
					if ca and ca==card then return c_type end
					return _GetOriginalType(ca)
				end
				card:SetCardData(CARDDATA_TYPE,TYPE_SYNCHRO+TYPE_EFFECT+TYPE_MONSTER)
				local boolean=_SpecialSummon(card,sumtype,sp,top,nocheck,true,...) 
				card:SetCardData(CARDDATA_TYPE,c_type)
				Card.IsType=_IsType
				Card.GetOriginalType=_GetOriginalType
				return boolean 
			end
			if aux.GetValueType(card)=="Group" and #card>0 and card:FilterCount((function(c) return c:IsType(TYPE_RITUAL) and c:IsFacedown() and c:IsLocation(LOCATION_EXTRA) end),nil)>0 then
				local tc=card:GetFirst()
				while tc do
					local bool=nolimit
					if tc:IsType(TYPE_RITUAL) then 
						bool=true
						--[[local c_type=tc:GetType()
						local _IsType=tc.IsType
						function Card.IsType(ca,type)
							if ca and ca==card then return c_type&type==type end
							return _IsType(ca,type)
						end
						local _GetOriginalType=Card.GetOriginalType
						function Card.GetOriginalType(ca)
							if ca and ca==tc then return c_type end
							return _GetOriginalType(ca)
						end
						tc:SetCardData(CARDDATA_TYPE,TYPE_SYNCHRO+TYPE_EFFECT+TYPE_MONSTER)
						Duel.SpecialSummonStep(tc,sumtype,sp,top,nocheck,bool,...)
						tc:SetCardData(CARDDATA_TYPE,c_type)
						Card.IsType=_IsType
						Card.GetOriginalType=_GetOriginalType]]
					end
					Duel.SpecialSummonStep(tc,sumtype,sp,top,nocheck,bool,...)
					tc=card:GetNext()
				end
				return Duel.SpecialSummonComplete() 
			end
			return _SpecialSummon(card,sumtype,sp,top,nocheck,nolimit,...)
		end
		--
		local _IsExistingMatchingCard=Duel.IsExistingMatchingCard
		function Duel.IsExistingMatchingCard(func,pl,self,o,num,c_g_n,...)
			s[100]=s[100]+3
			local check=s[100]+1
			--Debug.Message("0")
			--Debug.Message("s[check]")
			--Debug.Message(check)
			--Debug.Message(s[check])
			s[check]=0
			s[check+1]=0
			local result=_IsExistingMatchingCard(func,pl,self,o,num,c_g_n,...)
			local result2=_IsExistingMatchingCard(func,pl,self|LOCATION_EXTRA,o,num,c_g_n,...)
			--[[if s[pl] then Debug.Message("01") end
			if s[pl]==1 then Debug.Message("02") end
			if s[check]==1 then Debug.Message("03") end
			--Debug.Message(check+1)
			if s[check+1]==1 then  Debug.Message("04") end
			if ((self&0x02)~=0 or (self&0x01)~=0) then  Debug.Message("05") end]]
			if s[pl] and s[pl]==1 and s[check]==1 and s[check+1]==1
				--and ((self&0x02)~=0 or (self&0x01)~=0) 
				then
				--Debug.Message("114")
				result=result2
			end
			s[check]=0
			s[check+1]=0
			s[100]=s[100]-3
			return result
		end
		--
		local _GetMatchingGroup=Duel.GetMatchingGroup
		function Duel.GetMatchingGroup(func,pl,self,o,c_g_n,...)
			s[100]=s[100]+3
			local check=s[100]+1
			s[check]=0
			s[check+1]=0
			local result=_GetMatchingGroup(func,pl,self,o,c_g_n,...)
			local result2=_GetMatchingGroup(func,pl,self|LOCATION_EXTRA,o,c_g_n,...)
			if s[pl] and s[pl]==1 and s[check]==1 and s[check+1]==1
				then
				result=result2
			end
			s[check]=0
			s[check+1]=0
			s[100]=s[100]-3
			return result
		end
		--
		--[[local _IsExistingTarget=Duel.IsExistingTarget
		function Duel.IsExistingTarget(func,pl,self,o,num,c_g_n,...)
			--return _IsExistingTarget(func,pl,self,o,num,c_g_n,...)
			s[100]=s[100]+3
			local check=s[100]+1
			s[check]=0
			s[check+1]=0
			--Debug.Message("1")
			local result=_IsExistingTarget(func,pl,self,o,num,c_g_n,...)
			local result2=_IsExistingTarget(func,pl,self|LOCATION_EXTRA,o|LOCATION_EXTRA,num,c_g_n,...)
			--  Debug.Message(check+1)
			--  Debug.Message(s[check+1])
			if s[pl] and s[pl]==1 and s[check]==1 and s[check+1]==1
				--and ((self&0x02)~=0 or (self&0x01)~=0) 
				then
				Debug.Message("4")
				result=result2
			end
			--if result then Debug.Message("6") end
			--Debug.Message("5")
			s[check]=0
			s[check+1]=0
			s[100]=s[100]-3
			return result
		end]]
		--
		local _SelectMatchingCard=Duel.SelectMatchingCard
		function Duel.SelectMatchingCard(spl,func,pl,self,o,min,max,c_g_n,...)
			s[100]=s[100]+3
			local check=s[100]+1
			s[s[100]+1]=0
			s[s[100]+2]=0
			--Debug.Message("2")
			local result=_IsExistingMatchingCard(func,pl,self|LOCATION_EXTRA,o,min,c_g_n,...)
			if s[pl] and s[pl]==1 and s[check]==1 and s[check+1]==1
				--and ((self&0x02)~=0 or (self&0x01)~=0) 
				then
				result=_SelectMatchingCard(spl,func,pl,self|LOCATION_EXTRA,o,min,max,c_g_n,...)
			else
				result=_SelectMatchingCard(spl,func,pl,self,o,min,max,c_g_n,...)
			end
			s[check]=0
			s[check+1]=0
			s[100]=s[100]-3
			return result
		end
		--
		--[[local _SelectTarget=Duel.SelectTarget
		function Duel.SelectTarget(spl,func,pl,self,o,min,max,c_g_n,...)
			s[100]=s[100]+3
			local check=s[100]+1
			s[s[100]+1]=0
			s[s[100]+2]=0
			--Debug.Message("3")
			local result=_IsExistingTarget(func,pl,self|LOCATION_EXTRA,o|LOCATION_EXTRA,min,c_g_n,...)
			if s[pl] and s[pl]==1 and s[check]==1 and s[check+1]==1
				--and ((self&0x02)~=0 or (self&0x01)~=0) 
				then
				result=_SelectTarget(spl,func,pl,self|LOCATION_EXTRA,o|LOCATION_EXTRA,min,max,c_g_n,...)
			else
				result=_SelectTarget(spl,func,pl,self,o,min,max,c_g_n,...)
			end
			s[check]=0
			s[check+1]=0
			s[100]=s[100]-3
			return result
		end]]
	end
end

function s.tgfilter(c)
	return c:GetOriginalCode()==id
end
function s.resetfilter(c)
	return c:GetFlagEffect(id+o)~=0
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check and Duel.GetFieldGroupCount(0,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(0,0,LOCATION_HAND)>0 then
		s.globle_check=true
		--effect edit--
		--[[local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(s.actarget)
		Duel.RegisterEffect(ge0,tp)]]
		local g=Duel.GetMatchingGroup(s.edfilter,tp,0xff,0,nil)
		cregister=Card.RegisterEffect
		esetrange=Effect.SetRange
		eclone=Effect.Clone
		Blacklotus_RD_Ritual_table_effect={}
		Blacklotus_RD_Ritual_table_range={}
		Blacklotus_RD_Ritual_Discard_Boolean=true
		Blacklotus_RD_Ritual_Discard_Check=false
		Effect.SetRange=function(effect,range)
			Blacklotus_RD_Ritual_table_range[effect]=range
			return esetrange(effect,range)
		end
		s.GetRange=function(effect)
			if Blacklotus_RD_Ritual_table_range[effect] then 
				return Blacklotus_RD_Ritual_table_range[effect]
			end
			return nil
		end
		Effect.Clone=function(effect)
			local clone_effect=eclone(effect)
			if s.GetRange(effect) then
				Blacklotus_RD_Ritual_table_range[clone_effect]=s.GetRange(effect)
			end
			return clone_effect
		end
		--discard_edit
		cisdiscardable=Card.IsDiscardable
		Card.IsDiscardable=function(card,reason)
			if not Blacklotus_RD_Ritual_Discard_Boolean then
				return card:IsAbleToGraveAsCost() and card:IsLocation(LOCATION_EXTRA)
			end
			return cisdiscardable(card,reason)
		end
		dsendtograve=Duel.SendtoGrave
		Duel.SendtoGrave=function(card,reason)
			if not Blacklotus_RD_Ritual_Discard_Boolean and card:IsLocation(LOCATION_EXTRA) then
				Blacklotus_RD_Ritual_Discard_Check=true
				return dsendtograve(card,bit.bxor(reason,REASON_DISCARD))
			end
			return dsendtograve(card,reason)
		end
		--for i,f in pairs(Effect) do Debug.Message(i) end
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				if s.GetRange(effect) and s.GetRange(effect)==LOCATION_HAND and (effect:IsHasType(EFFECT_TYPE_QUICK_O) or effect:IsHasType(EFFECT_TYPE_TRIGGER_O) or effect:IsHasType(EFFECT_TYPE_TRIGGER_F) or effect:IsHasType(EFFECT_TYPE_IGNITION)) then
					local cost=eff:GetCost()
					eff:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then
						Blacklotus_RD_Ritual_Discard_Boolean=false
						local boolean=not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)
						Blacklotus_RD_Ritual_Discard_Boolean=true
						return boolean
					end
					Blacklotus_RD_Ritual_Discard_Check=false
					Blacklotus_RD_Ritual_Discard_Boolean=false
					cost(e,tp,eg,ep,ev,re,r,rp,chk)
					Blacklotus_RD_Ritual_Discard_Boolean=true
					if not Blacklotus_RD_Ritual_Discard_Check then Duel.ConfirmCards(1-tp,e:GetHandler()) end
					end)
					esetrange(eff,LOCATION_EXTRA)
					table.insert(Blacklotus_RD_Ritual_table_effect,eff)
				end
			end
			return 
		end
		if #g>0 then
			for tc in aux.Next(g) do
				Blacklotus_RD_Ritual_table_effect={}
				Duel.CreateToken(0,tc:GetOriginalCode())
				if #Blacklotus_RD_Ritual_table_effect>0 then
					for key,eff in ipairs(Blacklotus_RD_Ritual_table_effect) do
						cregister(tc,eff)
					end
				end
			end
		end
		Card.RegisterEffect=cregister
		Effect.SetRange=esetrange
		Effect.Clone=eclone
		--

		local resg=Duel.GetMatchingGroup(s.resetfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		Duel.SendtoDeck(resg,nil,0,REASON_EFFECT) 
		for tc in aux.Next(resg) do
			local tc_type=tc:GetFlagEffectLabel(id+o)
			tc:SetCardData(CARDDATA_TYPE,tc_type)
			tc:ResetFlagEffect(id+o)
		end
		--s.activate(e,tp,eg,ep,ev,re,r,rp)
		--Duel.SpecialSummon(resg,SUMMON_TYPE_RITUAL,0,0,false,true,POS_FACEUP_ATTACK)
		local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #g>0 then Duel.SendtoGrave(g,REASON_RULE) end
		--if Duel.GetFieldGroupCount(0,0xff-LOCATION_EXTRA,0)<40 then
		--  Duel.SetLP(0,0)
		--end
		--[[		for i=0,25 do
					for v=0,25 do
						Duel.Hint(i,0,v)
					end
				end]]
		e:Reset()
	end
end
function s.winadjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		if Duel.GetFieldGroupCount(tp,0xff-LOCATION_EXTRA-LOCATION_REMOVED,0)<40 then
			Duel.Win(1-tp,0)
		end
	else
		e:Reset()
	end
end
function s.winadjustop2(e,tp,eg,ep,ev,re,r,rp)
	--
	if Duel.GetFieldGroupCount(tp,0xff-LOCATION_EXTRA,0)<40 then
		Duel.Win(1-tp,0)
	end
end

-----------------------Deck Activate-----------------------

function s.costtg(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc==e:GetHandler() and te:IsHasType(EFFECT_TYPE_QUICK_O) and (tc:IsLocation(LOCATION_HAND) or tc:IsLocation(LOCATION_DECK))
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	te:SetType(EFFECT_TYPE_ACTIVATE)
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	local ge3=Effect.CreateEffect(tc)
	ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ge3:SetCode(EVENT_CHAIN_SOLVED)
	ge3:SetLabelObject(te)
	ge3:SetReset(RESET_PHASE+PHASE_END)
	ge3:SetOperation(s.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		re:SetType(EFFECT_TYPE_QUICK_O)
		e:Reset()
	end
end
