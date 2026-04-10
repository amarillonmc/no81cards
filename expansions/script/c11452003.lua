-- 施瓦丁格与烬梦匣
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)

	-- ①：自定义融合召唤手续
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(s.fuscon)
	e1:SetOperation(s.fusop)
	c:RegisterEffect(e1)

	-- ②：对方进行强制选择的诱发触发
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCondition(s.chcon)
	e0:SetOperation(s.chop)
	c:RegisterEffect(e0)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CUSTOM+id)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_EVENT_PLAYER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.efftg)
	e4:SetOperation(s.effop)
	c:RegisterEffect(e4)
end

function Group.ForEach(group,func,...)
	if aux.GetValueType(group)=="Group" and group:GetCount()>0 then
		local d_group=group:Clone()
		for tc in aux.Next(d_group) do
			func(tc,...)
		end
	end
end
-- ==========================================================
-- 融合召唤手续与素材拦截处理
-- ==========================================================

-- 判断当前组是否满足“属性不同的怪兽×2只以上”
function s.CheckGroup(sg)
	if sg:GetCount() < 2 then return false end
	-- YGOPro自带的二分图匹配算法，完美验证每个怪兽能否对应不同的属性
	return sg:GetClassCount(Card.GetFusionAttribute)>=2
end

function s.CheckRecursive(mg, sg, cards, idx, minc, maxc)
	if sg:GetCount() >= minc and s.CheckGroup(sg) then return true end
	if sg:GetCount() >= maxc then return false end
	if idx > #cards then return false end

	for i = idx, #cards do
		local c = cards[i]
		if not sg:IsContains(c) then
			sg:AddCard(c)
			if s.CheckRecursive(mg, sg, cards, i + 1, minc, maxc) then
				sg:RemoveCard(c)
				return true
			end
			sg:RemoveCard(c)
		end
	end
	return false
end

function s.fuscon(e,g,gc,chkfnf)
	local c = e:GetHandler()
	if g==nil then return true end
	local mg = g:Filter(Card.IsCanBeFusionMaterial, nil, c)
	if gc then
		if not mg:IsContains(gc) then return false end
		Duel.SetSelectedCard(Group.FromCards(gc))
	end
	local cards = {}
	for tc in aux.Next(mg) do table.insert(cards, tc) end
	return s.CheckRecursive(mg, Group.CreateGroup(), cards, 1, 2, 99)
end

function s.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local c = e:GetHandler()
	local mg = eg:Filter(Card.IsCanBeFusionMaterial, nil, c)
	local sg = Group.CreateGroup()
	if gc then 
		sg:AddCard(gc)
		mg:RemoveCard(gc)
	end
	
	local cards = {}
	for tc in aux.Next(mg) do table.insert(cards, tc) end
	
	while true do
		local finishable = (sg:GetCount() >= 2) and s.CheckGroup(sg)
		local valid_additions = Group.CreateGroup()
		for i = 1, #cards do
			local tc = cards[i]
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if s.CheckRecursive(mg, sg, cards, 1, 2, 99) then
					valid_additions:AddCard(tc)
				end
				sg:RemoveCard(tc)
			end
		end
		
		if valid_additions:GetCount() == 0 then
			if finishable then break else return false end
		end
		
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FMATERIAL)
		local tc = Group.SelectUnselect(valid_additions, sg, tp, finishable, false, 1, 1)
		if not tc then break end
		if sg:IsContains(tc) then sg:RemoveCard(tc) else sg:AddCard(tc) end
	end
	
	Duel.SetFusionMaterial(sg)
	

	-- 【核心 2】：主动一波流除外，替代原本的送墓操作
	if Duel.Remove(sg, POS_FACEUP, REASON_EFFECT+REASON_MATERIAL+REASON_FUSION+REASON_TEMPORARY) > 0 then
		-- 【核心 1】：注册 EFFECT_SEND_REPLACE，完全拦截系统原生的素材移动
		sg:ForEach(Card.RegisterFlagEffect, id, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 1)
		local e_rep = Effect.CreateEffect(c)
		e_rep:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e_rep:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e_rep:SetCode(EFFECT_SEND_REPLACE)
		e_rep:SetTarget(function(e) return e:GetLabel()==0 end)
		e_rep:SetValue(function(e,tc) e:SetLabel(100) return tc:GetFlagEffect(id)~=0 end)
		e_rep:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e_rep, tp)
		local fid = c:GetFieldID()
		local og1 = Duel.GetOperatedGroup()
		if og1:IsExists(s.retfilter2, 1, nil, tp, LOCATION_HAND) then Duel.ShuffleHand(tp) end
		if og1:IsExists(s.retfilter2, 1, nil, 1-tp, LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
		
		local og = Group.__band(og1, sg):Filter(s.rffilter, nil)
		if og and #og > 0 then
			for oc in aux.Next(og) do
				oc:RegisterFlagEffect(id+1, RESET_EVENT+RESETS_STANDARD, 0, 1, fid)
				-- Minimun mod start: adding client hint, setting initial display to "Count: 3"
				oc:RegisterFlagEffect(id+2, RESET_EVENT+RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 1, aux.Stringid(11451718, 7)) 
				-- Minimun mod end
			end
			og:KeepAlive()
			
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetLabel(fid)
			e1:SetLabelObject(og)
			e1:SetCondition(s.retcon)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1, tp)
			
			local e2 = e1:Clone()
			e2:SetCode(EVENT_CHAIN_NEGATED)
			Duel.RegisterEffect(e2, tp)
		end
	end
