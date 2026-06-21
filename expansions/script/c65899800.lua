-- 切断世界的斩击！
local s,id=GetID()
function s.initial_effect(c)
	-- 决斗中只能发动1张
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

---------------- 代价：精确解析绝对格子掩码并规则破坏 ----------------
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	-- fd 是相对 tp 视角的位掩码
	local fd = Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	if tp==1 then
		fd=((fd&0xffff)<<16)|((fd>>16)&0xffff)
	end
	local tc = nil
	local seq
	local cp1
	local g = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
	for mc in aux.Next(g) do
		local cp = mc:GetControler()
		local cseq = mc:GetSequence()
		local mask = 0
		
		-- 计算怪兽所在的绝对掩码
		if cp == 0 then
			mask = 1 << cseq
			if cseq == 5 then mask = 0x20 end
			if cseq == 6 then mask = 0x40 end
		else
			mask = 1 << (cseq + 16)
			if cseq == 5 then mask = 0x200000 end 
			if cseq == 6 then mask = 0x400000 end 
		end
		if fd&mask~=0 then
			tc = mc
			seq=tc:GetSequence()
			cp1=tc:GetControler()
			break
		end
	end
	e:SetLabel(fd,seq,cp1)
	if tc and Duel.Destroy(tc,REASON_RULE) and not tc:IsLocation(LOCATION_ONFIELD) then
		e:SetLabelObject(tc)
	end

	-- 第一阶段：连锁结束前临时禁用
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(fd)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1, tp)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

---------------- 处理：持续封锁与精确衍生 ----------------
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local abs_fd,seq,cp = e:GetLabel()
	local c = e:GetHandler()
	-- 1. 禁用直到下回合结束
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(abs_fd)
	e1:SetReset(RESET_PHASE+PHASE_END, 2)
	Duel.RegisterEffect(e1, tp)
	local tc=e:GetLabelObject()
	-- 2. 召唤衍生物
	if tc then
		-- 相邻映射表：通过绝对掩码匹配所有物理上相连的格子（p=0/1代表绝对玩家）
		local adj_zones = {}
		if seq==0 and cp==tp then table.insert(adj_zones, {p=tp, seq=1})
		elseif seq==1 and cp==tp then table.insert(adj_zones, {p=tp, seq=0}); table.insert(adj_zones, {p=tp, seq=2})
		elseif seq==2 and cp==tp then table.insert(adj_zones, {p=tp, seq=1}); table.insert(adj_zones, {p=tp, seq=3})
		elseif seq==3 and cp==tp then table.insert(adj_zones, {p=tp, seq=2}); table.insert(adj_zones, {p=tp, seq=4})
		elseif seq==4 and cp==tp then table.insert(adj_zones, {p=tp, seq=3})
		elseif seq==0 and cp==1-tp then table.insert(adj_zones, {p=1-tp, seq=1})
		elseif seq==1 and cp==1-tp then table.insert(adj_zones, {p=1-tp, seq=0}); table.insert(adj_zones, {p=1-tp, seq=2})
		elseif seq==2 and cp==1-tp then table.insert(adj_zones, {p=1-tp, seq=1}); table.insert(adj_zones, {p=1-tp, seq=3})
		elseif seq==3 and cp==1-tp then table.insert(adj_zones, {p=1-tp, seq=2}); table.insert(adj_zones, {p=1-tp, seq=4})
		elseif seq==4 and cp==1-tp then table.insert(adj_zones, {p=1-tp, seq=3})
		elseif (seq==5 and cp==tp) or (seq==6 and cp==1-tp) then -- 左侧额外区
			table.insert(adj_zones, {p=tp, seq=1})
			table.insert(adj_zones, {p=1-tp, seq=3})
		elseif (seq==6 and cp==tp) or (seq==5 and cp==1-tp) then -- 右侧额外区
			table.insert(adj_zones, {p=tp, seq=3})
			table.insert(adj_zones, {p=1-tp, seq=1})
		end
		
		local valid_zones = {}
		for _, z in ipairs(adj_zones) do
			-- 检查目标物理格子是否为空且未被禁用
			if Duel.CheckLocation(z.p, LOCATION_MZONE, z.seq) then
				table.insert(valid_zones, z)
			end
		end
		
		if #valid_zones > 0 then
			-- 青眼精灵龙限制检测（是否受到不能同时特召多只的制约）
			local limit = Duel.IsPlayerAffectedByEffect(tp, 59822133) and 1 or 2
			local sum_count = math.min(#valid_zones, limit)
			
			local token_codes = {65899801, 65899802}
			for i = 1, sum_count do
				local tk = Duel.CreateToken(tp, token_codes[i])
				local z = valid_zones[i]
				local val=0
				if tc:IsType(TYPE_LINK) then val = tc:GetLink()
				elseif tc:IsType(TYPE_XYZ) then val = tc:GetOriginalRank()
				else val = tc:GetOriginalLevel() end
				-- 直接精准投放到对应绝对玩家(z.p)的对应格子里
				if Duel.SpecialSummonStep(tk, 0, tp, z.p, false, false, POS_FACEUP, 1 << z.seq) then
					if tc:GetOriginalRace() then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_CHANGE_RACE)
						e1:SetValue(tc:GetOriginalRace())
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tk:RegisterEffect(e1)
					end
					if tc:GetOriginalAttribute() then
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
						e2:SetValue(tc:GetOriginalAttribute())
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						tk:RegisterEffect(e2)
					end
					if val>0 then
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetCode(EFFECT_CHANGE_LEVEL)
						e3:SetValue(math.ceil(val/2))
						e3:SetReset(RESET_EVENT+RESETS_STANDARD)
						tk:RegisterEffect(e3)
					end
				end
			end
			Duel.SpecialSummonComplete()
		end
	end
end