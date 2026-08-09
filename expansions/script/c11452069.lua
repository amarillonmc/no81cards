--落渊界枢『三世轮转』
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
						e1:SetCode(EVENT_CUSTOM+m)
						--e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_CHAIN)
						e1:SetOperation(cm.thop)
						e1:SetReset(RESET_PHASE+PHASE_END)
						Duel.RegisterEffect(e1,tp)
						if not e:GetHandler():IsPreviousLocation(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED) then
							Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,re,r,rp,ep,ev)
						end
					end)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local _Overlay=Duel.Overlay
		function Duel.Overlay(xc,v,...)
			local t=Auxiliary.GetValueType(v)
			local g=Group.CreateGroup()
			if t=="Card" then g:AddCard(v) else g=v end
			local res=_Overlay(xc,v,...)
			if g:IsExists(function(c) return c:IsPreviousLocation(LOCATION_REMOVED) end,1,nil) then
				Duel.RaiseEvent(g,EVENT_CUSTOM+m,e1,0,0,0,0)
			end
			return res
		end
		local _Equip=Duel.Equip
		Duel.Equip=function(p,c,...)
			local nf=not c:IsOnField()
			if nf and not c:IsHasEffect(EFFECT_EQUIP_LIMIT) then c:RegisterFlagEffect(m-4,RESET_CHAIN,0,1) end
			local res=_Equip(p,c,...)
			if nf and c:IsHasEffect(EFFECT_EQUIP_LIMIT) then
				if c:IsPreviousLocation(LOCATION_GRAVE) or c:IsPreviousLocation(LOCATION_EXTRA) or c:IsPreviousLocation(LOCATION_REMOVED) then
					Duel.RaiseEvent(Group.FromCards(c),EVENT_CUSTOM+m,e,0,0,0,0)
				end
			end
			return res
		end
		local _CRegisterEffect=Card.RegisterEffect
		function Card.RegisterEffect(c,e,...)
			local res=_CRegisterEffect(c,e,...)
			if e:GetCode()==EFFECT_EQUIP_LIMIT and c:GetFlagEffect(m-4)>0 then
				c:ResetFlagEffect(m-4)
				if c:IsPreviousLocation(LOCATION_GRAVE) or c:IsPreviousLocation(LOCATION_EXTRA) or c:IsPreviousLocation(LOCATION_REMOVED) then
					Duel.RaiseEvent(Group.FromCards(c),EVENT_CUSTOM+m,e,0,0,0,0)
				end
			end
			return res
		end
		cm.returned_codes={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_DECK)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			for tc in aux.Next(eg) do
				if tc:IsLocation(LOCATION_DECK) and (tc:IsPreviousPosition(POS_FACEUP) or tc:IsStatus(STATUS_CHAINING)) then
					local turn=Duel.GetTurnCount()
					local code,code2=tc:GetCode()
					cm.returned_codes[code]=turn
					if code2 then cm.returned_codes[code2]=turn end
				end
			end
		end)
		Duel.RegisterEffect(ge1,0)
		local e_leave=Effect.CreateEffect(c)
		e_leave:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e_leave:SetCode(EVENT_LEAVE_DECK)
		e_leave:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
								local g=eg:Filter(function(c) return c:IsPreviousLocation(LOCATION_EXTRA) and not c:IsOnField() end,nil)
								if #g>0 then --and c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0x5978)
									cm.process(g,e,tp,eg,ep,ev,re,r,rp)
								end
							end)
		Duel.RegisterEffect(e_leave,0)
		local e_l2=e_leave:Clone()
		e_l2:SetCode(EVENT_LEAVE_GRAVE)
		e_l2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
								local g=eg:Filter(function(c) return not c:IsOnField() end,nil)
								if #g>0 then
									cm.process(g,e,tp,eg,ep,ev,re,r,rp)
								end
							end)
		Duel.RegisterEffect(e_l2,0)
		local e_l3=e_leave:Clone()
		e_l3:SetCode(EVENT_MOVE)
		e_l3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
								local g=eg:Filter(function(c) return c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsOnField() end,nil)
								if #g>0 then
									cm.process(g,e,tp,eg,ep,ev,re,r,rp)
								end
							end)
		Duel.RegisterEffect(e_l3,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetCondition(cm.descon)
		e1:SetOperation(cm.desop2)
		Duel.RegisterEffect(e1,0)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e2,0)
		local e11=e1:Clone()
		e11:SetCode(EVENT_SUMMON_NEGATED)
		Duel.RegisterEffect(e11,0)
		local e21=e1:Clone()
		e21:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(e21,0)
		local e3=e1:Clone()
		e3:SetCode(EVENT_MOVE)
		Duel.RegisterEffect(e3,0)
		local e4=e1:Clone()
		e4:SetCode(EVENT_CHAINING)
		e4:SetCondition(cm.descon3)
		e4:SetOperation(cm.desop2)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_SUMMON)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetTargetRange(1,1)
		e5:SetTarget(cm.costchk)
		Duel.RegisterEffect(e5,0)
	end
