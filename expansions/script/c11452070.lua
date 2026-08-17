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
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsPreviousPosition(POS_FACEUP)
	end)
	e3:SetOperation(cm.leaveop)
	c:RegisterEffect(e3)
	
	-- 以前庞大的 global_check 追踪器已彻底废弃并删除，代码回归极简。
end

-- =========================================
-- 超量召唤手续 (官方双轨替代结构)
-- =========================================
function cm.altfilter(c)
	-- 仅抓取手卡和卡组的落渊卡
	return (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_DECK)) and c:IsSetCard(0x5978)
end

function cm.altgoal(g)
	local deck_m = 0
	local deck_st = 0
	local hand_st = 0
	local s_ct = 0
	local t_ct = 0
	
	for tc in aux.Next(g) do
		local loc = tc:GetLocation()
		local typ = tc:GetType()
		
		if loc == LOCATION_DECK then
			if typ & TYPE_MONSTER > 0 then deck_m = deck_m + 1
			else deck_st = deck_st + 1 end
		elseif loc == LOCATION_HAND then
			if typ & TYPE_MONSTER == 0 then hand_st = hand_st + 1
			else return false end -- 手卡不能是怪兽
		else
			return false
		end
		
		if typ & TYPE_SPELL > 0 then s_ct = s_ct + 1 end
		if typ & TYPE_TRAP > 0 then t_ct = t_ct + 1 end
	end
	
	-- 精准匹配：卡组1怪，卡组1魔陷，手卡1魔陷
	if deck_m ~= 1 or deck_st ~= 1 or hand_st ~= 1 then return false end
	-- 精准匹配：魔陷种类各不相同（各1）
	if s_ct ~= 1 or t_ct ~= 1 then return false end
	
	return true
end

