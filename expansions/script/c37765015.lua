--苍穹魔女 诺娅
function c37765015.initial_effect(c)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37765015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,37765015)
	e1:SetCondition(c37765015.spcon)
	e1:SetTarget(c37765015.sptg)
	e1:SetOperation(c37765015.spop)
	c:RegisterEffect(e1)
	--run
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c37765015.rmop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,37765015+1)
	--e3:SetCondition(Duel.IsMainPhase)
	e3:SetTarget(c37765015.eqtg)
	e3:SetOperation(c37765015.eqop)
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
function c37765015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_MZONE)
end
function c37765015.desfilter(c)
	return c:IsSetCard(0x2a4) and c:IsFaceupEx()
end
function c37765015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local f=Duel.GetTurnPlayer()==tp and aux.TRUE or c37765015.desfilter
	local g=Duel.GetMatchingGroup(f,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c37765015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local f=Duel.GetTurnPlayer()==tp and aux.TRUE or c37765015.desfilter
	local g=Duel.GetMatchingGroup(f,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if #g==0 then return end
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=g:Select(tp,1,1,nil)
	end
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
end
function c37765015.cfilter(c)
	return c:IsSetCard(0x2a4) and c:IsType(TYPE_QUICKPLAY) and c:IsFaceup()
end
function c37765015.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c37765015.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or not c:IsAbleToRemove() then return end
	Duel.Hint(HINT_CARD,0,37765015)
	Duel.HintSelection(Group.FromCards(c))
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetLabelObject(c)
	e1:SetOperation(c37765015.retop)
	Duel.RegisterEffect(e1,tp)
end
function c37765015.retop(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x2a4)) then return end
	Duel.Hint(HINT_CARD,0,37765015)
	Duel.ReturnToField(e:GetLabelObject())
	e:Reset()
end
function c37765015.eqfilter(c,tp)
	return c:IsSetCard(0x2a4) and not c:IsForbidden() and c:CheckUniqueOnField(tp)-- and Duel.IsPlayerCanSSet(tp,c)
end
function c37765015.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37765015.eqfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetSZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c37765015.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToChain() or Duel.GetSZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c37765015.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c37765015.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		--atk up
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetValue(1100)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		--to hand
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(37765015,2))
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_LEAVE_FIELD)
		e0:SetRange(0xff)
		e0:SetOperation(c37765015.thop)
		--tc:RegisterEffect(e0)
		-- 双轨监听：那张卡被送去墓地时回手
		-- 轨 1：即时轨（85），捕获 tc 离场的瞬时状态与去向
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CUSTOM+11452085)
		ge1:SetLabelObject(tc)

		-- 轨 2：延迟轨（86），在安全时点执行回手操作
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(37765015,2))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CUSTOM+11452086)
		e1:SetLabelObject(ge1)
		e1:SetCondition(c37765015.thcon)
		e1:SetOperation(c37765015.thop)

		-- ge1 监听瞬时去向：去墓地则标记，去别处则自毁
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			if not eg:IsContains(tc) then return end
			-- 已经确认从场上送墓后，不再因后续位移（如墓地->除外）而注销
			if e:GetLabel()==1 then return end
			if tc:IsLocation(LOCATION_GRAVE) and tc:IsPreviousLocation(LOCATION_ONFIELD) then
				ge1:SetLabel(1) -- 锁定事实：确实是从场上送去了墓地
			elseif not tc:IsLocation(LOCATION_ONFIELD) then
				-- tc 离场去了除外/手卡/卡组等，条件永久作废，清理双轨
				ge1:Reset()
				e1:Reset()
			end
		end)

		Duel.RegisterEffect(ge1,tp)
		Duel.RegisterEffect(e1,tp)
	end
end
function c37765015.eqlimit(e,c)
	return e:GetOwner()==c
end
--[[function c37765015.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_CARD,0,37765015)
		local tg=Group.FromCards(c)
		Duel.HintSelection(tg)
		--
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #g>0 then
			local tc=g:GetFirst()
			if #g>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				tc=g:Select(tp,1,1,nil):GetFirst()
			end
			Duel.HintSelection(Group.FromCards(tc))
			tg:AddCard(tc)
		end
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
	e:Reset()
end--]]
function c37765015.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ge1=e:GetLabelObject()
	local tc=ge1:GetLabelObject()
	-- 必须满足：即时轨已确认送墓事实，且本次释放的移动批次包含该卡
	return e:GetLabel()~=114 and ge1:GetLabel()==1 and eg:IsContains(tc)
end

function c37765015.thop(e,tp,eg,ep,ev,re,r,rp)
	local ge1=e:GetLabelObject()
	local tc=ge1:GetLabelObject()
	local tg=Group.CreateGroup()

	-- 目标 A（那张装备卡）：如果在墓地且能回手，加入回手组
	if tc:IsLocation(LOCATION_GRAVE) and tc:IsAbleToHand() then
		tg:AddCard(tc)
	end

	-- 目标 B（场上的1张卡）：只要场上有能回手的卡，选1张加入回手组
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		tg:Merge(sg)
	end

	-- 无论最终是否回手成功，86 时点到达即代表该事件已消费完毕，注销双轨
	e:SetLabel(114)
	local ge1=e:GetLabelObject()
	if aux.GetValueType(ge1)=="Effect" then
		ge1:Reset()
	end
	e:Reset()

	-- 只要任一目标有效（无论是双回、只回墓地那张、还是只回场上的卡）均执行
	if #tg>0 then
		Duel.Hint(HINT_CARD,0,37765015)
		if tg:IsContains(tc) then
			Duel.HintSelection(Group.FromCards(tc))
		end
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end