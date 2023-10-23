--龙仪巧-摩羯流星＝CAP
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
local m=11612633
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/11610000") end) then require("script/11610000") end
cm.text=zhc_lhq_mj
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e00=fpjdiy.Zhc(c,cm.text)
	--  
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(cm.destg)
	e1:SetValue(cm.Value)
	--e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	--e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)  
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.matcon)
	e3:SetOperation(cm.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
	--copy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,m*2+1)
	e4:SetRange(LOCATION_MZONE)
	--e4:SetCondition(cm.decon)
	e4:SetTarget(cm.postg)
	e4:SetOperation(cm.posop)
	c:RegisterEffect(e4)
	--random seed
	if not Party_time_random_seed then
		local result=0
		local g=Duel.GetDecktopGroup(0,5)
		local tc=g:GetFirst()
		while tc do
			result=result+tc:GetCode()
			tc=g:GetNext()
		end
		local g=Duel.GetDecktopGroup(1,5)
		local tc=g:GetFirst()
		while tc do
			result=result+tc:GetCode()
			tc=g:GetNext()
		end
		--local g=Duel.GetFieldGroup(0,0xff,0xff):RandomSelect(2,8)
		--local ct={}
		--local c=g:GetFirst()
		--for i=0,7 do
		--  ct[c]=i
		--  c=g:GetNext()
		--end
		--for i=0,10 do
		--  result=result+(ct[g:RandomSelect(2,1):GetFirst()]<<(3*i))
		--end
		g:DeleteGroup()
		--Party_time_random_seed=result&0xffffffff
		Party_time_random_seed=result
		function Party_time_roll(min,max)
			if min==max then return min end
			min=tonumber(min)
			max=tonumber(max)
			Party_time_random_seed=(Party_time_random_seed*16807)%2147484647
			if min~=nil then
				if max==nil then
					local random_number=Party_time_random_seed/2147484647
					return math.floor(random_number*min)+1
				else
					local random_number=Party_time_random_seed/2147484647
					if random_number<min then
						Party_time_random_seed=(Party_time_random_seed*16807)%2147484647
						random_number=Party_time_random_seed/2147484647
					end
					--Debug.Message(max)
					--Debug.Message(Party_time_random_seed)
					--Debug.Message(math.floor((max-min)*random_number))
					return math.floor((max-min)*random_number)+1+min
				end
			end
			return Party_time_random_seed
		end
	end
	--random select
	if not Party_time_globle_check then
		Party_time_globle_check=true
		Party_time_table={}
		function Party_time_RandomSelect(g,tp,count)
			if #g<=0 then return end
			if count>#g then count=#g end
			local cg=g:Clone()
			local sg=Group.CreateGroup()
			while #sg<count do
				local id=Party_time_roll(0,#cg)
				local tc=cg:GetFirst()
				if id>1 then
					for i=1,id-1,1 do tc=cg:GetNext() end
				end
				sg:AddCard(tc)
				cg:RemoveCard(tc)
			end
			--Duel.HintSelection(g)
			Duel.HintSelection(sg)
			return sg
		end
		_SendtoDeck=Duel.SendtoDeck
		function Duel.SendtoDeck(tg,tp,seq,reason)
			if Duel.GetCurrentChain()~=0 then
				local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
				if id~=0 and Duel.GetFlagEffect(0,11612632+id)~=0 then
					if not tp and aux.GetValueType(tg)=="Card" and tg:GetFlagEffectLabel(m)==11612632+id and tg:IsLocation(LOCATION_DECK) then 
						return _SendtoDeck(tg,1-tg:GetControler(),seq,reason)  
					end
					if not tp and aux.GetValueType(tg)=="Group" then 
						local sg=tg:Filter(cm.rfilter,nil,11612632+id):Filter(Card.IsLocation,nil,LOCATION_DECK)
						if sg and sg:GetCount()>0 then
							tg:Sub(sg)
							if tg and tg:GetCount()>0 then
								_SendtoDeck(tg,tp,seq,reason)
							end
							return _SendtoDeck(sg,1-sg:GetFirst():GetControler(),seq,reason) 
						end
					end
				end
			end
			return _SendtoDeck(tg,tp,seq,reason)
		end
		_SendtoHand=Duel.SendtoHand
		function Duel.SendtoHand(tg,tp,reason)
			if Duel.GetCurrentChain()~=0 then
				local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
				if id~=0 and Duel.GetFlagEffect(0,11612632+id)~=0 then
					if not tp and aux.GetValueType(tg)=="Card" and tg:GetFlagEffectLabel(m)==11612632+id and tg:IsLocation(LOCATION_HAND) then 
						return _SendtoHand(tg,1-tg:GetControler(),reason) 
					end
					if not tp and aux.GetValueType(tg)=="Group" then 
						local sg=tg:Filter(cm.rfilter,nil,11612632+id):Filter(Card.IsLocation,nil,LOCATION_HAND)
						if sg and sg:GetCount()>0 then
							tg:Sub(sg)
							if tg and tg:GetCount()>0 then
								_SendtoHand(tg,tp,reason) 
							end
							return _SendtoHand(sg,1-sg:GetFirst():GetControler(),reason) 
						end
					end
				end
			end
			return _SendtoHand(tg,tp,reason)
		end
		_Select=Group.Select
		function Group.Select(g,tp,min,max,cg)
			if Duel.GetCurrentChain()~=0 then
				local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
				local ag=Party_time_table[11612632+id]
				if id~=0 and Duel.GetFlagEffect(0,11612632+id)~=0 then
					local sg=g:Clone()
					if aux.GetValueType(ag)=="Group" then 
						ag=ag:Filter(cm.rfilter,nil,11612632+id)
						if ag:GetCount()~=0 then
							sg:Merge(ag) 
						end
					end
					if aux.GetValueType(cg)=="Card" then sg:RemoveCard(cg) end
					if aux.GetValueType(cg)=="Group" then sg:Sub(cg) end
					return Party_time_RandomSelect(sg,0,Party_time_roll(min,max))
				end
			end
			return _Select(g,tp,min,max,cg)
		end
		_SelectMatchingCard=Duel.SelectMatchingCard
		function Duel.SelectMatchingCard(sp,f,tp,s,o,min,max,cg,...)
			if Duel.GetCurrentChain()~=0 then
				local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
				local ag=Party_time_table[11612632+id]
				if id~=0 and Duel.GetFlagEffect(0,11612632+id)~=0 then
					local g=Duel.GetMatchingGroup(f,tp,s,o,cg,...)
					if aux.GetValueType(ag)=="Group" then 
						ag=ag:Filter(cm.rfilter,nil,11612632+id)
						if ag:GetCount()~=0 then
							g:Merge(ag) 
						end
					end
					if aux.GetValueType(cg)=="Card" then g:RemoveCard(cg) end
					if aux.GetValueType(cg)=="Group" then g:Sub(cg) end
					return Party_time_RandomSelect(g,0,Party_time_roll(min,max))
				end
			end
			return _SelectMatchingCard(sp,f,tp,s,o,min,max,cg,...)
		end
		_SelectReleaseGroup=Duel.SelectReleaseGroup
		function Duel.SelectReleaseGroup(sp,f,min,max,cg,...)
			if Duel.GetCurrentChain()~=0 then
				local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
				local ag=Party_time_table[11612632+id]
				if id~=0 and Duel.GetFlagEffect(0,11612632+id)~=0 then
					local g=Duel.GetReleaseGroup(sp)
					local g=g:Filter(f,cg,...)
					if aux.GetValueType(ag)=="Group" then 
						ag=ag:Filter(cm.rfilter,nil,11612632+id)
						if ag:GetCount()~=0 then
							g:Merge(ag) 
						end
					end
					if aux.GetValueType(cg)=="Card" then g:RemoveCard(cg) end
					if aux.GetValueType(cg)=="Group" then g:Sub(cg) end
					return Party_time_RandomSelect(g,0,Party_time_roll(min,max))
				end
			end
			return _SelectReleaseGroup(sp,f,min,max,cg,...)
		end
		_SelectReleaseGroupEx=Duel.SelectReleaseGroupEx
		function Duel.SelectReleaseGroupEx(sp,f,min,max,cg,...)
			if Duel.GetCurrentChain()~=0 then
				local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
				local ag=Party_time_table[11612632+id]
				if id~=0 and Duel.GetFlagEffect(0,11612632+id)~=0 then
					local g=Duel.GetReleaseGroup(sp)
					local g=g:Filter(f,cg,...)
					if aux.GetValueType(ag)=="Group" then 
						ag=ag:Filter(cm.rfilter,nil,11612632+id)
						if ag:GetCount()~=0 then
							g:Merge(ag) 
						end
					end
					if aux.GetValueType(cg)=="Card" then g:RemoveCard(cg) end
					if aux.GetValueType(cg)=="Group" then g:Sub(cg) end
					return Party_time_RandomSelect(g,0,Party_time_roll(min,max))
				end
			end
			return _SelectReleaseGroupEx(sp,f,min,max,cg,...)
		end
		_GetChainMaterial=Duel.GetChainMaterial
		function Duel.GetChainMaterial(tp)
			local ce=_GetChainMaterial(tp)
			if Duel.GetCurrentChain()==0 then return ce end
			local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
			local ag=Party_time_table[11612632+id]
			if id~=0 and Duel.GetFlagEffect(0,11612632+id)~=0 and ce==nil then
				ce=Effect.CreateEffect(c)
				ce:SetType(EFFECT_TYPE_FIELD)
				ce:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				ce:SetTargetRange(1,0)
				ce:SetTarget(cm.chain_target)
				ce:SetOperation(cm.chain_operation)
				ce:SetValue(aux.TRUE)
			end
			return ce
		end
		_SelectUnselect=Group.SelectUnselect
		function Group.SelectUnselect(cg,sg,tp,finish,cancel,min,max)
			if Duel.GetCurrentChain()~=0 then
				local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
				local ag=Party_time_table[11612632+id]
				if id~=0 and Duel.GetFlagEffect(0,11612632+id)~=0 then
					if finish and Party_time_roll(1,2)==1 then return end
					if not cg or cg:GetCount()<=0 then return end
					local cg2=cg:Clone()
					if aux.GetValueType(ag)=="Group" and Duel.GetFlagEffect(0,7439099)==0 then 
						ag=ag:Filter(cm.rfilter,nil,11612632+id)
						if ag:GetCount()~=0 then
							cg2:Merge(ag) 
						end
					end
					local tc=Party_time_RandomSelect(cg2,0,1):GetFirst()
					if cm.Party_time(tc) and not cg:IsContains(tc) then cg:AddCard(tc) end
					--sg:AddCard(tc)
					return tc
				end
			end
			return _SelectUnselect(cg,sg,tp,finish,cancel,min,max)
		end
		_SelectSubGroup=Group.SelectSubGroup
		function Group.SelectSubGroup(g,tp,f,cancelable,min,max,...)
			if Duel.GetCurrentChain()~=0 then
				local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
				local ag=Party_time_table[11612632+id]
				if id~=0 and Duel.GetFlagEffect(0,11612632+id)~=0 then
					if aux.GetValueType(ag)=="Group" then 
						ag=ag:Filter(cm.rfilter,nil,11612632+id)
						if ag:GetCount()~=0 then
							--
							aux.SubGroupCaptured=Group.CreateGroup()
							local min=min or 1
							local max=max or #g
							local ext_params={...}
							local sg=Group.CreateGroup()
							local fg=Duel.GrabSelectedCard()
							if #fg>max or min>max or #(g+fg)<min then return nil end
							for tc in aux.Next(fg) do
								local tc=fg:SelectUnselect(sg,tp,false,false,min,max)
							end
							sg:Merge(fg)
							g:Merge(ag)
							local finish=(#sg>=min and #sg<=max and f(sg,...))
							while #sg<max do
								local cg=Group.CreateGroup()
								local eg=g:Clone()
								local eg1=g:Clone()
								local eg2=eg:Filter(cm.rfilter,nil,11612632+id)
								local sg1=sg:Clone()
								local sg2=sg:Filter(cm.rfilter,nil,11612632+id)
								if not aux.GCheckAdditional then 
									eg:Sub(eg2)
									eg1:Sub(eg2)
									sg1:Sub(sg2)
									for c in aux.Next(eg-sg1) do
										if not cg:IsContains(c) then
											if aux.CheckGroupRecursiveCapture(c,sg1,eg1,f,min,max,ext_params) then
												cg:Merge(aux.SubGroupCaptured)
											else
												eg1:RemoveCard(c)
											end
										end
									end
									cg:Merge(ag)
								else
									for c in aux.Next(g-sg) do
										if not cg:IsContains(c) then
											if aux.CheckGroupRecursiveCapture(c,sg,eg1,f,min,max,ext_params) then
												cg:Merge(aux.SubGroupCaptured)
											else
												eg1:RemoveCard(c)
											end
										end
									end
								end
								cg:Sub(sg)
								finish=#sg>=min and #sg<=max and (f(sg1,...) or f(sg,...))
								if #cg==0 then break end
								local cancel=not finish and cancelable
								Duel.RegisterFlagEffect(0,7439099,RESET_CHAIN,0,1)
								local tc=cg:SelectUnselect(sg,tp,finish,cancel,min,max)
								Duel.ResetFlagEffect(0,7439099)
								if not tc then finish=true break end
								if not fg:IsContains(tc) then
									if not sg:IsContains(tc) then
										sg:AddCard(tc)
										if #sg==max then finish=true end
									else
										sg:RemoveCard(tc)
									end
								elseif cancelable then
									return nil
								end
							end
							if finish then
								return sg
							else
								local cg=Group.__add(g,ag)
								if (not sg or sg:GetCount()<min) and #cg>0 and not aux.GCheckAdditional then 
									sg=Party_time_RandomSelect(cg,0,Party_time_roll(min,max)) 
									return sg 
								end
								return nil
							end
						end
					end
				end
			end
			return _SelectSubGroup(g,tp,f,cancelable,min,max,...)
		end
		_IsCanBeRitualMaterial=Card.IsCanBeRitualMaterial
		function Card.IsCanBeRitualMaterial(c,sc)
			if Duel.GetCurrentChain()~=0 then
				local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
				if id~=0 and Duel.GetFlagEffect(0,11612632+id)~=0 and aux.GetValueType(sc)=="Card" and sc:GetFlagEffectLabel(11612632)==11612632+id then
					sc:ResetFlagEffect(11612632)
				end
			end
			return _IsCanBeRitualMaterial(c,sc)
		end
		_DiscardHand=Duel.DiscardHand
		function Duel.DiscardHand(tp,f,min,max,reason,cg,...)
			if Duel.GetCurrentChain()~=0 then
				local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
				local ag=Party_time_table[11612632+id]
				if id~=0 and Duel.GetFlagEffect(0,11612632+id)~=0 then
					local g=Duel.GetMatchingGroup(f,tp,LOCATION_HAND,0,cg,...)
					if not g or g:GetCount()<=0 then return false end
					if aux.GetValueType(ag)=="Group" then 
						ag=ag:Filter(cm.rfilter,nil,11612632+id)
						if ag:GetCount()~=0 then
							g:Merge(ag) 
						end
					end
					local sg=Party_time_RandomSelect(g,0,Party_time_roll(min,max))
					return Duel.SendtoGrave(sg,reason+REASON_DISCARD)
				end
			end
			return _DiscardHand(tp,f,min,max,reason,cg,...)
		end
	end
end
--0
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end
function cm.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function cm.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(cm.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
--
--1
function cm.dfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)  and c:IsControler(tp)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return eg:IsExists(cm.dfilter,1,c,tp) and c:IsAttackAbove(2000)-- and not c:IsHasEffect(EFFECT_REVERSE_UPDATE)
	end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(-2000)
		c:RegisterEffect(e1)
		return true
	end
	return false
end
function cm.Value(e,c)
	return cm.dfilter(c,e:GetHandlerPlayer())
end
--2
function cm.chain_target(e,te,tp)
	return Group.CreateGroup()
end
function cm.chain_operation(e,te,tp,tc,mat,sumtype)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,POS_FACEUP)
end
function cm.rfilter(c,id)
	return c:GetFlagEffectLabel(11612632)==id
end
--
function cm.cfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x154)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	local num=Duel.GetFlagEffect(tp,11612634)
	--Debug.Message(g:GetCount())
	local gc=g:GetClassCount(Card.GetCode)
	return num<gc  and e:GetHandler():GetFlagEffect(m)>0 and rp==1-tp
