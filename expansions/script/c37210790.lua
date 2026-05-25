local s,id=GetID()
function s.initial_effect(c)
	-- 这个卡名的①②效果1回合各能使用1次。
	aux.AddCodeList(c,22702055)
	-- ①：自己·对方的回合，手卡的这张卡是持续公开的场合才能发动。这张卡特殊召唤。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- ②：这张卡召唤·特殊召唤的场合才能发动。从卡组·墓地把1张「海（code为22702055）」加入手卡或在自己的场上盖放或表侧表示放置。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.umitg)
	e2:SetOperation(s.umiop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

-- ==================== 效果① ====================
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	-- 发动条件：这张卡处于公开状态
	return e:GetHandler():IsPublic()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 附加效果：在当作水属性同调怪兽的同调素材的场合，可以当作调整以外的怪兽使用
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_NONTUNER)
		e1:SetValue(s.ntval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function s.ntval(e,c)
	-- c 存在时，判定其是否为水属性同调怪兽
	return c==nil or c:IsAttribute(ATTRIBUTE_WATER)
end

-- ==================== 效果② ====================
function s.umifilter(c,tp)
	-- 精确匹配「海」的密码（22702055）
	if not c:IsCode(22702055) then return false end
	local b1 = c:IsAbleToHand()
	local b2 = c:IsSSetable()
	local b3 = true -- 场地魔法始终可以尝试表侧表示放置到场地区域
	return b1 or b2 or b3
end
function s.umitg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.umifilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.umiop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	-- 从卡组或墓地选择1张「海」
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.umifilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1 = tc:IsAbleToHand()
		local b2 = tc:IsSSetable()
		local b3 = true
		
		-- 构建玩家的选项列表
		local op={}
		local opval={}
		if b1 then
			table.insert(op,1190) -- "加入手卡"
			table.insert(opval,1)
		end
		if b2 then
			table.insert(op,1153) -- "盖放"
			table.insert(opval,2)
		end
		if b3 then
			table.insert(op,aux.Stringid(id,2)) -- "表侧表示放置"（需在数据库的该卡条目下补充第3个提示字符串）
			table.insert(opval,3)
		end
		
		if #op==0 then return end
		local sel=Duel.SelectOption(tp,table.unpack(op))+1
		local choice=opval[sel]
		
		-- 执行所选项的操作
		if choice==1 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		elseif choice==2 then
			Duel.SSet(tp,tc)
		elseif choice==3 then
			-- 如果是表侧表示放置，需要安全地将原有的场地魔法送去墓地
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	end
end