end

-- ==========================================================
-- 延时归还与卡格防溢出处理算法 (沿用你的成熟方案并拓展全区域)
-- ==========================================================
function s.rffilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end

function s.retfilter2(c,p,loc)
	if (c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousTypeOnField()&TYPE_EQUIP>0) or c:IsPreviousLocation(LOCATION_FZONE) then return false end
	return c:IsPreviousControler(p) and c:IsPreviousLocation(loc)
end

function s.fselect2(g,pft)
	return g:FilterCount(Card.IsPreviousLocation,nil,LOCATION_PZONE)<=pft
end

function s.filter6(c,e)
	return c:GetFlagEffectLabel(id+1)==e:GetLabel()
end

function s.returntofield(tc)
	local p = tc:GetPreviousControler()
	if tc:IsPreviousLocation(LOCATION_FZONE) then
		local gc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
		if gc then
			Duel.SendtoGrave(gc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,p,p,LOCATION_FZONE,POS_FACEUP,true)
		return
	end
	if tc:GetPreviousTypeOnField()&TYPE_EQUIP>0 then
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	else
		Duel.ReturnToField(tc)
	end
end

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g = e:GetLabelObject()
	if not g:IsExists(s.filter6, 1, nil, e) then
		g:DeleteGroup()
		e:Reset()
		return false
	end
	return Duel.GetCurrentChain()==1
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g = e:GetLabelObject()
	local sg = g:Filter(s.filter6, nil, e)
	local rep_tc = sg:GetFirst()
	local flag = rep_tc:GetFlagEffectLabel(id+2)
	
	if not flag then return end
	
	if flag >= 3 then
		g:DeleteGroup()
		local ft,mg,pft,pmg={},{},{},{}
		ft[1]=Duel.GetLocationCount(tp,LOCATION_MZONE)
		ft[2]=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		ft[3]=Duel.GetLocationCount(tp,LOCATION_SZONE)
		ft[4]=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
		pft[3],pft[4]=0,0
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) then pft[3]=pft[3]+1 end
		if Duel.CheckLocation(tp,LOCATION_PZONE,1) then pft[3]=pft[3]+1 end
		if Duel.CheckLocation(1-tp,LOCATION_PZONE,0) then pft[4]=pft[4]+1 end
		if Duel.CheckLocation(1-tp,LOCATION_PZONE,1) then pft[4]=pft[4]+1 end
		
		mg[1]=sg:Filter(s.retfilter2,nil,tp,LOCATION_MZONE)
		mg[2]=sg:Filter(s.retfilter2,nil,1-tp,LOCATION_MZONE)
		mg[3]=sg:Filter(s.retfilter2,nil,tp,LOCATION_SZONE)
		mg[4]=sg:Filter(s.retfilter2,nil,1-tp,LOCATION_SZONE)
		pmg[3]=sg:Filter(s.retfilter2,nil,tp,LOCATION_PZONE)
		pmg[4]=sg:Filter(s.retfilter2,nil,1-tp,LOCATION_PZONE)
		
		-- 场上格子防溢出选取
		for i=1,2 do
			if #mg[i]>ft[i] then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3)) -- "请选择要归还的卡"
				local tg=mg[i]:Select(tp,ft[i],ft[i],nil)
				for tc in aux.Next(tg) do s.returntofield(tc) end
				sg:Sub(tg)
			end
		end
		for i=3,4 do
			if #mg[i]>ft[i] then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
				local ct=math.min(#(mg[i]-pmg[i])+pft[i],ft[i])
				local tg=mg[i]:SelectSubGroup(tp,s.fselect2,false,ct,ct,pft[i])
				local ptg=tg:Filter(Card.IsPreviousLocation,nil,LOCATION_PZONE)
				for tc in aux.Next(ptg) do s.returntofield(tc) end
				for tc in aux.Next(tg-ptg) do s.returntofield(tc) end
				sg:Sub(tg)
			elseif #pmg[i]>pft[i] then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
				local tg=pmg[i]:Select(tp,pft[i],pft[i],nil)
				for tc in aux.Next(tg) do s.returntofield(tc) end
				sg:Sub(tg)
			end
		end
		
		-- 灵摆区归还
		local psg=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_PZONE)
		for tc in aux.Next(psg) do s.returntofield(tc) end
		
		-- 其他区域(卡组/额外/手卡/墓地)及未被选中的溢出卡归还
		for tc in aux.Next(sg-psg) do
			local ploc = tc:GetPreviousLocation()
			if ploc & LOCATION_ONFIELD > 0 then
				s.returntofield(tc)
			elseif ploc == LOCATION_HAND then
				Duel.SendtoHand(tc, tc:GetPreviousControler(), REASON_EFFECT)
			elseif ploc == LOCATION_DECK then
				Duel.SendtoDeck(tc, tc:GetPreviousControler(), 2, REASON_EFFECT)
			elseif ploc == LOCATION_EXTRA then
				if tc:IsPreviousPosition(POS_FACEUP) then
					Duel.SendtoExtraP(tc, tc:GetPreviousControler(), REASON_EFFECT)
				else
					Duel.SendtoDeck(tc, tc:GetPreviousControler(), 0, REASON_EFFECT)
				end
			elseif ploc == LOCATION_GRAVE then
				Duel.SendtoGrave(tc, REASON_EFFECT+REASON_RETURN)
			else
				Duel.SendtoGrave(tc, REASON_RULE+REASON_RETURN)
			end
		end
		e:Reset()
	else
		-- 连锁计数未满，计数+1
		flag = flag + 1
		-- Minimun mod start: Update hint by re-registering
		for oc in aux.Next(sg) do
			oc:ResetFlagEffect(id+2) -- Mandatory reset before changing hint display
			-- Calculate countdown string ID: Stringid(card_id, countdown_num)
			oc:RegisterFlagEffect(id+2, RESET_EVENT+RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, flag, aux.Stringid(11451718, flag + 6))
		end
		-- Minimun mod end
	end
