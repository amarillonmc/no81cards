-- 落渊星束『万法归一』
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	
	-- 【自定义超量召唤手续】
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	
	-- ①：表侧表示的这张卡从场上离开的场合
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(0xff)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsContains(e:GetHandler()) and e:GetHandler():IsPreviousPosition(POS_FACEUP)
	end)
	e3:SetOperation(cm.leaveop)
	c:RegisterEffect(e3)

	-- 【全局追踪器】本回合卡从哪里回到卡组（数量统计）
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
			local turn = Duel.GetTurnCount()
			if not cm.ret_loc_this_turn[turn] then cm.ret_loc_this_turn[turn] = {} end
			
			local changed = false 
			for tc in aux.Next(eg) do
				if tc:IsLocation(LOCATION_DECK) then
					local ploc = tc:GetPreviousLocation()
					if bit.band(ploc, LOCATION_ONFIELD)>0 then 
						cm.ret_loc_this_turn[turn][LOCATION_ONFIELD] = (cm.ret_loc_this_turn[turn][LOCATION_ONFIELD] or 0) + 1
						changed = true
					end
					if bit.band(ploc, LOCATION_GRAVE)>0 then 
						cm.ret_loc_this_turn[turn][LOCATION_GRAVE] = (cm.ret_loc_this_turn[turn][LOCATION_GRAVE] or 0) + 1
						changed = true
					end
					if bit.band(ploc, LOCATION_REMOVED)>0 then 
						cm.ret_loc_this_turn[turn][LOCATION_REMOVED] = (cm.ret_loc_this_turn[turn][LOCATION_REMOVED] or 0) + 1
						changed = true
					end
					if bit.band(ploc, LOCATION_EXTRA)>0 then 
						cm.ret_loc_this_turn[turn][LOCATION_EXTRA] = (cm.ret_loc_this_turn[turn][LOCATION_EXTRA] or 0) + 1
						changed = true
					end
				end
			end
			
			-- UI更新（可用名额增加时刷新提示）
			if changed then
				cm.update_hint(0, e:GetHandler())
				cm.update_hint(1, e:GetHandler())
			end
		end)
		Duel.RegisterEffect(ge1,tp)
	end)
	c:RegisterEffect(e2)
	
	if not cm.global_check then
		cm.global_check=true
		cm.ret_loc_this_turn = {}
		cm.bonus_mat_used = {}
		cm.client_hint_eff = {} 
		cm.current_hint_state = {}
	end
end

-- =========================================
-- 全新客户端提示刷新逻辑（动态计算 可用 > 已用）
-- =========================================
function cm.update_hint(p, c)
	local turn = Duel.GetTurnCount()
	local loc_tracker = cm.ret_loc_this_turn[turn] or {}
	local used_tracker = cm.bonus_mat_used[turn] and cm.bonus_mat_used[turn][p] or {}
	
	local state = 0
	if (loc_tracker[LOCATION_ONFIELD] or 0) > (used_tracker[LOCATION_ONFIELD] or 0) then state = state | 1 end
	if (loc_tracker[LOCATION_GRAVE] or 0) > (used_tracker[LOCATION_GRAVE] or 0) then state = state | 2 end
	if (loc_tracker[LOCATION_REMOVED] or 0) > (used_tracker[LOCATION_REMOVED] or 0) then state = state | 4 end
	if (loc_tracker[LOCATION_EXTRA] or 0) > (used_tracker[LOCATION_EXTRA] or 0) then state = state | 8 end
	
	-- 将状态缓存绑定回合数，防回合结束的自动清空导致的内存报错
	cm.current_hint_state[turn] = cm.current_hint_state[turn] or {}
	cm.client_hint_eff[turn] = cm.client_hint_eff[turn] or {}
	
	if cm.current_hint_state[turn][p] ~= state then
		cm.current_hint_state[turn][p] = state
		if cm.client_hint_eff[turn][p] then
			cm.client_hint_eff[turn][p]:Reset()
			cm.client_hint_eff[turn][p] = nil
		end
		
		if state > 0 then
			local de=Effect.CreateEffect(c)
			de:SetDescription(aux.Stringid(m, state))
			de:SetType(EFFECT_TYPE_FIELD)
			de:SetCode(EFFECT_FLAG_EFFECT)
			de:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			de:SetTargetRange(1,0)
			de:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(de, p)
			cm.client_hint_eff[turn][p] = de
		end
	end
end

-- =========================================
-- 超量召唤手续逻辑 (基于数量比较)
-- =========================================
function cm.spfilter(c,sc,loc_tracker,used_tracker)
	if not c:IsCanBeXyzMaterial(sc) then return false end
	if not (c:GetOriginalType()&0x1>0 and (c:IsXyzLevel(sc,2) or (not c:IsType(TYPE_MONSTER) and c:GetOriginalLevel()==2))) then return false end
	
	local loc = c:GetLocation()
	if loc == LOCATION_MZONE then return c:IsFaceup() end
	-- 当前剩余名额 = 允许总量 - 已用总量，若 >0 则允许选入
	if loc == LOCATION_SZONE then return c:IsFaceup() and (loc_tracker[LOCATION_ONFIELD] or 0) > (used_tracker[LOCATION_ONFIELD] or 0) end
	if loc == LOCATION_GRAVE then return (loc_tracker[LOCATION_GRAVE] or 0) > (used_tracker[LOCATION_GRAVE] or 0) end
	if loc == LOCATION_REMOVED then return c:IsFaceup() and (loc_tracker[LOCATION_REMOVED] or 0) > (used_tracker[LOCATION_REMOVED] or 0) end
	if loc == LOCATION_EXTRA then return (loc_tracker[LOCATION_EXTRA] or 0) > (used_tracker[LOCATION_EXTRA] or 0) end
	return false
