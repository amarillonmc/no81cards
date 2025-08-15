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
		if not sc:IsLocation(LOCATION_MZONE) then return _GetLink(sc) end
		return s.NumNumber(sc:GetLinkMarker(),markers)
	end
	Card.IsLink=function(sc,...)
		if not sc:IsLocation(LOCATION_MZONE) then return _IsLink(sc,...) end
		local t={...}
		for _,v in ipairs(t) do if s.NumNumber(sc:GetLinkMarker(),markers)==v then return true end end
		return false
	end
	Card.IsLinkAbove=function(sc,link)
		if not sc:IsLocation(LOCATION_MZONE) then return _IsLinkAbove(sc,link) end
		if s.NumNumber(sc:GetLinkMarker(),markers)>=link then return true else return false end
	end
	Card.IsLinkBelow=function(sc,link)
		if not sc:IsLocation(LOCATION_MZONE) then return _IsLinkBelow(sc,link) end
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
		if te then
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
--written by purplenightfall
function s.SelectSubGroup(g,tp,f,cancelable,min,max,...)
	local classif,sortf,passf,goalstop,check,params1,params2,params3=table.unpack(s.SubGroupParams)
	min=min or 1
	max=max or #g
	local sg=Group.CreateGroup()
	local fg=Duel.GrabSelectedCard()
	if #fg>max or min>max or #(g+fg)<min then return nil end
	if not check then
		for tc in aux.Next(fg) do
			fg:SelectUnselect(sg,tp,false,false,min,max)
		end
	end
	sg:Merge(fg)
	local mg,iisg,tmp,stop,iter,ctab,rtab,gtab
	--main check
	local params1=params1 or {}
	local params2=params2 or {}
	local params3=params3 or {}
	local finish=(#sg>=min and #sg<=max and f(sg,...))
	while #sg<max do
		mg=g-sg
		iisg=sg:Clone()
		if passf then
			aux.SubGroupCaptured=mg:Filter(passf,nil,table.unpack(params3))
		else
			aux.SubGroupCaptured=Group.CreateGroup()
		end
		ctab,rtab,gtab={},{},{1}
		for tc in aux.Next(mg) do
			ctab[#ctab+1]=tc
		end
		--high to low
		if sortf then
			for i=1,#ctab-1 do
				for j=1,#ctab-1-i do
					if sortf(ctab[j],table.unpack(params2))<sortf(ctab[j+1],table.unpack(params2)) then
						tmp=ctab[j]
						ctab[j]=ctab[j+1]
						ctab[j+1]=tmp
					end
				end
			end
		end
		--classify
		if classif then
			--make similar cards adjacent
			for i=1,#ctab-2 do
				for j=i+2,#ctab do
					if classif(ctab[i],ctab[j],table.unpack(params1)) then
						tmp=ctab[j]
						ctab[j]=ctab[i+1]
						ctab[i+1]=tmp
					end
				end
			end
			--rtab[i]: what category does the i-th card belong to
			--gtab[i]: What is the first card's number in the i-th category
			for i=1,#ctab-1 do
				rtab[i]=#gtab
				if not classif(ctab[i],ctab[i+1],table.unpack(params1)) then
					gtab[#gtab+1]=i+1
				end
			end
			rtab[#ctab]=#gtab
--Debug.Message("Classification resulted in " .. #gtab .. " groups.")
			--iter record all cards' number in sg
			iter={1}
			sg:AddCard(ctab[1])
			while #sg>#iisg and #aux.SubGroupCaptured<#mg do
				stop=#sg>=max
				--prune if too much cards
				if (aux.GCheckAdditional and not aux.GCheckAdditional(sg,c,g,f,min,max,...)) then
					stop=true
				--skip check if no new cards
				elseif #(sg-iisg-aux.SubGroupCaptured)>0 and #sg>=min and #sg<=max and f(sg,...) then
					for sc in aux.Next(sg-iisg) do
						if check then return true end
						aux.SubGroupCaptured:Merge(mg:Filter(classif,nil,sc,table.unpack(params1)))
					end
					stop=goalstop
				end
				local code=iter[#iter]
				--last card isn't in the last category
				if code and code<gtab[#gtab] then
					if stop then
						--backtrack and add 1 card from next category
						iter[#iter]=gtab[rtab[code]+1]
						sg:RemoveCard(ctab[code])
						sg:AddCard(ctab[(iter[#iter])])
					else
						--continue searching forward
						iter[#iter+1]=code+1
						sg:AddCard(ctab[code+1])
					end
				--last card is in the last category
				elseif code then
					if stop or code>=#ctab then
						--clear all cards in the last category
						while #iter>0 and iter[#iter]>=gtab[#gtab] do
							sg:RemoveCard(ctab[(iter[#iter])])
							iter[#iter]=nil
						end
						--backtrack and add 1 card from next category
						local code2=iter[#iter]
						if code2 then
							iter[#iter]=gtab[rtab[code2]+1]
							sg:RemoveCard(ctab[code2])
							sg:AddCard(ctab[(iter[#iter])])
						end
					else
						--continue searching forward
						iter[#iter+1]=code+1
						sg:AddCard(ctab[code+1])
					end
				end
			end
		--classification is essential for efficiency, and this part is only for backup
		else
			iter={1}
			sg:AddCard(ctab[1])
			while #sg>#iisg and #aux.SubGroupCaptured<#mg do
				stop=#sg>=max
				if (aux.GCheckAdditional and not aux.GCheckAdditional(sg,c,g,f,min,max,...)) then
					stop=true
				elseif #(sg-iisg-aux.SubGroupCaptured)>0 and #sg>=min and #sg<=max and f(sg,...) then
					for sc in aux.Next(sg-iisg) do
						if check then return true end
						aux.SubGroupCaptured:AddCard(sc) --Merge(mg:Filter(class,nil,sc))
					end
					stop=goalstop
				end
				if #sg>=max then stop=true end
				local code=iter[#iter]
				if code<#ctab then
					if stop then
						iter[#iter]=nil
						sg:RemoveCard(ctab[code])
					end
					iter[#iter+1]=code+1
					sg:AddCard(ctab[code+1])
				else
					local code2=iter[#iter-1]
					iter[#iter]=nil
					sg:RemoveCard(ctab[code])
					if code2 and code2>0 then
						iter[#iter]=code2+1
						sg:RemoveCard(ctab[code2])
						sg:AddCard(ctab[code2+1])
					end
				end
			end
		end
		--finish searching
		sg=iisg
		local cg=aux.SubGroupCaptured:Clone()
		aux.SubGroupCaptured:Clear()
		cg:Sub(sg)
		finish=(#sg>=min and #sg<=max and f(sg,...))
		if #cg==0 then break end
		local cancel=not finish and cancelable
		local tc=cg:SelectUnselect(sg,tp,finish,cancel,min,max)
		if not tc then break end
		if not fg:IsContains(tc) then
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if #sg==max then finish=true end
			else
				sg:RemoveCard(tc)
			end
		elseif cancelable then
			return nil
		end
	end
	if finish then
		return sg
	else
		return nil
	end
end
function s.Aespire(c,loc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(c:GetOriginalCode())
	e1:SetRange(loc)
	c:RegisterEffect(e1)
	if s.Aespire_Check then return end
	s.Aespire_Check=true
	local ge0=Effect.GlobalEffect()
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge0:SetCode(EVENT_ADJUST)
	ge0:SetOperation(s.Aespire_geop)
	Duel.RegisterEffect(ge0,0)
	local g1=Group.CreateGroup()
	g1:KeepAlive()
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
	ge1:SetLabelObject(g1)
	ge1:SetOperation(s.Aespire_Chat_MergedDelayEventCheck1)
	Duel.RegisterEffect(ge1,0)
	local ge2=ge1:Clone()
	ge2:SetCode(EVENT_CHAIN_END)
	ge2:SetOperation(s.Aespire_Chat_MergedDelayEventCheck2)
	Duel.RegisterEffect(ge2,0)
end
function s.Aespire_Chat_M_cfilter(c)
	local re=c:GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT)
	return re and re:GetHandler() and re:GetHandler():IsOriginalEffectProperty(s.Aesp_efffilter2(re))
end
function s.Aespire_Chat_MergedDelayEventCheck1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
--Debug.Message(type(s.Aespire_Chat_M_cfilter))
	g:Merge(eg:Filter(s.Aespire_Chat_M_cfilter,nil))
	if #g>0 and Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+53780004,re,r,rp,ep,ev)
		g:Clear()
	end
end
function s.Aespire_Chat_MergedDelayEventCheck2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+53780004,re,r,rp,ep,ev)
		g:Clear()
	end
end
function s.Aespire_geop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(53780000)<=0 end,0,0xff,0xff,nil)
	g:ForEach(Card.RegisterFlagEffect,53780000,0,0,0)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(53780000,0,0,0)
		local e1_1=Effect.CreateEffect(tc)
		e1_1:SetDescription(aux.Stringid(53780001,0))
		e1_1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1_1:SetType(EFFECT_TYPE_IGNITION)
		e1_1:SetRange(LOCATION_MZONE)
		e1_1:SetCondition(s.Aesp_Dpsk_con(CATEGORY_SPECIAL_SUMMON))
		e1_1:SetTarget(s.Aesp_Dpsk_tg)
		e1_1:SetOperation(s.Aesp_Dpsk_op)
		tc:RegisterEffect(e1_1,true)
		local e1_2=Effect.GlobalEffect()
		e1_2:SetType(EFFECT_TYPE_FIELD)
		e1_2:SetCode(EFFECT_ACTIVATE_COST)
		e1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1_2:SetTargetRange(1,1)
		e1_2:SetLabelObject(e1_1)
		e1_2:SetTarget(s.Aesp_costtg)
		e1_2:SetCost(s.Aesp_Dpsk_costchk)
		e1_2:SetOperation(s.Aesp_Dpsk_costop)
		Duel.RegisterEffect(e1_2,0)
		local e2_1=Effect.CreateEffect(tc)
		e2_1:SetDescription(aux.Stringid(53780002,0))
		e2_1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e2_1:SetType(EFFECT_TYPE_IGNITION)
		e2_1:SetRange(LOCATION_HAND)
		e2_1:SetCondition(s.Aesp_Dpsk_con(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DRAW))
		e2_1:SetTarget(s.Aesp_Gmn_tg)
		e2_1:SetOperation(s.Aesp_Gmn_op)
		tc:RegisterEffect(e2_1,true)
		local e2_2=e1_2:Clone()
		e2_2:SetLabelObject(e2_1)
		e2_2:SetCost(s.Aesp_Gmn_costchk)
		e2_2:SetOperation(s.Aesp_Gmn_costop)
		Duel.RegisterEffect(e2_2,0)
		local e3_1=Effect.CreateEffect(tc)
		e3_1:SetDescription(aux.Stringid(53780003,0))
		e3_1:SetCategory(CATEGORY_TOGRAVE)
		e3_1:SetType(EFFECT_TYPE_IGNITION)
		e3_1:SetRange(LOCATION_GRAVE)
		e3_1:SetCondition(s.Aesp_Dpsk_con(CATEGORY_TOGRAVE+CATEGORY_DECKDES))
		e3_1:SetTarget(s.Aesp_Grk_tg)
		e3_1:SetOperation(s.Aesp_Grk_op)
		tc:RegisterEffect(e3_1,true)
		local e3_2=e1_2:Clone()
		e3_2:SetLabelObject(e3_1)
		e3_2:SetCost(s.Aesp_Grk_costchk)
		e3_2:SetOperation(s.Aesp_Grk_costop)
		Duel.RegisterEffect(e3_2,0)
		local e4_1=Effect.CreateEffect(tc)
		e4_1:SetDescription(aux.Stringid(53780004,0))
		e4_1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e4_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e4_1:SetCode(EVENT_CUSTOM+53780004)
		e4_1:SetProperty(EFFECT_FLAG_DELAY)
		e4_1:SetRange(LOCATION_MZONE)
		--e4_1:SetCondition(s.Aesp_Chat_con)
		e4_1:SetTarget(s.Aesp_Chat_tg)
		e4_1:SetOperation(s.Aesp_Chat_op)
		tc:RegisterEffect(e4_1,true)
		local e4_2=e1_2:Clone()
		e4_2:SetLabelObject(e4_1)
		e4_2:SetCost(s.Aesp_Chat_costchk)
		e4_2:SetOperation(s.Aesp_Chat_costop)
		Duel.RegisterEffect(e4_2,0)
		local e5_1=Effect.CreateEffect(tc)
		e5_1:SetDescription(aux.Stringid(53780005,0))
		e5_1:SetCategory(CATEGORY_TOHAND)
		e5_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e5_1:SetCode(EVENT_TO_HAND)
		e5_1:SetProperty(EFFECT_FLAG_DELAY)
		e5_1:SetRange(LOCATION_HAND)
		e5_1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		e5_1:SetCondition(s.Aesp_Qwen_con)
		e5_1:SetTarget(s.Aesp_Qwen_tg)
		e5_1:SetOperation(s.Aesp_Qwen_op)
		tc:RegisterEffect(e5_1,true)
		local e5_2=e1_2:Clone()
		e5_2:SetLabelObject(e5_1)
		e5_2:SetCost(s.Aesp_Qwen_costchk)
		e5_2:SetOperation(s.Aesp_Qwen_costop)
		Duel.RegisterEffect(e5_2,0)
		local e6_1=Effect.CreateEffect(tc)
		e6_1:SetDescription(aux.Stringid(53780006,0))
		e6_1:SetCategory(CATEGORY_DECKDES)
		e6_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e6_1:SetCode(EVENT_TO_GRAVE)
		e6_1:SetProperty(EFFECT_FLAG_DELAY)
		e6_1:SetRange(LOCATION_GRAVE)
		e6_1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		e6_1:SetCondition(s.Aesp_Cld_con)
		e6_1:SetTarget(s.Aesp_Cld_tg)
		e6_1:SetOperation(s.Aesp_Cld_op)
		tc:RegisterEffect(e6_1,true)
		local e6_2=e1_2:Clone()
		e6_2:SetLabelObject(e6_1)
		e6_2:SetCost(s.Aesp_Cld_costchk)
		e6_2:SetOperation(s.Aesp_Cld_costop)
		Duel.RegisterEffect(e6_2,0)
	end
end
function s.Aesp_costtg(e,te,tp)
	return te==e:GetLabelObject() and te:GetHandler()==e:GetLabelObject():GetHandler()
end
function s.Aesp_costchk(e,te,tp)
	return e:GetLabelObject():GetHandler():IsRace(RACE_CYBERSE) and e:GetLabelObject():GetHandler():IsType(TYPE_EFFECT)
end
function s.Aesp_Dpsk_acfilter(c,e,tp)
	return c:IsHasEffect(53780001) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.Aesp_Dpsk_spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c,e,tp)
end
function s.Aesp_Dpsk_costchk(e,te,tp)
	return s.Aesp_costchk(e,te,tp) and Duel.IsExistingMatchingCard(s.Aesp_Dpsk_acfilter,tp,LOCATION_GRAVE,0,1,e:GetLabelObject():GetHandler(),e:GetLabelObject(),tp)
end
function s.Aesp_Dpsk_costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.Aesp_Dpsk_acfilter,tp,LOCATION_GRAVE,0,1,1,e:GetLabelObject():GetHandler(),e:GetLabelObject(),tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.Aesp_Dpsk_spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_CYBERSE) and c:IsFaceupEx()
end
function s.Aesp_efffilter(ctg)
	return function(e) return e:GetCategory()&ctg>0 and e:IsActivated() end
end
function s.Aesp_Dpsk_cfilter(c,ctg)
	return c:IsOriginalEffectProperty(s.Aesp_efffilter(ctg)) and c:IsFaceupEx()
end
function s.Aesp_Dpsk_con(ctg)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return Duel.IsExistingMatchingCard(s.Aesp_Dpsk_cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,ctg)
			end
end
function s.Aesp_Dpsk_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function s.Aesp_Dpsk_op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.Aesp_Dpsk_spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.Aesp_Gmn_thfilter(c)
	return c:IsSetCard(0x5537) and c:IsAbleToHand() and not c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.Aesp_Gmn_acfilter(c)
	return c:IsHasEffect(53780002) and c:IsAbleToRemoveAsCost()
end
function s.Aesp_Gmn_costchk(e,te,tp)
	return s.Aesp_costchk(e,te,tp) and Duel.IsExistingMatchingCard(s.Aesp_Gmn_acfilter,tp,LOCATION_MZONE,0,1,e:GetLabelObject():GetHandler())
end
function s.Aesp_Gmn_costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.Aesp_Gmn_acfilter,tp,LOCATION_MZONE,0,1,1,e:GetLabelObject():GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.Aesp_Gmn_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.Aesp_Gmn_thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.Aesp_Gmn_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.Aesp_Gmn_thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.Aesp_Grk_acfilter(c)
	return c:IsHasEffect(53780003) and c:IsAbleToRemoveAsCost()
end
function s.Aesp_Grk_costchk(e,te,tp)
	return s.Aesp_costchk(e,te,tp) and Duel.IsExistingMatchingCard(s.Aesp_Grk_acfilter,tp,LOCATION_HAND,0,1,e:GetLabelObject():GetHandler())
end
function s.Aesp_Grk_costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.Aesp_Grk_acfilter,tp,LOCATION_HAND,0,1,1,e:GetLabelObject():GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.Aesp_Grk_tgfilter(c)
	return c:IsSetCard(0x5537) and c:IsAbleToGrave()
end
function s.Aesp_Grk_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.Aesp_Grk_tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.Aesp_Grk_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.Aesp_Grk_tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function s.Aesp_Chat_costchk(e,te,tp)
	return s.Aesp_costchk(e,te,tp) and Duel.IsExistingMatchingCard(s.Aesp_Chat_acfilter,tp,LOCATION_HAND,0,1,e:GetLabelObject():GetHandler())
end
function s.Aesp_Chat_costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.Aesp_Chat_acfilter,tp,LOCATION_HAND,0,1,1,e:GetLabelObject():GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.Aesp_efffilter2(re)
	return function(e) return e==re end
end
--[[function s.Aesp_Chat_cfilter(c)
	local re=c:GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT)
	return re and re:GetHandler() and re:GetHandler():IsOriginalEffectProperty(s.Aesp_efffilter2(re))
end
function s.Aesp_Chat_con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.Aesp_Chat_cfilter,1,nil)
end]]--
function s.Aesp_Chat_acfilter(c)
	return c:IsHasEffect(53780004) and c:IsAbleToRemoveAsCost()
end
function s.Aesp_Chat_spfilter(c,e,tp,check)
	return c:IsSetCard(0x5537) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (check or Duel.IsExistingMatchingCard(s.Aesp_Chat_acfilter,tp,LOCATION_HAND,0,1,c))
end
function s.Aesp_Chat_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	for tc in aux.Next(eg) do loc=loc|tc:GetSummonLocation() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.Aesp_Chat_spfilter,tp,loc,0,1,nil,e,tp) end
	e:SetLabel(loc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function s.Aesp_Chat_op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.Aesp_Chat_spfilter),tp,e:GetLabel(),0,1,1,nil,e,tp,true)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.Aesp_Qwen_cfilter(c,re)
	return re and re:GetHandler() and re:GetHandler():IsOriginalEffectProperty(s.Aesp_efffilter2(re)) and c:IsReason(REASON_EFFECT)
end
function s.Aesp_Qwen_con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.Aesp_Qwen_cfilter,1,nil,re)
end
function s.Aesp_Qwen_thfilter(c)
	return c:IsFaceupEx() and (c:IsSetCard(0x5537) or c:IsRace(RACE_CYBERSE)) and c:IsAbleToHand()
end
function s.Aesp_Qwen_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.Aesp_Qwen_thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.Aesp_Qwen_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.Aesp_Qwen_thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.Aesp_Qwen_acfilter(c,tp)
	return c:IsHasEffect(53780005) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.Aesp_Qwen_thfilter,tp,LOCATION_GRAVE,0,1,c)
end
function s.Aesp_Qwen_costchk(e,c,tp)
--Debug.Message(Duel.IsExistingMatchingCard(s.Aesp_Qwen_acfilter,tp,LOCATION_GRAVE,0,1,e:GetLabelObject():GetHandler(),tp))
	return s.Aesp_costchk(e,te,tp) and Duel.IsExistingMatchingCard(s.Aesp_Qwen_acfilter,tp,LOCATION_GRAVE,0,1,e:GetLabelObject():GetHandler(),tp)
end
function s.Aesp_Qwen_costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.Aesp_Qwen_acfilter,tp,LOCATION_GRAVE,0,1,1,e:GetLabelObject():GetHandler(),tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.Aesp_Cld_cfilter(c,re)
	return re and re:GetHandler() and re:GetHandler():IsOriginalEffectProperty(s.Aesp_efffilter2(re)) and c:IsReason(REASON_EFFECT+REASON_COST) and re:IsActivated()
end
function s.Aesp_Cld_con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.Aesp_Cld_cfilter,1,nil,re)
end
function s.Aesp_Cld_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function s.Aesp_Cld_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
end
--[[function s.Aesp_Cld_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then
		if not g or #g<3 then return false end
		for tc in aux.Next(g) do if not (tc:IsAbleToGrave() or tc:IsAbleToRemove()) then return false end end
		return true
	end
end
function s.Aesp_Cld_op(e,tp,eg,ep,ev,re,r,rp)
	local ct=3
	while Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 or ct>0 do
		Duel.ConfirmDecktop(tp,1)
		local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
		if tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		ct=ct-1
	end
end]]--
function s.Aesp_Cld_acfilter(c)
	return c:IsHasEffect(53780006) and c:IsAbleToRemoveAsCost()
end
function s.Aesp_Cld_costchk(e,te,tp)
	return s.Aesp_costchk(e,te,tp) and Duel.IsExistingMatchingCard(s.Aesp_Cld_acfilter,tp,LOCATION_MZONE,0,1,e:GetLabelObject():GetHandler())
end
function s.Aesp_Cld_costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.Aesp_Cld_acfilter,tp,LOCATION_MZONE,0,1,1,e:GetLabelObject():GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.Checkmate_Fairy(c)
	if not Checkmate_Fairy_check then
		Checkmate_Fairy_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(s.Checkmate_geop)
		Duel.RegisterEffect(ge0,0)
		Checkmate_GetFirstTarget=Duel.GetFirstTarget
		Checkmate_GetChainInfo=Duel.GetChainInfo
		Checkmate_GetTargetsRelateToChain=Duel.GetTargetsRelateToChain
	end
end
function s.Checkmate_geop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(0,0xff,0xff)
	for tc in aux.Next(g) do
		local le={tc:GetCardRegistered(nil)}
		for _,v in pairs(le) do
			if v:IsActivated() then
				local tg=v:GetTarget() or aux.TRUE
				v:SetTarget(s.Checkmate_chtg(tg))
			end
		end
	end
	local f1=Card.RegisterEffect
	Card.RegisterEffect=function(sc,se,bool)
		if se:IsActivated() then
			local tg=se:GetTarget() or aux.TRUE
			se:SetTarget(s.Checkmate_chtg(tg))
		end
		return f1(sc,se,bool)
	end
	e:Reset()
end
function s.Checkmate_chtg(_tg)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return _tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
				if chk==0 then return _tg(e,tp,eg,ep,ev,re,r,rp,0) end
				local tg=Group.CreateGroup()
				local f=Duel.SetTargetCard
				Duel.SetTargetCard=function(targets)
					tg=Group.__add(tg,targets)
					return f(targets)
				end
				_tg(e,tp,eg,ep,ev,re,r,rp,1)
				Duel.SetTargetCard=f
				local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
				local sg=g:Filter(Card.IsCanBeEffectTarget,nil,e)
				if not e:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and Duel.GetFlagEffect(1-tp,53798004)>0 and #g>0 and #g==#sg then
					local pro1,pro2=e:GetProperty()
					e:SetProperty(pro1|EFFECT_FLAG_CARD_TARGET,pro2)
					Duel.ClearTargetCard()
					Duel.SetTargetCard(g)
					if #tg>0 then
						local ev0=Duel.GetCurrentChain()
						tg:KeepAlive()
						tg:ForEach(Card.RegisterFlagEffect,53798004,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
						e1:SetCode(EVENT_CHAIN_SOLVING)
						e1:SetCountLimit(1)
						e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
						e1:SetLabelObject(tg)
						e1:SetOperation(s.Checkmate_cheaton)
						e1:SetReset(RESET_CHAIN)
						Duel.RegisterEffect(e1,tp)
					end
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e2:SetCode(EVENT_CHAIN_END)
					e2:SetCountLimit(1)
					e2:SetLabelObject(e)
					e2:SetOperation(s.Checkmate_tgoff)
					e2:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e2,tp)
				end
			end
end
function s.Checkmate_tgoff(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() then return end
	local pro1,pro2=e:GetLabelObject():GetProperty()
	e:GetLabelObject():SetProperty(pro1&(~EFFECT_FLAG_CARD_TARGET),pro2)
end
function s.Checkmate_cheaton(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local pro1,pro2=re:GetProperty()
		re:SetProperty(pro1|EFFECT_FLAG_CARD_TARGET,pro2)
	end
	local op=re:GetOperation()
	re:SetOperation(s.Checkmate_chop(op,e:GetLabelObject()))
	local ev0=Duel.GetCurrentChain()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(s.Checkmate_cheatoff(op))
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.Checkmate_cheatoff(_op)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				Duel.GetFirstTargetCheck=mate_GetFirstTarget
				Duel.GetChainInfo=Checkmate_GetChainInfo
				Duel.GetTargetsRelateToChain=Checkmate_GetTargetsRelateToChain
				re:SetOperation(_op)
				local pro1,pro2=re:GetProperty()
				re:SetProperty(pro1&(~EFFECT_FLAG_CARD_TARGET),pro2)
			end
end
function s.Checkmate_chop(_op,_g)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				Duel.GetTargetsRelateToChain=function()
					return _g:Filter(function(c)return c:GetFlagEffect(53798004)>0 end,nil)
				end
				Duel.GetFirstTarget=function()
					local gt={}
					for tc in aux.Next(Duel.GetTargetsRelateToChain()) do table.insert(gt,tc) end
					return table.unpack(gt)
				end
				Duel.GetChainInfo=function(chainc,...)
					if chainc==0 then
						local infos,kotas={...},{}
						for _,info in pairs(infos) do
							if info==CHAININFO_TARGET_CARDS then table.insert(kotas,_g)
							else table.insert(kotas,Checkmate_GetChainInfo(0,info)) end
						end
						return table.unpack(kotas)
					else return Checkmate_GetChainInfo(chainc,...) end
				end
				_op(e,tp,eg,ep,ev,re,r,rp)
			end
end
