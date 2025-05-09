if AD_Database_3 then return end
AD_Database_3=true
SNNM=SNNM or {}
local s=SNNM
if not Card.GetLinkMarker then
	function Card.GetLinkMarker(c)
		local res=0
		for i=0,8 do
			if i~=4 and c:IsLinkMarker(1<<i) then res=res|(1<<i) end
		end
		return res
	end
end
function s.GetOriginalCode(card_object)
	local target_metatable = getmetatable(card_object)
	if not target_metatable then return nil end
	for key, value in pairs(_G) do
		if type(key) == "string" and value == target_metatable and string.sub(key, 1, 1) == 'c' then
			local code_str = string.sub(key, 2)
			local code_num = tonumber(code_str)
			if code_num then
				 return code_num
			else
				 -- 如果卡号可能包含非数字字符（虽然不太可能），可以返回字符串
				 -- return code_str
				 return nil -- 或者标记错误，卡号通常是数字
			end
		end
	end
	return nil -- 未找到
end
function s.LostLink(c)
	--if AD_LostLink_check then return end
	--AD_LostLink_check=true
	local markers={0x1,0x2,0x4,0x8,0x20,0x40,0x80,0x100}
	local _GetLink=Card.GetLink
	local _IsLink=Card.IsLink
	local _IsLinkAbove=Card.IsLinkAbove
	local _IsLinkBelow=Card.IsLinkBelow
	Card.GetLink=function(sc)
		if c~=sc or not sc:IsLocation(LOCATION_MZONE) then return _GetLink(sc) end
		return s.NumNumber(sc:GetLinkMarker(),markers)
	end
	Card.IsLink=function(sc,...)
		if c~=sc or not sc:IsLocation(LOCATION_MZONE) then return _IsLink(sc,...) end
		local t={...}
		for _,v in ipairs(t) do if s.NumNumber(sc:GetLinkMarker(),markers)==v then return true end end
		return false
	end
	Card.IsLinkAbove=function(sc,link)
		if c~=sc or not sc:IsLocation(LOCATION_MZONE) then return _IsLinkAbove(sc,link) end
		if s.NumNumber(sc:GetLinkMarker(),markers)>=link then return true else return false end
	end
	Card.IsLinkBelow=function(sc,link)
		if c~=sc or not sc:IsLocation(LOCATION_MZONE) then return _IsLinkBelow(sc,link) end
		if s.NumNumber(sc:GetLinkMarker(),markers)<=link then return true else return false end
	end
end
function s.NumNumber(a,hex_numbers)
	local count = 0
	for _, num in ipairs(hex_numbers) do
		if bit.band(a, num) ~= 0 then
			count = count + 1
		end
	end
	return count
end
function s.NumberNum(a)
	local count = 0
	while a > 0 do
		if a & 1 == 1 then
			count = count + 1
		end
		a = a >> 1
	end
	return count
end
function s.ClearWorld(c)
	if s.Clear_World_Check then return end
	s.Clear_World_Check=true
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge0:SetCode(EVENT_ADJUST)
	ge0:SetOperation(s.ClearWorldop)
	Duel.RegisterEffect(ge0,0)
	local f1=Card.CopyEffect
	Card.CopyEffect=function(sc,code,rf,ct)
		if code==33900648 then
			local token=Duel.CreateToken(sc:GetControler(),33900648)
			getmetatable(sc).attributechk=getmetatable(token).attributechk
		end
		local cid=f1(sc,code,rf,ct)
		if code==33900648 then
			local rct=ct or 1
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_FZONE)
			e1:SetTargetRange(1,0)
			e1:SetCode(33900648)
			e1:SetCondition(s.ClearWorldRpcon)
			if rf and rf~=0 then e1:SetReset(rf,rct) end
			sc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(sc)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(1,1)
			e2:SetCode(53797114)
			e2:SetLabel(cid)
			e2:SetLabelObject(e1)
			Duel.RegisterEffect(e2,0)
		end
		return cid
	end
	local f2=Card.ResetEffect
	Card.ResetEffect=function(sc,rc,rt)
		if rt==RESET_COPY then
			local le={Duel.IsPlayerAffectedByEffect(0,53797114)}
			for _,v in pairs(le) do
				if v:GetLabel()==rc and v:GetLabelObject() and v:GetLabelObject():GetOwner()==sc then v:GetLabelObject():Reset() end
			end
		end
		return f2(sc,rc,rt)
	end
	local f3=Card.ReplaceEffect
	Card.ReplaceEffect=function(sc,code,rf,ct)
		if code==33900648 then
			local token=Duel.CreateToken(sc:GetControler(),33900648)
			getmetatable(sc).attributechk=getmetatable(token).attributechk
		end
		local cid=f3(sc,code,rf,ct)
		local rct=ct or 1
		if code==33900648 then
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_FZONE)
			e1:SetTargetRange(1,0)
			e1:SetCode(33900648)
			e1:SetCondition(s.ClearWorldRpcon)
			if rf and rf~=0 then e1:SetReset(rf,rct) end
			sc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(sc)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(1,1)
			e2:SetCode(53797114)
			e2:SetLabel(cid)
			e2:SetLabelObject(e1)
			Duel.RegisterEffect(e2,0)
		elseif sc:GetOriginalCode()==33900648 and code~=0 then
			if rf and rf~=0 then sc:RegisterFlagEffect(53797114,rf,0,ct) else sc:RegisterFlagEffect(53797114,0,0,0) end
		end
		return cid
	end
