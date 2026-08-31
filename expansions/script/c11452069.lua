-- 落渊界枢『三世轮转』
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,2,2,cm.ovfilter,aux.Stringid(m,0))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetCode(EVENT_CUSTOM+11452086)
						--e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_CHAIN)
						e1:SetCondition(cm.descon)
						e1:SetOperation(cm.thop)
						e1:SetReset(RESET_PHASE+PHASE_END)
						Duel.RegisterEffect(e1,tp)
						local ge1=Effect.CreateEffect(c)
						ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						ge1:SetCode(EVENT_CUSTOM+11452085)
						ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) for tc in aux.Next(eg:Filter(cm.filter12,nil)) do cm.leave_exgyrm[tc]=true end end)
						Duel.RegisterEffect(ge1,tp)
						if not cm.filter12(e:GetHandler()) then cm.thop(e,tp,eg,ep,ev,re,r,rp) end
					end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(0xff)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
						e:Reset()
						if cm.ini and cm.ini[tp] then return end
						cm.ini=cm.ini or {}
						cm.ini[tp]=true
						local ge1=Effect.CreateEffect(c)
						ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						ge1:SetCode(EVENT_TO_DECK)
						ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local changed = false
							local turn = Duel.GetTurnCount()
							for tc in aux.Next(eg) do
								if tc:IsLocation(LOCATION_DECK) and (tc:IsPreviousPosition(POS_FACEUP) or tc:IsStatus(STATUS_CHAINING)) then
									local code,code2=tc:GetCode()
									if cm.returned_codes[code] ~= turn then
										cm.returned_codes[code] = turn
										changed = true
									end
									if code2 and cm.returned_codes[code2] ~= turn then
										cm.returned_codes[code2] = turn
										changed = true
									end
								end
							end
							
							-- 【全新客户端提示系统：同名卡回卡组动态追踪】
							if changed then
								local code1, code2, code3 = 11452060, 11452061, 11452062
								local state = 0
								if cm.returned_codes[code1] == turn then state = state | 1 end
								if cm.returned_codes[code2] == turn then state = state | 2 end
								if cm.returned_codes[code3] == turn then state = state | 4 end
								
								if state > 0 then
									-- 此为公开情报（重叠超量素材相关），故向双方玩家派发UI提示
									if cm.client_hint_eff_ret[tp] then
										cm.client_hint_eff_ret[tp]:Reset()
										cm.client_hint_eff_ret[tp] = nil
									end
									local de = Effect.CreateEffect(e:GetHandler())
									-- state (1~7) + 5 = (6~12)，完美映射 6-12 号字符串
									de:SetDescription(aux.Stringid(11452065, 6 + state)) 
									de:SetType(EFFECT_TYPE_FIELD)
									de:SetCode(EFFECT_FLAG_EFFECT)
									de:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
									de:SetTargetRange(1,0)
									de:SetReset(RESET_PHASE+PHASE_END)
									Duel.RegisterEffect(de, tp)
									
									cm.client_hint_eff_ret[tp] = de
								end
							end
						end)
						Duel.RegisterEffect(ge1,tp)
					end)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm.returned_codes={}
		cm.client_hint_eff_ret={}
		cm.leave_exgyrm={}
	end
	if not pnfl_mvfix then
		pnfl_mvfix={}
		pnfl_mvfix_selfdes={}
		--EVENT_MOVE_PNFL = EVENT_CUSTOM+11452085 and not pnfl_mvfix[c]
		--EVENT_MOVE_DELAY_PNFL = EVENT_CUSTOM+11452086
		--GetFlagEffect(11452085) = NOT_TRIGGER_SUMMON_EVENT
		--pnfl_mvdelay[0] = SUMMONING_MONSTERS
		--pnfl_mvdelay[-1] = ACTIVATING_SPELL_TRAP
		local function pnfl_mvfix_selfdes_fun(v)
			if not pnfl_mvdelay then return end
			local g=v
			if aux.GetValueType(v)=="Card" then g=Group.FromCards(v) end
			local te=pnfl_mvdelay[-1]
			local hc=te and te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetHandler()
			local hit_summon=aux.GetValueType(pnfl_mvdelay[0])=="Group" and g:IsExists(function(c) return (pnfl_mvdelay[0]:IsContains(c) or (c:GetOverlayTarget() and pnfl_mvdelay[0]:IsContains(c:GetOverlayTarget()))) and c:GetFlagEffect(11452085)==0 end,1,nil)
			local hit_act=hc and hc:GetFieldID()==hc:GetRealFieldID() and g:IsContains(hc) and hc:GetFlagEffect(11452085)==0
			if hit_summon then
				local tg=pnfl_mvdelay[0]:Filter(function(c) return c:GetFlagEffect(11452085)==0 end,nil)
				if #tg>0 then
					for tc in aux.Next(tg) do
						pnfl_mvfix_selfdes[tc]=true
						tc:RegisterFlagEffect(11452085,RESET_EVENT+RESETS_STANDARD,0,1)
					end
					Duel.RaiseEvent(tg,EVENT_CUSTOM+11452084,nil,0,0,0,0)
				end
				pnfl_mvdelay[0]:DeleteGroup()
				pnfl_mvdelay[0]=nil
			end
			if hit_act then
				pnfl_mvfix_selfdes[hc]=true
				hc:RegisterFlagEffect(11452085,RESET_EVENT+RESETS_STANDARD,0,1)
				Duel.RaiseEvent(Group.FromCards(hc),EVENT_CUSTOM+11452084,nil,0,0,0,0)
				pnfl_mvdelay[-1]=nil
			end
			if hit_summon then
				if pnfl_mvdelay_processing then return end
				pnfl_mvdelay_processing=true
				while pnfl_mvdelay and #pnfl_mvdelay>0 do
					local t=table.remove(pnfl_mvdelay,1)
					Duel.RaiseEvent(table.unpack(t))
					if t[1] and aux.GetValueType(t[1])=="Group" then
						t[1]:DeleteGroup()
					end
				end
				pnfl_mvdelay=nil
				pnfl_mvdelay_processing=nil
			end
		end
		local _MoveToField=Duel.MoveToField
		Duel.MoveToField=function(c,...)
			if aux.GetValueType(c)~="Card" then return _MoveToField(c,...) end
			pnfl_mvfix_selfdes_fun(c)
			local res=_MoveToField(c,...)
			return res
		end
		local _MoveSequence=Duel.MoveSequence
		Duel.MoveSequence=function(c,seq,...)
			if aux.GetValueType(c)~="Card" then return _MoveSequence(c,seq,...) end
			local of=c:IsOnField()
			if of and (seq==c:GetSequence() or not Duel.CheckLocation(c:GetControler(),c:GetLocation(),seq)) then return end
			pnfl_mvfix_selfdes_fun(c)
			if not of then pnfl_mvfix[c]={c:GetControler(),c:GetLocation(),c:GetSequence(),"MoveSequence"} end
			local res=_MoveSequence(c,seq,...)
			if not of then pnfl_mvfix[c]=nil end
			return res
		end
		local _Overlay=Duel.Overlay
		Duel.Overlay=function(xc,v,...)
			local g=v
			if aux.GetValueType(v)=="Card" then g=Group.FromCards(v) end
			pnfl_mvfix_selfdes_fun(g)
			for tc in aux.Next(g) do pnfl_mvfix[tc]={tc:GetControler(),tc:GetLocation(),tc:GetSequence(),"Overlay"} end
			local res=_Overlay(xc,v,...)
			local ng=g:Filter(function(c) return not c:IsLocation(pnfl_mvfix[c][2]) or not c:IsControler(pnfl_mvfix[c][1]) or pnfl_mvfix[c][3]~=c:GetSequence() end,nil)
			for tc in aux.Next(g) do pnfl_mvfix[tc]=nil end
			if #ng>0 then Duel.RaiseEvent(ng,EVENT_CUSTOM+11452084,nil,0,0,0,0) end
			return res
		end
		local _GetControl=Duel.GetControl
		Duel.GetControl=function(v,p,...)
			local g=v
			if aux.GetValueType(v)=="Card" then g=Group.FromCards(v) end
			pnfl_mvfix_selfdes_fun(g)
			for tc in aux.Next(g) do pnfl_mvfix[tc]={tc:GetControler(),tc:GetLocation(),tc:GetSequence(),"GetControl"} end
			local res=_GetControl(v,p,...)
			local ng=g:Filter(function(c) return not c:IsLocation(pnfl_mvfix[c][2]) or not c:IsControler(pnfl_mvfix[c][1]) or pnfl_mvfix[c][3]~=c:GetSequence() end,nil)
			for tc in aux.Next(g) do pnfl_mvfix[tc]=nil end
			if #ng>0 then Duel.RaiseEvent(ng,EVENT_CUSTOM+11452084,nil,0,0,0,0) end
			return res
		end
		local _Equip=Duel.Equip
		Duel.Equip=function(p,c,ec,up,step,...)
			pnfl_mvfix_selfdes_fun(c)
			pnfl_mvfix[c]={c:GetControler(),c:GetLocation(),c:GetSequence(),not step and "Equip" or "EquipStep"}
			local res=_Equip(p,c,ec,up,step,...)
			if not step and (not res or c:IsHasEffect(EFFECT_EQUIP_LIMIT)) then
				if not c:IsLocation(pnfl_mvfix[c][2]) or not c:IsControler(pnfl_mvfix[c][1]) or pnfl_mvfix[c][3]~=c:GetSequence() then Duel.RaiseEvent(Group.FromCards(c),EVENT_CUSTOM+11452084,nil,0,0,0,0) end
				pnfl_mvfix[c]=nil
			end
			return res
		end
		local _CRegisterEffect=Card.RegisterEffect
		function Card.RegisterEffect(c,e,...)
			local res=_CRegisterEffect(c,e,...)
			if e:GetCode()==EFFECT_EQUIP_LIMIT and pnfl_mvfix[c] then
				if pnfl_mvfix[c][4]~="EquipStep" and (not c:IsLocation(pnfl_mvfix[c][2]) or not c:IsControler(pnfl_mvfix[c][1]) or pnfl_mvfix[c][3]~=c:GetSequence()) then Duel.RaiseEvent(Group.FromCards(c),EVENT_CUSTOM+11452084,nil,0,0,0,0) end
				pnfl_mvfix[c]=nil
			end
			return res
		end
		local _EquipComplete=Duel.EquipComplete
		function Duel.EquipComplete(...)
			local res=_EquipComplete(...)
			local g=Duel.GetMatchingGroup(function(c) return pnfl_mvfix[c] and pnfl_mvfix[c][4]=="EquipStep" end,0,0xff,0xff,nil)
			local ng=g:Filter(function(c) return not c:IsLocation(pnfl_mvfix[c][2]) or not c:IsControler(pnfl_mvfix[c][1]) or pnfl_mvfix[c][3]~=c:GetSequence() end,nil)
			for tc in aux.Next(g) do pnfl_mvfix[tc]=nil end
			if #ng>0 then Duel.RaiseEvent(ng,EVENT_CUSTOM+11452084,nil,0,0,0,0) end
			return res
		end
		local _SpecialSummonStep=Duel.SpecialSummonStep
		Duel.SpecialSummonStep=function(c,...)
			pnfl_mvfix[c]={c:GetControler(),c:GetLocation(),c:GetSequence(),"SpecialSummonStep"}
			local res=_SpecialSummonStep(c,...)
			if not res then
				if not c:IsLocation(pnfl_mvfix[c][2]) or not c:IsControler(pnfl_mvfix[c][1]) or pnfl_mvfix[c][3]~=c:GetSequence() then Duel.RaiseEvent(Group.FromCards(c),EVENT_CUSTOM+11452084,nil,0,0,0,0) end
				pnfl_mvfix[c]=nil
			end
			return res
		end
		local _SpecialSummonComplete=Duel.SpecialSummonComplete
		function Duel.SpecialSummonComplete(...)
			local res=_SpecialSummonComplete(...)
			local g=Duel.GetMatchingGroup(function(c) return pnfl_mvfix[c] and pnfl_mvfix[c][4]=="SpecialSummonStep" end,0,0xff,0xff,nil)
			local ng=g:Filter(function(c) return not c:IsLocation(pnfl_mvfix[c][2]) or not c:IsControler(pnfl_mvfix[c][1]) or pnfl_mvfix[c][3]~=c:GetSequence() end,nil)
			for tc in aux.Next(g) do pnfl_mvfix[tc]=nil end
			if #ng>0 then Duel.RaiseEvent(ng,EVENT_CUSTOM+11452084,nil,0,0,0,0) end
			return res
		end
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetCondition(function(e) return e:GetLabel()==0 and Duel.GetTurnCount()>0 end)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							--Debug.Message("summon")
							local e_clone=e:Clone()
							e:SetLabel(-1)
							e:Reset()
							Duel.RegisterEffect(e_clone,0)
							local g=eg:Filter(function(c) return c:GetFlagEffect(11452085)==0 and not pnfl_mvfix_selfdes[c] and (not pnfl_mvfix[c] or pnfl_mvfix[c][4]~="SpecialSummonStep") end,nil)
							for ec in aux.Next(eg) do pnfl_mvfix_selfdes[ec]=nil end
							if #g>0 then Duel.RaiseEvent(eg,EVENT_CUSTOM+11452084,re,r,rp,ep,ev) end
							if pnfl_mvdelay and not pnfl_mvdelay[-1] and aux.GetValueType(pnfl_mvdelay[0])=="Group" and not pnfl_mvdelay[0]:IsExists(function(c) return not eg:IsContains(c) end,1,nil) then
								pnfl_mvdelay[0]:DeleteGroup()
								pnfl_mvdelay[0]=nil
								if pnfl_mvdelay_processing then return end
								pnfl_mvdelay_processing=true
								while pnfl_mvdelay and #pnfl_mvdelay>0 do
									local t=table.remove(pnfl_mvdelay,1)
									Duel.RaiseEvent(table.unpack(t))
									if t[1] and aux.GetValueType(t[1])=="Group" then
										t[1]:DeleteGroup()
									end
								end
								pnfl_mvdelay=nil
								pnfl_mvdelay_processing=nil
							elseif pnfl_mvdelay and aux.GetValueType(pnfl_mvdelay[0])=="Group" then
								pnfl_mvdelay[0]:Sub(eg)
							end
						end)
		Duel.RegisterEffect(ge1,0)
		local ge11=ge1:Clone()
		ge11:SetCode(EVENT_SUMMON_NEGATED)
		Duel.RegisterEffect(ge11,0)
		local ge12=ge1:Clone()
		ge12:SetCode(EVENT_MSET)
		Duel.RegisterEffect(ge12,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge21=ge2:Clone()
		ge21:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(ge21,0)
		local ge22=ge2:Clone()
		ge22:SetCode(EVENT_LEAVE_FIELD_P)
		ge22:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							--Debug.Message("selfdes")
							local e_clone=e:Clone()
							e:SetLabel(-1)
							e:Reset()
							Duel.RegisterEffect(e_clone,0)
							pnfl_mvfix_selfdes_fun(eg)
						end)
		Duel.RegisterEffect(ge22,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAINING) --cost A sp B activate C selfdes D cost E success B -> A D E C B
		ge3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							--Debug.Message("chaining")
							if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFieldID()==re:GetHandler():GetRealFieldID() and re:GetHandler():GetFlagEffect(11452085)==0 and not pnfl_mvfix_selfdes[re:GetHandler()] then
								Duel.RaiseEvent(eg,EVENT_CUSTOM+11452084,re,r,rp,ep,ev)
							end
							pnfl_mvfix_selfdes[re:GetHandler()]=nil
							if pnfl_mvdelay then
								pnfl_mvdelay[-1]=nil
								if aux.GetValueType(pnfl_mvdelay[0])=="Group" then
									local g=pnfl_mvdelay[0]:Filter(function(c) return c:GetFlagEffect(11452085)==0 end,nil)
									if #g>0 then
										for tc in aux.Next(g) do tc:RegisterFlagEffect(11452085,RESET_EVENT+RESETS_STANDARD,0,1) end
										Duel.RaiseEvent(g,EVENT_CUSTOM+11452084,re,r,rp,ep,ev)
									end
									pnfl_mvdelay[0]:DeleteGroup()
									pnfl_mvdelay[0]=nil
								end
								if pnfl_mvdelay_processing then return end
								pnfl_mvdelay_processing=true
								while pnfl_mvdelay and #pnfl_mvdelay>0 do
									local t=table.remove(pnfl_mvdelay,1)
									Duel.RaiseEvent(table.unpack(t))
									if t[1] and aux.GetValueType(t[1])=="Group" then
										t[1]:DeleteGroup()
									end
								end
								pnfl_mvdelay=nil
								pnfl_mvdelay_processing=nil
							end
						end)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_MOVE)
		ge4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							--Debug.Message("move")
							local e_clone=e:Clone()
							e:SetLabel(-1)
							e:Reset()
							Duel.RegisterEffect(e_clone,0)
							local b1,g1=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
							local b2,g2=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
							local g=eg:Filter(function(c)
												--movesequence,summonproc/step,activate,equip,overlay,getcontrol,cost,selfdes
												if pnfl_mvfix[c] or (not c:IsStatus(STATUS_EFFECT_ENABLED) and (c:IsLocation(LOCATION_MZONE) or (c:IsOnField() and c:IsFaceup()))) then return false end
												return (not b1 or not g1:IsContains(c)) and (not b2 or not g2:IsContains(c)) end,nil)
							if #g>0 then Duel.RaiseEvent(g,EVENT_CUSTOM+11452084,re,r,rp,ep,ev) end
						end)
		Duel.RegisterEffect(ge4,0)
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD)
		ge5:SetCode(EFFECT_CANNOT_SUMMON)
		ge5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge5:SetTargetRange(1,1)
		ge5:SetTarget(function(e,c,tp,st)
						if bit.band(st,SUMMON_TYPE_DUAL)==SUMMON_TYPE_DUAL and c:GetFlagEffect(11452085)==0 then c:RegisterFlagEffect(11452085,RESET_EVENT+RESETS_STANDARD,0,1) end
						return false
					end)
		Duel.RegisterEffect(ge5,0)
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD)
		ge6:SetCode(EFFECT_ACTIVATE_COST)
		ge6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge6:SetTargetRange(1,1)
		ge6:SetTarget(function(e,te) e:SetLabelObject(te) return true end)
		ge6:SetOperation(function(e) pnfl_mvdelay=pnfl_mvdelay or {[-1]=e:GetLabelObject()} end)
		Duel.RegisterEffect(ge6,0)
		local ge7=ge6:Clone()
		ge7:SetCode(EFFECT_SUMMON_COST)
		ge7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE)
		ge7:SetTargetRange(0xff,0xff)
		ge7:SetTarget(function(e,tc) e:SetLabelObject(tc) return true end)
		ge7:SetOperation(function(e)
							local tc=e:GetLabelObject()
							pnfl_mvdelay=pnfl_mvdelay or {}
							if not pnfl_mvdelay[0] then
								pnfl_mvdelay[0]=Group.FromCards(tc)
								pnfl_mvdelay[0]:KeepAlive()
							elseif aux.GetValueType(pnfl_mvdelay[0])=="Group" then
								pnfl_mvdelay[0]:AddCard(tc)
							end
						end)
		Duel.RegisterEffect(ge7,0)
		local ge8=ge7:Clone()
		ge8:SetCode(EFFECT_SPSUMMON_COST)
		Duel.RegisterEffect(ge8,0)
		local ge81=ge7:Clone()
		ge81:SetCode(EFFECT_MSET_COST)
		Duel.RegisterEffect(ge81,0)
		local ge9=ge1:Clone()
		ge9:SetCode(EVENT_CUSTOM+11452084)
		ge9:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							--Debug.Message("event trigger")
							local e_clone=e:Clone()
							e:SetLabel(-1)
							e:Reset()
							Duel.RegisterEffect(e_clone,0)
							Duel.RaiseEvent(eg,EVENT_CUSTOM+11452085,re,r,rp,ep,ev)
							local ec=eg:GetFirst()
							if pnfl_mvdelay then
								local g=eg:Clone()
								g:KeepAlive()
								table.insert(pnfl_mvdelay,{g,EVENT_CUSTOM+11452086,re,r,rp,ep,ev})
							else
								Duel.RaiseEvent(eg,EVENT_CUSTOM+11452086,re,r,rp,ep,ev)
							end
						end)
		Duel.RegisterEffect(ge9,0)
	end
