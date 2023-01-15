--尤格萨隆潘趣酒
local m=7439105
local cm=_G["c"..m]

cm.named_with_party_time=1

function cm.Party_time(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_party_time
end

function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2)
	--salvage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(cm.salcost)
	e5:SetTarget(cm.saltg)
	e5:SetOperation(cm.salop)
	c:RegisterEffect(e5)
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
				if id~=0 and Duel.GetFlagEffect(0,7439100+id)~=0 then
					if not tp and aux.GetValueType(tg)=="Card" and tg:GetFlagEffectLabel(m)==7439100+id and tg:IsLocation(LOCATION_DECK) then 
						return _SendtoDeck(tg,1-tg:GetControler(),seq,reason)  
					end
					if not tp and aux.GetValueType(tg)=="Group" then 
						local sg=tg:Filter(cm.rfilter,nil,7439100+id):Filter(Card.IsLocation,nil,LOCATION_DECK)
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
				if id~=0 and Duel.GetFlagEffect(0,7439100+id)~=0 then
					if not tp and aux.GetValueType(tg)=="Card" and tg:GetFlagEffectLabel(m)==7439100+id and tg:IsLocation(LOCATION_HAND) then 
						return _SendtoHand(tg,1-tg:GetControler(),reason) 
					end
					if not tp and aux.GetValueType(tg)=="Group" then 
						local sg=tg:Filter(cm.rfilter,nil,7439100+id):Filter(Card.IsLocation,nil,LOCATION_HAND)
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
				local ag=Party_time_table[7439100+id]
				if id~=0 and Duel.GetFlagEffect(0,7439100+id)~=0 then
					local sg=g:Clone()
					if aux.GetValueType(ag)=="Group" then 
						ag=ag:Filter(cm.rfilter,nil,7439100+id)
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
				local ag=Party_time_table[7439100+id]
				if id~=0 and Duel.GetFlagEffect(0,7439100+id)~=0 then
					local g=Duel.GetMatchingGroup(f,tp,s,o,cg,...)
					if aux.GetValueType(ag)=="Group" then 
						ag=ag:Filter(cm.rfilter,nil,7439100+id)
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
				local ag=Party_time_table[7439100+id]
				if id~=0 and Duel.GetFlagEffect(0,7439100+id)~=0 then
					local g=Duel.GetReleaseGroup(sp)
					local g=g:Filter(f,cg,...)
					if aux.GetValueType(ag)=="Group" then 
						ag=ag:Filter(cm.rfilter,nil,7439100+id)
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
				local ag=Party_time_table[7439100+id]
				if id~=0 and Duel.GetFlagEffect(0,7439100+id)~=0 then
					local g=Duel.GetReleaseGroup(sp)
					local g=g:Filter(f,cg,...)
					if aux.GetValueType(ag)=="Group" then 
						ag=ag:Filter(cm.rfilter,nil,7439100+id)
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
			local ag=Party_time_table[7439100+id]
			if id~=0 and Duel.GetFlagEffect(0,7439100+id)~=0 and ce==nil then
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
				local ag=Party_time_table[7439100+id]
				if id~=0 and Duel.GetFlagEffect(0,7439100+id)~=0 then
					if finish and Party_time_roll(1,2)==1 then return end
					if not cg or cg:GetCount()<=0 then return end
					local cg2=cg:Clone()
					if aux.GetValueType(ag)=="Group" and Duel.GetFlagEffect(0,7439099)==0 then 
						ag=ag:Filter(cm.rfilter,nil,7439100+id)
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
				local ag=Party_time_table[7439100+id]
				if id~=0 and Duel.GetFlagEffect(0,7439100+id)~=0 then
					if aux.GetValueType(ag)=="Group" then 
						ag=ag:Filter(cm.rfilter,nil,7439100+id)
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
								local eg2=eg:Filter(cm.rfilter,nil,7439100+id)
								local sg1=sg:Clone()
								local sg2=sg:Filter(cm.rfilter,nil,7439100+id)
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
				if id~=0 and Duel.GetFlagEffect(0,7439100+id)~=0 and aux.GetValueType(sc)=="Card" and sc:GetFlagEffectLabel(7439100)==7439100+id then
					sc:ResetFlagEffect(7439100)
				end
			end
			return _IsCanBeRitualMaterial(c,sc)
		end
		_DiscardHand=Duel.DiscardHand
		function Duel.DiscardHand(tp,f,min,max,reason,cg,...)
			if Duel.GetCurrentChain()~=0 then
				local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
				local ag=Party_time_table[7439100+id]
				if id~=0 and Duel.GetFlagEffect(0,7439100+id)~=0 then
					local g=Duel.GetMatchingGroup(f,tp,LOCATION_HAND,0,cg,...)
					if not g or g:GetCount()<=0 then return false end
					if aux.GetValueType(ag)=="Group" then 
						ag=ag:Filter(cm.rfilter,nil,7439100+id)
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
function cm.chain_target(e,te,tp)
	return Group.CreateGroup()
end
function cm.chain_operation(e,te,tp,tc,mat,sumtype)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,POS_FACEUP)
end
function cm.rfilter(c,id)
	return c:GetFlagEffectLabel(7439100)==id
end
function cm.actcon(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.cfilter(c)
	return cm.Party_time(c) and c:IsType(TYPE_MONSTER) and ((c:IsLocation(LOCATION_HAND+LOCATION_DECK) and not c:IsPublic()) or c:IsLocation(LOCATION_GRAVE))
end
function cm.gcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
		and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		local cg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,nil)
		if cg:GetCount()<=0 then return false end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=cg:SelectSubGroup(tp,cm.gcheck,false,1,3)
		Duel.HintSelection(sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE))
		Duel.ConfirmCards(1-tp,sg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK))
		local tc=sg:GetFirst()
		while tc do
			local id=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
			tc:RegisterFlagEffect(7439100,RESET_CHAIN+RESET_EVENT+RESETS_STANDARD,0,1,7439100+id)
			tc=sg:GetNext()
		end
		sg:KeepAlive()
		e:SetLabelObject(sg)
	end
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
	Duel.RegisterFlagEffect(0,7439100+id,RESET_CHAIN,0,1)
	if e:GetLabelObject() and e:GetLabelObject():GetCount()>0 then
		Party_time_table[7439100+id]=e:GetLabelObject()
	end
end

function cm.salcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.thfilter(c)
	return cm.Party_time(c) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function cm.saltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.salop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
