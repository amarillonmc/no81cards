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

function s.GetKey(loc, seq, owner)
    return owner * 1000 + loc * 10 + seq
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

function s.FindMine(loc, seq, owner)
    for _, m in ipairs(s.mines) do
        if m.loc == loc and m.seq == seq and m.owner == owner then
            return true
        end
    end
    return false
end

-- 持续检测并一次性排雷
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
    -- 收集所有待破坏的卡，按 reason_player 分组
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

    -- 按原因玩家分组执行破坏
    for rp, g in pairs(destroy_groups) do
        if #g > 0 then
            Duel.Destroy(g, REASON_EFFECT, LOCATION_GRAVE, rp)
        end
    end

    -- 批量移除已引爆的雷区并清除提示
    for i = #removed_indices, 1, -1 do
        local idx = removed_indices[i]
        local m = s.mines[idx]
        local key = s.GetKey(m.loc, m.seq, m.owner)
        if m.owner == 2 then
            s.ClearHint(0, key)
            s.ClearHint(1, key)
        else
            s.ClearHint(m.owner, key)
        end
        table.remove(s.mines, idx)
    end
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
            table.insert(s.mines, {loc=z.loc, seq=z.seq, owner=z.owner, reason_player=reason})
            local key = s.GetKey(z.loc, z.seq, z.owner)
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