end
function cm.process(g,e,tp,eg,ep,ev,re,r,rp)
	if g:IsExists(function(c) return c:IsReason(REASON_MATERIAL+REASON_SPSUMMON+REASON_SUMMON) end,1,nil) then
		local e1=Effect.CreateEffect(e:GetHandler())
		local e2=e1:Clone()
		local e11=e1:Clone()
		local e21=e1:Clone()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev) e1:Reset() e2:Reset() e11:Reset() e21:Reset() end)
		Duel.RegisterEffect(e1,0)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e2,0)
		e11:SetCode(EVENT_SUMMON_NEGATED)
		Duel.RegisterEffect(e11,0)
		e21:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(e21,0)
	elseif g:IsExists(function(c) return c:IsReason(REASON_COST) and c:GetReasonEffect() and c:GetReasonEffect():IsActivated() and not Duel.IsChainSolving() end,1,nil) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev) e1:Reset() end)
		Duel.RegisterEffect(e1,0)
	else
		Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
	end
end
function cm.costchk(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_DUAL)~=SUMMON_TYPE_DUAL then return false end
	if c:GetFlagEffect(m-4)==0 then c:RegisterFlagEffect(m-4,RESET_EVENT+RESETS_STANDARD,0,1) end
	return false
end
function cm.filter12(c,e)
	if not (c:IsOnField() and (c:IsFacedown() or c:IsStatus(STATUS_EFFECT_ENABLED))) or c:GetFlagEffect(m-4)>0 then return false end
	if e:GetCode()==EVENT_MOVE then
		local b1,g1=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
		local b2,g2=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
		return (not b1 or not g1:IsContains(c)) and (not b2 or not g2:IsContains(c)) and c:IsPreviousLocation(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
	end
	return not ((e:GetCode()==EVENT_SUMMON_SUCCESS or e:GetCode()==EVENT_SUMMON_NEGATED) and c:GetFlagEffect(m-4)>0) and c:IsPreviousLocation(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter12,1,nil,e)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.descon3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFieldID()==re:GetHandler():GetRealFieldID() and re:GetHandler():IsPreviousLocation(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
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
				-- 假设卡组中有3只特定的「落渊」怪兽（请将 111, 222, 333 替换为它们的真实卡号）
				local code1, code2, code3 = 11452060,11452061,11452062
				local state = 0
				if cm.added_codes[tp][code1] == turn then state = state | 1 end
				if cm.added_codes[tp][code2] == turn then state = state | 2 end
				if cm.added_codes[tp][code3] == turn then state = state | 4 end
				
				-- 如果你说的 7 个情况单纯是“检索了几次（1~7次）”，
				-- 那么请删掉上面位运算，改用这段统计数量的代码：
				-- local state = 0
				-- for code, t in pairs(cm.added_codes[tp]) do
				--	 if t == turn then state = state + 1 end
				-- end
				-- if state > 7 then state = 7 end
				
				-- 3. 注册覆盖的全新提示
				if state > 0 then
					local de=Effect.CreateEffect(e:GetHandler())
					-- 根据状态偏移 Stringid。假设你在 conf 文件里用 id的 4~10 描述了这7种情况，这里就 +3
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