end
function cm.filter12(c)
	return c:IsPreviousLocation(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(tc) return cm.leave_exgyrm[tc] end,1,nil)
end
function cm.ovfilter(mc,xyzc,tp)
	local turn=Duel.GetTurnCount()
	local code,code2=mc:GetCode()
	return mc:IsFaceup() and (cm.returned_codes[code]==turn or (code2 and cm.returned_codes[code2]==turn))
end
function cm.thfilter(c,tp)
	local turn=Duel.GetTurnCount()
	local is_added = cm.added_codes and cm.added_codes[tp] and cm.added_codes[tp][c:GetCode()]==turn
	return c:IsSetCard(0x5978) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not is_added
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	cm.leave_exgyrm={}
	if Duel.GetFlagEffect(tp,m)>0 or not Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) or not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	if GRAVILOID_COUNTER then
		local te=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_EFFECT)
		if te and te:GetHandler() then te:GetHandler():SetTurnCounter(GRAVILOID_COUNTER+1) end
		GRAVILOID_COUNTER=nil
	end
	if Duel.GetCurrentChain()>0 then Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1) end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc then
		local op=aux.SelectFromOptions(tp,{true,aux.Stringid(m,2)},{tc:IsAbleToRemove(),aux.Stringid(m,3)})
		local res=0
		if op==1 then
			res=Duel.Destroy(tc,REASON_EFFECT)>0
		else
			res=Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_REMOVED)
		end
		if res then
			local thg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=thg:CancelableSelect(tp,1,1,nil)
			if sg and #sg>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				local hc=sg:GetFirst()
				local turn=Duel.GetTurnCount()
				cm.added_codes=cm.added_codes or {}
				cm.added_codes[tp]=cm.added_codes[tp] or {}
				cm.added_codes[tp][hc:GetCode()]=turn
				
				-- =========================================================
				-- 【全新客户端提示系统：动态覆盖与状态穷举】
				-- =========================================================
				cm.client_hint_eff = cm.client_hint_eff or {}
				
				-- 1. 清除旧的提示（如果存在）
				if cm.client_hint_eff[tp] then
					cm.client_hint_eff[tp]:Reset()
					cm.client_hint_eff[tp] = nil
				end
				
				-- 2. 计算当前的组合状态
				local code1, code2, code3 = 11452060,11452061,11452062
				local state = 0
				if cm.added_codes[tp][code1] == turn then state = state | 1 end
				if cm.added_codes[tp][code2] == turn then state = state | 2 end
				if cm.added_codes[tp][code3] == turn then state = state | 4 end
				
				-- 3. 注册覆盖的全新提示
				if state > 0 then
					local de=Effect.CreateEffect(e:GetHandler())
					de:SetDescription(aux.Stringid(m, 3 + state)) 
					de:SetType(EFFECT_TYPE_FIELD)
					de:SetCode(EFFECT_FLAG_EFFECT)
					de:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
					de:SetTargetRange(1,0)
					de:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(de,tp)
					
					-- 保存引用供下次检索时 Reset
					cm.client_hint_eff[tp] = de
				end
				-- =========================================================
			end
		end
	end
end