end
function s.ClearWorldRpcon(e)
	return e:GetHandler():GetFlagEffect(53797114)==0
end
function s.ClearWorldop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.__add(Duel.GetFieldGroup(0,0xff,0xff),Duel.GetOverlayGroup(0,1,1)):Filter(function(c)return c:GetOriginalCode()==33900648 end,nil)
	local g=sg:Filter(function(c)return c:GetFlagEffect(id)==0 end,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id,0,0,0)
		tc:SetStatus(STATUS_INITIALIZING,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_FZONE)
		e1:SetTargetRange(1,0)
		e1:SetCode(33900648)
		e1:SetCondition(s.ClearWorldRpcon)
		tc:RegisterEffect(e1,true)
		tc:SetStatus(STATUS_INITIALIZING,false)
		local f=getmetatable(tc).attributechk
		getmetatable(tc).attributechk=function(p)
			local attchk=f(p)
			if not Duel.IsPlayerAffectedByEffect(p,97811903) and not Duel.IsPlayerAffectedByEffect(p,6089145) then
				local le1={Duel.IsPlayerAffectedByEffect(p,53797115)}
				for _,v in pairs(le1) do
					local val=v:GetValue()
					if aux.GetValueType(val)~="number" then val=val(v) end
					attchk=attchk|val
				end
				local le2={Duel.IsPlayerAffectedByEffect(p,53797116)}
				for _,v in pairs(le2) do
					local val=v:GetValue()
					if aux.GetValueType(val)~="number" then val=val(v) end
					attchk=attchk&(~val)
				end
			end
			return attchk
		end
	end
end
function s.ClearWorldAttCheck(ap,ep)
	local attchk=0
	local le={Duel.IsPlayerAffectedByEffect(ap,33900648)}
	for _,v in pairs(le) do
		attchk=(getmetatable(v:GetOwner()).attributechk)(ep)
	end
	return attchk
end
function s.ScreemEquips(c,pro)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(s.ScreemEtarget)
	e1:SetOperation(s.ScreemEoperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetValue(100)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+pro)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(s.ScreemEDcon)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	if not s.ScreemEquips_check then
		s.ScreemEquips_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCode(EVENT_LEAVE_FIELD_P)
		ge1:SetOperation(s.ScreemEvalcheck)
		Duel.RegisterEffect(ge1,0)
	end
	return e4
end
function s.ScreemEDfilter(c)
	local ec=c:GetPreviousEquipTarget()
	return ec and c:GetReason()&0x201==0x201 and c:IsFaceup() and ec:IsReason(REASON_XYZ)-- and c:IsSetCard(0xc538)
end
function s.ScreemEvalcheck(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.ScreemEDfilter,nil)
	g:ForEach(Card.ResetFlagEffect,53762000)
	local mg=Group.CreateGroup()
	for eqc in aux.Next(g) do mg:AddCard(eqc:GetPreviousEquipTarget()) end
	for ec in aux.Next(mg) do
		local eqg=Group.CreateGroup()
		for eqc in aux.Next(g) do if eqc:GetPreviousEquipTarget()==ec then eqg:AddCard(eqc) end end
		g:ForEach(Card.RegisterFlagEffect,53762000,RESET_EVENT+0x1420000,0,1,eqg:GetClassCount(Card.GetCode))
	end
