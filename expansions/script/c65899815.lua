--别样的扫雷大战
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	if not s.global_check then
		s.global_check=true
		s.mines = {}
		s.mine_map = {}

		s.all_zones = {}
		local function add_zone(loc, seq, owner)
			table.insert(s.all_zones, {loc=loc, seq=seq, owner=owner})
		end
		for p=0,1 do
			for seq=0,4 do
				add_zone(LOCATION_MZONE, seq, p)
			end
			for seq=0,4 do
				add_zone(LOCATION_SZONE, seq, p)
			end
			add_zone(LOCATION_SZONE, 5, p)
		end
		add_zone(LOCATION_MZONE, 5, 2)
		add_zone(LOCATION_MZONE, 6, 2)

		s.total_zones = #s.all_zones

		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.adjustop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.GetStringid(p, loc, seq)
	if loc == LOCATION_FZONE or (loc == LOCATION_SZONE and seq == 5) then
		return 10
	end
	if loc == LOCATION_MZONE then
		if seq <= 4 then return seq end
		if p == 0 then
			return seq == 5 and 11 or 12
		else
			return seq == 5 and 12 or 11
		end
	end
	if loc == LOCATION_SZONE and seq <= 4 then
		return seq + 5
	end
	return -1
end

-- 优化 key：用位运算组合，无歧义，覆盖所有 owner/loc/seq 组合
-- owner 用 4 位（0~2），loc 用 16 位（LOCATION_FZONE=0x100 也能放下），seq 用 8 位
function s.GetKey(loc, seq, owner)
	return (owner << 24) | (loc << 8) | seq
end

function s.RegisterHint(c, p, key, stringid)
	local te=Effect.CreateEffect(c)
	te:SetDescription(aux.Stringid(id, stringid))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT + id + key)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te, p)
end

function s.ClearHint(p, key)
	Duel.ResetFlagEffect(p, EFFECT_FLAG_EFFECT + id + key)
end

-- 优化：O(1) 查找，用 s.mine_map 替代线性遍历
function s.FindMine(loc, seq, owner)
	return s.mine_map[s.GetKey(loc, seq, owner)] ~= nil
end

-- 持续检测并一次性排雷
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
    -- 内层嵌套调用直接返回，交给外层 while 继续处理
    if s.processing then return end
    s.processing = true

    while true do
        local destroy_groups = {}
        local removed_indices = {}
        for i, m in ipairs(s.mines) do
            local c = nil
            if m.owner == 2 then
                c = Duel.GetFieldCard(0, m.loc, m.seq)
                if not c then c = Duel.GetFieldCard(1, m.loc, m.seq) end
            else
                c = Duel.GetFieldCard(m.owner, m.loc, m.seq)
            end
            if c then
                local rp = m.reason_player
                if not destroy_groups[rp] then
                    destroy_groups[rp] = Group.CreateGroup()
                end
                destroy_groups[rp]:AddCard(c)
                table.insert(removed_indices, i)
            end
        end

        -- 没有可触发的雷区，结束循环
        if #removed_indices == 0 then break end

        -- 先把已触发的雷区从 s.mines 移除（避免下一轮重复匹配）
        for i = #removed_indices, 1, -1 do
            local idx = removed_indices[i]
            local m = s.mines[idx]
            local key = s.GetKey(m.loc, m.seq, m.owner)
            s.mine_map[key] = nil
            if m.owner == 2 then
                s.ClearHint(0, key)
                s.ClearHint(1, key)
            else
                s.ClearHint(m.owner, key)
            end
            table.remove(s.mines, idx)
        end

        -- 执行破坏。这会在内核里同步触发新的 EVENT_MOVE/ADJUST，
        -- 那些嵌套调用会被上面的 if s.processing 挡住。
        for rp, g in pairs(destroy_groups) do
            if #g > 0 then
                Duel.Destroy(g, REASON_EFFECT, LOCATION_GRAVE, rp)
            end
        end
        -- 回到 while 顶部，重新扫描 s.mines：
        --   - 如果破坏过程中没有新卡进入其他雷区 → 下一轮 #removed_indices == 0 → break
        --   - 如果有新卡（例如遗言效果把卡移动到别的雷区）→ 继续处理
    end

    s.processing = false
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then
		return #s.mines < s.total_zones
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local reason = e:GetHandlerPlayer()
	for _, z in ipairs(s.all_zones) do
		if not s.FindMine(z.loc, z.seq, z.owner) then
			local key = s.GetKey(z.loc, z.seq, z.owner)
			local m = {loc=z.loc, seq=z.seq, owner=z.owner, reason_player=reason}
			table.insert(s.mines, m)
			s.mine_map[key] = m         --同步写入 hash 表
			if z.owner == 2 then
				local sid0 = s.GetStringid(0, z.loc, z.seq)
				local sid1 = s.GetStringid(1, z.loc, z.seq)
				if sid0 >= 0 then s.RegisterHint(c, 0, key, sid0) end
				if sid1 >= 0 then s.RegisterHint(c, 1, key, sid1) end
			else
				local sid = s.GetStringid(z.owner, z.loc, z.seq)
				if sid >= 0 then s.RegisterHint(c, z.owner, key, sid) end
			end
		end
	end
end