end

-- ==========================================================
-- 对方强制选择项逻辑
-- ==========================================================

function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	-- 移交权限，让对方(1-tp)进行决断
	Duel.RaiseSingleEvent(c, EVENT_CUSTOM+id, re, r, 1-tp, 1-tp, 0)
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 此处的 tp 即为对方玩家
	if chk==0 then return true end 
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EFFECT)
	-- id,1 为双方送墓+检索；id,2 为双方特召+减伤
	local op = Duel.SelectOption(tp, aux.Stringid(id, 0), aux.Stringid(id, 1))
	e:SetLabel(op)

	-- 严格根据选项注册 Category 和 OperationInfo
	if op == 0 then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, PLAYER_ALL, LOCATION_ONFIELD+LOCATION_DECK)
		Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, PLAYER_ALL, LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, PLAYER_ALL, LOCATION_HAND+LOCATION_GRAVE)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op = e:GetLabel()
	
	if op == 0 then
		-- ●双方尽可能把自身场上1张卡以及自身卡组上面3张卡送去墓地...
		local g = Group.CreateGroup()
		for p=0, 1 do
			local fg = Duel.GetFieldGroup(p, LOCATION_ONFIELD, 0)
			if #fg > 0 then
				Duel.Hint(HINT_SELECTMSG, p, HINTMSG_TOGRAVE)
				g:Merge(fg:Select(p, 1, 1, nil))
			end
			local deckg = Duel.GetDecktopGroup(p, 3)
			if #deckg > 0 then
				g:Merge(deckg)
			end
		end
		
		if #g > 0 then
			Duel.SendtoGrave(g, REASON_EFFECT)
			
			-- ...从那之中选1张加入手卡。
			for p=0, 1 do
				-- 必须从刚才送去墓地且原本归属该玩家的卡中选
				local og = g:Filter(Card.IsLocation, nil, LOCATION_GRAVE):Filter(Card.IsPreviousControler, nil, p)
				if #og > 0 and Duel.IsPlayerCanSendtoHand(p) then
					Duel.Hint(HINT_SELECTMSG, p, HINTMSG_ATOHAND)
					local hg = og:Select(p, 1, 1, nil)
					if #hg > 0 then
						Duel.SendtoHand(hg, nil, REASON_EFFECT)
					end
				end
			end
		end
		
	else
		-- ●双方尽可能从自身的手卡·墓地各把1只怪兽特殊召唤...
		local spg_all = Group.CreateGroup()
		
		for p = 0, 1 do
			local ft = Duel.GetLocationCount(p, LOCATION_MZONE)
			if ft > 0 then
				local hg = Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned, p, LOCATION_HAND, 0, nil, e, 0, p, false, false)
				local gg = Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned, p, LOCATION_GRAVE, 0, nil, e, 0, p, false, false)
				
				if ft >= 2 and #hg > 0 and #gg > 0 then
					-- 场地方够，且手卡墓地都有资源，必须各选1只
					Duel.Hint(HINT_SELECTMSG, p, HINTMSG_SPSUMMON)
					local sg1 = hg:Select(p, 1, 1, nil)
					Duel.Hint(HINT_SELECTMSG, p, HINTMSG_SPSUMMON)
					local sg2 = gg:Select(p, 1, 1, nil)
					spg_all:Merge(sg1)
					spg_all:Merge(sg2)
				else
					-- 场地只够1只，或者某个区域没卡，直接合并后让玩家点选
					local avail = Group.CreateGroup()
					avail:Merge(hg)
					avail:Merge(gg)
					if #avail > 0 then
						Duel.Hint(HINT_SELECTMSG, p, HINTMSG_SPSUMMON)
						spg_all:Merge(avail:Select(p, 1, 1, nil))
					end
				end
			end
		end
		
		if #spg_all > 0 then
			-- 使用 Step 保证多张卡可以分配到双方各自的场上，而不是塞给同一个人
			for tc in aux.Next(spg_all) do
				local owner = tc:GetOwner()
				Duel.SpecialSummonStep(tc, 0, owner, owner, false, false, POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
		end
		
		-- ...这个回合，双方受到的全部伤害变成一半。(涵盖效伤与战伤)
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1, 1)
		e1:SetValue(s.damval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1, tp)
	end
end

-- 伤害减半公式
function s.damval(e, re, val, r, rp, rc)
	return math.ceil(val / 2)
end