end

function cm.exchk(g,sc,tp)
	local turn = Duel.GetTurnCount()
	local loc_tracker = cm.ret_loc_this_turn[turn] or {}
	local used_tracker = cm.bonus_mat_used[turn] and cm.bonus_mat_used[turn][tp] or {}
	
	local counts = {}
	for tc in aux.Next(g) do
		local loc = tc:GetLocation()
		if loc == LOCATION_SZONE then loc = LOCATION_ONFIELD end
		if loc ~= LOCATION_MZONE then
			counts[loc] = (counts[loc] or 0) + 1
			local allowed = loc_tracker[loc] or 0
			local used = used_tracker[loc] or 0
			-- 校验组内：如果已用量 + 当前正在选择的这批卡的数量 > 总配额，则非法
			if used + counts[loc] > allowed then return false end
		end
	end
	return true
end

function cm.spcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local turn = Duel.GetTurnCount()
	local loc_tracker = cm.ret_loc_this_turn[turn] or {}
	local used_tracker = cm.bonus_mat_used[turn] and cm.bonus_mat_used[turn][tp] or {}
	
	local mg=nil
	if og then
		mg=og:Filter(cm.spfilter,c,c,loc_tracker,used_tracker)
	else
		mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,c,c,loc_tracker,used_tracker)
	end
	
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local res=mg:CheckSubGroup(aux.XyzLevelFreeGoal,3,3,tp,c,cm.exchk)
	aux.GCheckAdditional=nil
	return res
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then return true end
	local turn = Duel.GetTurnCount()
	local loc_tracker = cm.ret_loc_this_turn[turn] or {}
	local used_tracker = cm.bonus_mat_used[turn] and cm.bonus_mat_used[turn][tp] or {}
	
	local mg=nil
	if og then
		mg=og:Filter(cm.spfilter,c,c,loc_tracker,used_tracker)
	else
		mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,c,c,loc_tracker,used_tracker)
	end
	
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local cancel=Duel.IsSummonCancelable()
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local g=mg:SelectSubGroup(tp,aux.XyzLevelFreeGoal,cancel,3,3,tp,c,cm.exchk)
	aux.GCheckAdditional=nil
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		g=e:GetLabelObject()
	end
	
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)

	-- 【视觉Bug修复】：将额外卡组素材与普通素材分离
	local exg = Group.CreateGroup()
	local normal_g = Group.CreateGroup()
	for tc in aux.Next(g) do
		if tc:IsLocation(LOCATION_EXTRA) and tc:IsFacedown() then
			exg:AddCard(tc)
		else
			normal_g:AddCard(tc)
		end
	end
	
	-- 常规素材直接垫入（场上/手卡/墓地/除外等）
	if #normal_g > 0 then
		Duel.Overlay(c, normal_g)
	end
	normal_g:DeleteGroup()

	-- 额外卡组的素材延迟到超量怪兽落地后再塞入，规避客户端不渲染的底层 Bug
	if #exg > 0 then
		Duel.ConfirmCards(1-tp, exg) 
		exg:KeepAlive()
		
		-- 成功登场时塞入
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_MOVE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabelObject(exg)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local tg=e:GetLabelObject()
			if e:GetHandler():IsLocation(LOCATION_MZONE) then
				Duel.Overlay(e:GetHandler(), tg)
			end
			tg:DeleteGroup()
			e:Reset()
		end)
		c:RegisterEffect(e1,true)
	else
		exg:DeleteGroup() 
	end
	
	local turn = Duel.GetTurnCount()
	cm.bonus_mat_used[turn] = cm.bonus_mat_used[turn] or {}
	cm.bonus_mat_used[turn][tp] = cm.bonus_mat_used[turn][tp] or {}
	local used_changed = false
	for tc in aux.Next(g) do
		local loc = tc:GetLocation()
		if loc == LOCATION_SZONE then loc = LOCATION_ONFIELD end
		if loc ~= LOCATION_MZONE then
			local used_count = cm.bonus_mat_used[turn][tp][loc] or 0
			cm.bonus_mat_used[turn][tp][loc] = used_count + 1
			used_changed = true
		end
	end
	
	-- UI更新（可用名额减少时，动态扣除提示并刷新）
	if used_changed then
		cm.update_hint(tp, c)
	end
	
	if not (og and not min) then g:DeleteGroup() end
end

-- =========================================
-- ① 极简清场处理
-- =========================================
function cm.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=Duel.GetOverlayGroup(tp,1,1)+c:GetOverlayGroup()
	for tc in aux.Next(eg) do og:Merge(tc:GetOverlayGroup()) end
	if #og==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=og:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	if #hg>0 then
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		if hg:GetFirst():IsLocation(LOCATION_HAND) then Duel.ShuffleHand(hg:GetFirst():GetControler()) end
		og:Sub(hg)
		if #og>0 then
			Duel.Remove(og,POS_FACEUP,REASON_EFFECT)
		end
	end
end