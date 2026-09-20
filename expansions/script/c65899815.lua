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
        s.global_check = true
        s.mine_map = {}

        s.all_zones = {}
        local function add_zone(loc, seq, owner)
            table.insert(s.all_zones, {loc=loc, seq=seq, owner=owner})
        end
        for p=0,1 do
            for seq=0,4 do add_zone(LOCATION_MZONE, seq, p) end
            for seq=0,4 do add_zone(LOCATION_SZONE, seq, p) end
            add_zone(LOCATION_SZONE, 5, p)
        end
        add_zone(LOCATION_MZONE, 5, 2)
        add_zone(LOCATION_MZONE, 6, 2)

        s.total_zones = #s.all_zones
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

-- 每个雷区注册独立 effect；不用 SetCountLimit，改用 e:Reset() 自我销毁
function s.RegisterMine(c, tp, loc, seq, owner, key)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ADJUST)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetLabel(loc, seq, owner, key)
    e1:SetCondition(s.minecon)
    e1:SetOperation(s.mineop)
    Duel.RegisterEffect(e1, tp)
end

function s.minecon(e)
    local loc, seq, owner = e:GetLabel()
    if owner == 2 then
        return Duel.GetFieldCard(0, loc, seq)~=nil
            or Duel.GetFieldCard(1, loc, seq)~=nil
    else
        return Duel.GetFieldCard(owner, loc, seq)~=nil
    end
end

function s.mineop(e, tp, eg, ep, ev, re, r, rp)
    local loc, seq, owner, key = e:GetLabel()
    local g = Group.CreateGroup()
    if owner == 2 then
        local a = Duel.GetFieldCard(0, loc, seq)
        if a then g:AddCard(a) end
        local b = Duel.GetFieldCard(1, loc, seq)
        if b and b~=a then g:AddCard(b) end
    else
        local tc = Duel.GetFieldCard(owner, loc, seq)
        if tc then g:AddCard(tc) end
    end
    if #g == 0 then return end

    -- 关键：先 self-Reset，防止 Duel.Destroy 引发的嵌套 EVENT_ADJUST 再触发本 effect
    e:Reset()

    Duel.Hint(HINT_CARD, 0, id)
    if owner == 2 then
        s.ClearHint(0, key)
        s.ClearHint(1, key)
    else
        s.ClearHint(owner, key)
    end
    s.mine_map[key] = nil

    Duel.Destroy(g, REASON_EFFECT)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk == 0 then
        for _, z in ipairs(s.all_zones) do
            if not s.mine_map[s.GetKey(z.loc, z.seq, z.owner)] then return true end
        end
        return false
    end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    for _, z in ipairs(s.all_zones) do
        local key = s.GetKey(z.loc, z.seq, z.owner)
        if not s.mine_map[key] then
            s.mine_map[key] = true
            s.RegisterMine(c, tp, z.loc, z.seq, z.owner, key)
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