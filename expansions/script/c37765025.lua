--苍穹魔女武备注能
function c37765025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetTarget(c37765025.target)
	e1:SetOperation(c37765025.activate)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetOperation(c37765025.regop)
	c:RegisterEffect(e3)
	if not pnfl_mvfix then
		pnfl_mvfix={}
		pnfl_mvfix_selfdes={}
		--EVENT_MOVE_PNFL = EVENT_CUSTOM+11452085
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
function c37765025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,37765025)==0 end
end
function c37765025.colfilter(c,tp)
	return c:IsSetCard(0x2a4) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsFaceup()
end
function c37765025.disfilter(c,tp)
	return aux.NegateAnyFilter(c) and c:GetColumnGroup():IsExists(c37765025.colfilter,1,nil,tp)
end
function c37765025.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,37765025,RESET_PHASE+PHASE_END,0,1)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PSYCHO))
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetValue(1500)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local g=Duel.GetMatchingGroup(c37765025.disfilter,tp,0,LOCATION_ONFIELD,nil,tp)
	if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(37765025,0)) then return end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c37765025.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sf=Duel.SelectField(tp,1,LOCATION_SZONE,0,~0x1f00)
	for i=0,4 do
		if sf==(1<<(8+i)) then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetDescription(aux.Stringid(37765025,i+1))
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_FLAG_EFFECT+37765025)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e0:SetTargetRange(1,0)
			e0:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e0,tp)
			local cm,m=c37765025,37765025
			-- 轨 1：即时轨（捕获落入指定纵列的卡并打上持久标记）
			local ge1=Effect.CreateEffect(e:GetHandler())
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_CUSTOM+11452085)
			local g1=Group.CreateGroup()
			g1:KeepAlive()
			ge1:SetLabelObject(g1)
			ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				for tc in aux.Next(eg:Filter(cm.seqfilter,nil,tp,i)) do
					-- 1. 记入事实账本（卡片即使随后离场，此记录依然有效）
					g1:AddCard(tc)
					-- 2. 注册在场追踪标记（离场即自动被底层抹除）
					tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
				end
			end)
			ge1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(ge1,tp)
			-- 轨 2：延迟轨（等待动作安全落定后触发询问与回收）
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CUSTOM+11452086)
			e1:SetCondition(cm.thcon)
			e1:SetOperation(cm.thop)
			e1:SetLabel(i)
			e1:SetLabelObject(ge1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			break
		end
	end
end
function c37765025.seqfilter(c,tp,seq)
	if not c:IsLocation(LOCATION_ONFIELD) then return false end
	local pseq,p=c:GetSequence(),c:GetControler()
	local c_col=-1
	if c:IsLocation(LOCATION_MZONE) then
		if p==tp then
			if pseq==5 then c_col=1
			elseif pseq==6 then c_col=3
			elseif pseq<5 then c_col=pseq end
		else
			if pseq==5 then c_col=3
			elseif pseq==6 then c_col=1
			elseif pseq<5 then c_col=4-pseq end
		end
	elseif c:IsLocation(LOCATION_SZONE) and pseq<=4 then
		c_col = (p==tp) and pseq or (4-pseq)
	end
	return c_col==seq
end
function c37765025.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()~=114 and eg:IsExists(function(c) return e:GetLabelObject():GetLabelObject():IsContains(c) end,1,nil)
end
function c37765025.thfilter(c)
	return c:IsCode(37765025) and c:IsAbleToHand() and aux.NecroValleyFilter()(c)
end
function c37765025.thop(e,tp,eg,ep,ev,re,r,rp)
	local cm,m=c37765025,37765025
	local tg=eg:Filter(function(c) return c:GetFlagEffect(m)>0 and c:IsAbleToHand() end,nil)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,0,nil)
	if (#tg==0 and #g==0) or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		for tc in aux.Next(eg) do
			tc:ResetFlagEffect(m)
			local ge1=e:GetLabelObject()
			if aux.GetValueType(ge1)=="Effect" then
				local g1=ge1:GetLabelObject()
				if aux.GetValueType(g1)=="Group" then g1:RemoveCard(tc) end
			end
		end
		return
	end
	-- 确认适用后注销双轨监听
	e:SetLabel(114)
	local ge1=e:GetLabelObject()
	if aux.GetValueType(ge1)=="Effect" then
		local g1=ge1:GetLabelObject()
		--if aux.GetValueType(g1)=="Group" then g1:DeleteGroup() end
		ge1:Reset()
	end
	e:Reset()
	Duel.Hint(HINT_CARD,0,m)
	for tc in aux.Next(eg) do tc:ResetFlagEffect(m) end
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		tg:Merge(sg)
	end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
