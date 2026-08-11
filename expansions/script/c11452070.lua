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
-- 超量召唤手续 (支持手卡·卡组)
-- =========================================
function cm.spfilter(c,sc)
	--if not c:IsType(TYPE_MONSTER) and not c:IsCanBeXyzMaterial(sc) then return false end
	local loc = c:GetLocation()
	
	-- 常规素材：场上表侧表示的 2 星怪兽
	if loc == LOCATION_MZONE then 
		return c:IsFaceup() and c:IsXyzLevel(sc,2)
	end
	-- 额外素材：手卡·卡组的「落渊」卡
	if loc == LOCATION_HAND or loc == LOCATION_DECK then
		return c:IsSetCard(0x5978)
	end
	return false
end

function cm.exchk(g,sc,tp)
	-- 提取出从手卡和卡组被选中的额外素材
	local exg = g:Filter(Card.IsLocation, nil, LOCATION_HAND+LOCATION_DECK)
	
	-- 落实文本【包含手卡的卡】：如果使用了额外素材，则这些额外素材中必须至少有1张来自手卡
	if #exg > 0 and exg:FilterCount(Card.IsLocation, nil, LOCATION_HAND) == 0 then
		return false
	end
	
	local m_ct = 0
	local s_ct = 0
	local t_ct = 0
	
	-- 校验：3种类各最多1张
	for tc in aux.Next(exg) do
		if tc:GetOriginalType()&0x1>0 then m_ct = m_ct + 1 end
		if tc:GetOriginalType()&0x2>0 then s_ct = s_ct + 1 end
		if tc:GetOriginalType()&0x4>0 then t_ct = t_ct + 1 end
	end
	
	if m_ct > 1 or s_ct > 1 or t_ct > 1 then return false end
	
	return true
end

function cm.spcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	
	local mg=nil
	if og then
		mg=og:Filter(cm.spfilter,c,c)
	else
		mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK,0,c,c)
		Debug.Message(#mg)
	end
	
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	-- 需求为精准的 3 张素材
	local res=mg:CheckSubGroup(aux.XyzLevelFreeGoal,3,3,tp,c,cm.exchk)
	aux.GCheckAdditional=nil
	return res
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then return true end
	
	local mg=nil
	if og then
		mg=og:Filter(cm.spfilter,c,c)
	else
		mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK,0,c,c)
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
	else 
		return false 
	end
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
	
	if not (og and not min) then g:DeleteGroup() end
end

-- =========================================
-- ①：极简清场（洗1除外剩余）
-- =========================================
function cm.leaveop(e,tp,eg,ep,ev,re,r,rp)
	-- 注意：作为 CONTINUOUS 效果在离场后适用时，自身如果本来带有素材，也会随着离开场上的动作规则送墓
	-- 因此 GetOverlayGroup(tp,1,1) 获取到的将是【此时场上其他还活着的】所有超量怪兽的素材，逻辑极其严密。
	local og=Duel.GetOverlayGroup(tp,1,1)
	if #og==0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=og:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	if #hg>0 then
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
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