end

function cm.filter(c,ct,loc,cg)
	if aux.GetValueType(cg)=="Group" then
		return (Duel.CheckChainTarget(ct,c) and c:IsLocation(loc)) or cg:IsContains(c)
	end
	return Duel.CheckChainTarget(ct,c) and c:IsLocation(loc)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if re and e~=re and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:GetCount()>=1 then
			local ct=ev
			local label=Duel.GetFlagEffectLabel(0,m)
			if label then
				if ev==bit.rshift(label,16) then ct=bit.band(label,0xffff) end
			end
			local loc_table=0
			local tc=g:GetFirst()
			while tc do
				local loc_tc=tc:GetLocation()
				loc_table=loc_table | loc_tc
				tc=g:GetNext()
			end
			local cg=e:GetLabelObject()
			if chkc then return cm.filter(chkc,ct) end
			if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0xff,0xff,g:GetCount(),nil,ct,loc_table,cg) end
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			local tg=Duel.GetMatchingGroup(cm.filter,tp,0xff,0xff,nil,ct,loc_table,cg)
			local tg2=tg:RandomSelect(tp,g:GetCount())
			Duel.SetTargetCard(tg2)
			local val=ct+bit.lshift(ev+1,16)
			if label then
				Duel.SetFlagEffectLabel(0,m,val)
			else
				Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1,val)
			end
		end
	end
	if chk==0 then return true end
	--e:GetHandler():RegisterFlagEffect(11612634,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,11612634,RESET_PHASE+PHASE_END,0,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if aux.GetValueType(tg)=="Group" then
		local tg2=tg:Filter(Card.IsRelateToEffect,nil,e)
		if tg2 and tg2:GetCount()>0 then
			Duel.ChangeTargetCard(ev,tg2)
		end
	elseif aux.GetValueType(tg)=="Card" then
		if tg:IsRelateToEffect(e) then
			Duel.ChangeTargetCard(ev,Group.FromCards(tg))
		end
	end
	local id=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	Duel.RegisterFlagEffect(0,11612632+id,RESET_CHAIN,0,1)
	if e:GetLabelObject() and e:GetLabelObject():GetCount()>0 then
		Party_time_table[11612632+id]=e:GetLabelObject()
	end
end
--123
--03
function cm.posfilter(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,cm.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
	end
end