end
function s.ScreemEtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.ScreemEoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function s.ScreemEDcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return ec and c:GetReason()&0x201==0x201 and ec:IsReason(REASON_XYZ)
end
function s.ScreemTraps(c,gete)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(s.ScreemTcost)
	e1:SetTarget(s.ScreemTtarget)
	e1:SetOperation(s.ScreemToperation(gete))
	c:RegisterEffect(e1)
	return e1
end
function s.ScreemTcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.ScreemTfilter(c)
	return c:IsSetCard(0xc538) and c:IsType(TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end
function s.ScreemTtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ScreemTfilter,tp,LOCATION_DECK,0,1,nil) end
	e:GetHandler():CreateEffectRelation(e)
end
function s.ScreemToperation(gete)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				if not e:GetHandler():IsRelateToEffect(e) then return end
				gete(e:GetHandler())
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local tc=Duel.SelectMatchingCard(tp,s.ScreemTfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
				if tc then
					if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
						Duel.SendtoHand(tc,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,tc)
					else
						Duel.SSet(tp,tc)
					end
				end
			end
end
function s.roll(min_val, max_val)
	-- 1. 种子初始化 (如果需要)
	if not s.Party_time_random_seed then
		local result = 0
		-- 获取并累加玩家0卡组顶5张卡的Code
		local g0 = Duel.GetDecktopGroup(0, 5)
		if g0 then -- 检查确保获取成功
			local tc0 = g0:GetFirst()
			while tc0 do
				result = result + tc0:GetCode()
				tc0 = g0:GetNext()
			end
			-- g0:DeleteGroup() -- Lua的垃圾回收通常会处理，但显式删除有时被认为更干净
		end

		-- 获取并累加玩家1卡组顶5张卡的Code
		local g1 = Duel.GetDecktopGroup(1, 5)
		if g1 then -- 检查确保获取成功
			 local tc1 = g1:GetFirst()
			while tc1 do
				result = result + tc1:GetCode()
				tc1 = g1:GetNext()
			end
			-- g1:DeleteGroup() -- 同上
		end

		-- 健壮性：防止种子为0 (LCG对种子0可能表现不佳)
		if result == 0 then result = 1 end
		s.Party_time_random_seed = result
	end

	-- 2. 更新伪随机数生成器的状态 (LCG)
	-- 即使输入无效，也更新状态以保持序列的一致性
	s.Party_time_random_seed = (s.Party_time_random_seed * 16807) % 2147484647
	-- 健壮性：防止更新后种子变为0
	if s.Party_time_random_seed == 0 then s.Party_time_random_seed = 1 end

	-- 3. 处理输入参数
	-- 情况 A: 只提供了一个参数 (视为 [1, min_val] 的范围)
	if max_val == nil then
		if min_val == nil then
			Duel.Hint(HINT_MESSAGE, 0, "Party_time_roll Error: Missing arguments.")
			return 1 -- 或者返回错误，或者一个默认值
		end
		max_val = tonumber(min_val)
		min_val = 1 -- 默认最小值为 1
	else
		-- 情况 B: 提供了两个参数
		min_val = tonumber(min_val)
		max_val = tonumber(max_val)
	end

	-- 4. 输入验证
	if min_val == nil or max_val == nil or min_val > max_val then
		Duel.Hint(HINT_MESSAGE, 0, "Party_time_roll Error: Invalid range (min="..tostring(min_val)..", max="..tostring(max_val)..").")
		-- 返回一个合理的值，避免脚本错误
		return (min_val and max_val == nil and min_val >= 1) and 1 or (min_val or 1)
	end

	-- 5. 处理 min == max 的情况
	if min_val == max_val then
		return min_val
	end

	-- 6. 归一化并映射到正确范围 [min_val, max_val]
	-- random_value_normalized 的范围是 [0, 1)
	local random_value_normalized = s.Party_time_random_seed / 2147484647

	-- 正确的计算公式:
	-- range_size 是可能结果的数量 (max - min + 1)
	local range_size = max_val - min_val + 1
	-- 乘以 range_size 得到 [0, range_size)
	-- floor 取整得到 0 到 range_size - 1
	-- 加上 min_val 平移到 [min_val, max_val]
	local result = math.floor(random_value_normalized * range_size) + min_val

	-- 最终健壮性检查 (理论上不需要，但防止浮点数精度问题)
	if result < min_val then result = min_val end
	if result > max_val then result = max_val end

	return result
end
function s.zero_seal_check(tid,e,tct)
	local ct=tct or 1
	local c=e:GetHandler()
	local con=e:GetCondition() or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(e:GetCode())
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetLabel(ct,tid)
	e1:SetCondition(s.zero_seal_con(con))
	e1:SetOperation(s.zero_seal_op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(tid)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(1,0)
	e2:SetCountLimit(1)
	e2:SetLabel(ct)
	e2:SetCondition(function(e)return e:GetHandler():GetFlagEffect(53797144)>=e:GetLabel()end)
	c:RegisterEffect(e2)
	local mt=_G["c"..tid]
	if mt.global_effect then return end
	mt.global_effect=true
	s.zero_seal_effects={}
	local ge0=Effect.GlobalEffect()
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge0:SetCode(EVENT_ADJUST)
	ge0:SetLabel(tid)
	ge0:SetOperation(s.zero_seal_geop)
	Duel.RegisterEffect(ge0,0)
end
function s.zero_seal_con(con)
	return  function(e,...)
				local label=e:GetHandler():GetFlagEffectLabel(53797644) or 0
				return con(e,...) and label>0
			end
end
function s.zero_seal_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct,tid=e:GetLabel()
	local label=c:GetFlagEffectLabel(53797144) or 0
	if label<ct and label>=0 then
		c:ResetFlagEffect(53797144)
		c:RegisterFlagEffect(53797144,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,label+1,aux.Stringid(tid,label+2))
	end
end
function s.zero_seal_geop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(aux.NOT(Card.IsSetCard),0,LOCATION_DECK,LOCATION_DECK,nil,0xa533)
	for rc in aux.Next(rg) do
		local le=s.zero_seal_effects[rc]
		if le and type(le)=="table" then
			for _,v in pairs(le) do v:Reset() end
			rc:ResetFlagEffect(tid)
		end
	end
	local tid=e:GetLabel()
	local g=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(tid)<=0 and c:IsSetCard(0xa533)end,0,LOCATION_DECK,LOCATION_DECK,nil)
	if #g==0 then return end
	local mt=_G["c"..tid]
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(tid,RESET_EVENT+RESETS_STANDARD,0,1)
		local te=tc.zero_seal_effect
		local e1=te:Clone()
		e1:SetDescription(aux.Stringid(tid,1))
		e1:SetCategory(e:GetCategory()|mt.category)
		e1:SetRange(LOCATION_DECK)
		local tg=te:GetTarget() or aux.TRUE
		local op=te:GetOperation()
		e1:SetTarget(s.zero_seal_extg(tg,mt.extg))
		e1:SetOperation(s.zero_seal_exop(op,mt.exop))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=s.Act(tc,e1)
		e2:SetRange(LOCATION_DECK)
		e2:SetLabel(tid)
		e2:SetCost(s.zero_seal_costchk)
		e2:SetOperation(s.zero_seal_costop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		s.zero_seal_effects[tc]={e1,e2}
	end
end
function s.zero_seal_extg(tg,extg)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
				if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) and extg(e,tp,eg,ep,ev,re,r,rp,0) end
				tg(e,tp,eg,ep,ev,re,r,rp,1)
				extg(e,tp,eg,ep,ev,re,r,rp,1)
				Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
			end
end
function s.zero_seal_exop(op,exop)
	return  function(e,tp,...)
				local res=(Duel.GetFlagEffect(tp,s.GetOriginalCode(e:GetHandler()))>0)
				op(e,tp,...)
				if res then return end
				exop(e,tp,...)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetTargetRange(0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
				e1:SetValue(s.zero_seal_efilter)
				local ct=(Duel.GetTurnPlayer()==tp and 1) or 2
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
				Duel.RegisterEffect(e1,tp)
			end
end
function s.zero_seal_efilter(e,re)
	return e:GetOwnerPlayer()==re:GetOwnerPlayer() and not re:GetOwner():IsSetCard(0xa533)
end
function s.zero_seal_costchk(e,te,tp)
	return Duel.IsPlayerAffectedByEffect(tp,e:GetLabel())
end
function s.zero_seal_costop(e,tp,eg,ep,ev,re,r,rp)
	local le={Duel.IsPlayerAffectedByEffect(tp,e:GetLabel())}
	local g=Group.CreateGroup()
	for _,v in pairs(le) do g:AddCard(v:GetOwner()) end
	local tc=s.Select_1(g,tp,aux.Stringid(53797145,14))
	local ce=nil
	for _,v in pairs(le) do if v:GetOwner()==tc then ce=v end end
	ce:UseCountLimit(tp)
	ce:GetHandler():ResetFlagEffect(53797144)
	ce:GetHandler():RegisterFlagEffect(53797144,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,-1,aux.Stringid(53797145,15))
end