function cm.spcon(e,c,og,min,max)
	if c==nil then return true end
	local tp = c:GetControler()
	local minc = min or 3
	local maxc = max or 3
	if minc > 3 or maxc < 3 then return false end
	
	-- b1: 常规超量条件（交由底层C++高效处理）
	local b1 = Duel.CheckXyzMaterial(c,nil,2,3,3,og)
	
	-- b2: 替代超量条件（1回合1次，且不使用og）
	local b2 = false
	if Duel.GetFlagEffect(tp,m) == 0 and (not og) then
		local mg = Duel.GetMatchingGroup(cm.altfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		b2 = mg:CheckSubGroup(cm.altgoal,3,3)
	end
	
	return b1 or b2
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then return true end
	local minc = min or 3
	local maxc = max or 3
	
	local b1 = Duel.CheckXyzMaterial(c,nil,2,3,3,og)
	local b2 = false
	local mg = nil
	
	if Duel.GetFlagEffect(tp,m) == 0 and (not og) then
		mg = Duel.GetMatchingGroup(cm.altfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		b2 = mg:CheckSubGroup(cm.altgoal,3,3)
	end
	
	local g = nil
	-- 如果两种方式都满足，询问是否使用替代方式（你可以把提示字符串换成自定义的）
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		e:SetLabel(1) -- 标记为使用了替代召唤
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local cancel = Duel.IsSummonCancelable()
		g = mg:SelectSubGroup(tp,cm.altgoal,cancel,3,3)
		if not g then return false end
	else
		e:SetLabel(0) -- 标记为常规召唤
		g = Duel.SelectXyzMaterial(tp,c,nil,2,3,3,og)
		if not g then return false end
	end
	
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		local sg=Group.CreateGroup()
		for tc in aux.Next(og) do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local g=e:GetLabelObject()
		if not g then return end
		
		local sg=Group.CreateGroup()
		for tc in aux.Next(g) do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(g)
		Duel.Overlay(c,g)
		
		-- 如果是替代召唤，打上1回合1次标记并洗牌
		if e:GetLabel() == 1 then
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
			if g:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then Duel.ShuffleHand(tp) end
		end
		
		g:DeleteGroup()
	end
end

-- =========================================
-- ①：极简清场（洗1除外剩余）
-- =========================================
function cm.leaveop(e,tp,eg,ep,ev,re,r,rp)
	-- 注意：作为 CONTINUOUS 效果在离场后适用时，自身如果本来带有素材，也会随着离开场上的动作规则送墓
	-- 因此 GetOverlayGroup(tp,1,1) 获取到的将是【此时场上其他还活着的】所有超量怪兽的素材，逻辑极其严密。
	local c=e:GetHandler()
	local og=Duel.GetOverlayGroup(tp,1,1)+c:GetOverlayGroup()
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
--[[local cm,m=GetID()
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
	
	-- ①：离场后的效果处理
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(cm.leaveop) -- 帮你修正了这里的拼写错误
	c:RegisterEffect(e3)

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
							
							local changed = false -- 判定是否需要刷新UI
							for tc in aux.Next(eg) do
								if tc:IsLocation(LOCATION_DECK|LOCATION_EXTRA) then
									local ploc = tc:GetPreviousLocation()
									if bit.band(ploc, LOCATION_ONFIELD)>0 and not cm.ret_loc_this_turn[turn][LOCATION_ONFIELD] then 
										cm.ret_loc_this_turn[turn][LOCATION_ONFIELD]=true 
										changed = true
									end
									if bit.band(ploc, LOCATION_GRAVE)>0 and not cm.ret_loc_this_turn[turn][LOCATION_GRAVE] then 
										cm.ret_loc_this_turn[turn][LOCATION_GRAVE]=true 
										changed = true
									end
									if bit.band(ploc, LOCATION_REMOVED)>0 and not cm.ret_loc_this_turn[turn][LOCATION_REMOVED] then 
										cm.ret_loc_this_turn[turn][LOCATION_REMOVED]=true 
										changed = true
									end
									if bit.band(ploc, LOCATION_EXTRA)>0 and not cm.ret_loc_this_turn[turn][LOCATION_EXTRA] then 
										cm.ret_loc_this_turn[turn][LOCATION_EXTRA]=true 
										changed = true
									end
								end
							end
							
							-- 【全新客户端提示系统】：如果检测到新区域，则重新计算并覆盖提示
							if changed then
								local state = 0
								if cm.ret_loc_this_turn[turn][LOCATION_ONFIELD] then state = state | 1 end
								if cm.ret_loc_this_turn[turn][LOCATION_GRAVE] then state = state | 2 end
								if cm.ret_loc_this_turn[turn][LOCATION_REMOVED] then state = state | 4 end
								if cm.ret_loc_this_turn[turn][LOCATION_EXTRA] then state = state | 8 end
								
								if cm.client_hint_eff[tp] then
									cm.client_hint_eff[tp]:Reset()
									cm.client_hint_eff[tp] = nil
								end
								
								if state > 0 then
									local de=Effect.CreateEffect(e:GetHandler())
									-- 直接读取 1 ~ 15 号描述。需要你在字符串配置里按组合填好
									de:SetDescription(aux.Stringid(m, state))
									de:SetType(EFFECT_TYPE_FIELD)
									de:SetCode(EFFECT_FLAG_EFFECT)
									de:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
									de:SetTargetRange(1,0)
									de:SetReset(RESET_PHASE+PHASE_END)
									Duel.RegisterEffect(de, tp)
									
									cm.client_hint_eff[tp] = de
								end
							end
						end)
						Duel.RegisterEffect(ge1,tp)
					end)
	c:RegisterEffect(e2)
	-- 全局追踪：本回合卡从哪里回到卡组
	if not cm.global_check then
		cm.global_check=true
		cm.ret_loc_this_turn = {}
		cm.bonus_mat_used = {}
		cm.client_hint_eff = {} -- 【新增】：用于缓存客户端提示效果以便清理
	end
end

-- =========================================
-- 超量召唤手续
-- =========================================
function cm.spfilter(c,sc,loc_tracker,used_tracker)
	if not c:IsCanBeXyzMaterial(sc) then return false end
	-- 核心修正：必须是原属性为怪兽的卡，且等级为2（兼容魔陷区与墓地除外的判断）
	if not (c:GetOriginalType()&0x1>0 and (c:IsXyzLevel(sc,2) or (not c:IsType(TYPE_MONSTER) and c:GetOriginalLevel()==2))) then return false end
	
	local loc = c:GetLocation()
	if loc == LOCATION_MZONE then return c:IsFaceup() end
	if loc == LOCATION_SZONE then return c:IsFaceup() and loc_tracker[LOCATION_ONFIELD] and not used_tracker[LOCATION_ONFIELD] end
	if loc == LOCATION_GRAVE then return loc_tracker[LOCATION_GRAVE] and not used_tracker[LOCATION_GRAVE] end
	if loc == LOCATION_REMOVED then return c:IsFaceup() and loc_tracker[LOCATION_REMOVED] and not used_tracker[LOCATION_REMOVED] end
	if loc == LOCATION_EXTRA then return loc_tracker[LOCATION_EXTRA] and not used_tracker[LOCATION_EXTRA] end
	return false
end

function cm.exchk(g)
	local counts = {}
	for tc in aux.Next(g) do
		local loc = tc:GetLocation()
		if loc == LOCATION_SZONE then loc = LOCATION_ONFIELD end
		if loc ~= LOCATION_MZONE then
			counts[loc] = (counts[loc] or 0) + 1
			if counts[loc] > 1 then return false end
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
	Duel.Overlay(c,g)
	
	-- 记录特权区域的调用
	local turn = Duel.GetTurnCount()
	cm.bonus_mat_used[turn] = cm.bonus_mat_used[turn] or {}
	cm.bonus_mat_used[turn][tp] = cm.bonus_mat_used[turn][tp] or {}
	for tc in aux.Next(g) do
		local loc = tc:GetLocation()
		if loc == LOCATION_SZONE then loc = LOCATION_ONFIELD end
		if loc ~= LOCATION_MZONE then
			cm.bonus_mat_used[turn][tp][loc] = true
		end
	end
	
	if not (og and not min) then g:DeleteGroup() end
end

function cm.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=Duel.GetOverlayGroup(tp,1,1)
	-- 如果离场时没有超量素材（不符合“持有超量素材的这张卡从场上离开”），直接中止
	if #og==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=og:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	if #hg>0 then
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		-- 将选中的卡从 og 中剔除，剩下的素材全部除外
		og:Sub(hg)
		if #og>0 then
			Duel.Remove(og,POS_FACEUP,REASON_EFFECT)
		end
	end
end--]]