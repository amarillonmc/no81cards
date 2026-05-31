local s,id=GetID()

function s.initial_effect(c)
	-- ①：三选一发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.maintg)
	e1:SetOperation(s.mainop)
	c:RegisterEffect(e1)

	-- ②：被除外的场合：除外卡组本家，并将这张卡加入手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,id) -- 这个卡名的②的效果1回合只能使用1次
	e2:SetCondition(s.rmcon2)
	e2:SetTarget(s.rmtg2)
	e2:SetOperation(s.rmop2)
	c:RegisterEffect(e2)
end

-- ==================== ①效果：三选一逻辑 ====================
function s.thfilter(c)
	-- 选项1：从墓地·除外区回收「ESP」卡（除外的卡需要是表侧表示）
	return c:IsSetCard(0x3327) and c:IsAbleToHand()
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function s.spfilter(c,e,tp)
	-- 选项2：卡组特召「ESP」怪兽
	return c:IsSetCard(0x3327) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end

function s.maintg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 判定三个选项各自是否合法，并且通过 Flag 判定这回合是否已经选过该选项
	local b1 = Duel.GetFlagEffect(tp,id+1)==0 
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	local b2 = Duel.GetFlagEffect(tp,id+2)==0 
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b3 = Duel.GetFlagEffect(tp,id+3)==0 
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		and c:IsAbleToRemove()

	if chk==0 then return b1 or b2 or b3 end

	-- 动态构建弹窗选项表
	local ops={}
	local opval={}
	if b1 then table.insert(ops,aux.Stringid(id,1)); table.insert(opval,1) end
	if b2 then table.insert(ops,aux.Stringid(id,2)); table.insert(opval,2) end
	if b3 then table.insert(ops,aux.Stringid(id,3)); table.insert(opval,3) end

	-- 弹出窗口让玩家选择
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op+1]
	e:SetLabel(sel)

	-- 给所选的选项打上“这回合已使用过”的标记
	Duel.RegisterFlagEffect(tp,id+sel,RESET_PHASE+PHASE_END,0,1)

	-- 根据所选项向系统汇报类别（Category）
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	elseif sel==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif sel==3 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	end
end

function s.mainop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	local c=e:GetHandler()

	if sel==1 then
		-- 【选项A：回收手卡】
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end

	elseif sel==2 then
		-- 【选项B：特召到对方场上并在连锁结束时破坏】
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)>0 then
			-- 注册延迟效果：在连锁结束时 (EVENT_CHAIN_END) 破坏它
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCountLimit(1)
			e1:SetLabelObject(tc)
			e1:SetCondition(s.descon)
			e1:SetOperation(s.desop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			-- 给怪兽打个标记防止由于其他原因离场又被误炸
			tc:RegisterFlagEffect(id+4,RESET_EVENT+RESETS_STANDARD,0,1)
		end

	elseif sel==3 then
		-- 【选项C：除外墓地与自身】
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if #g>0 then
			-- 拦截默认的“用完送去墓地”逻辑，以便将其除外
			if c:IsRelateToEffect(e) then
				c:CancelToGrave()
				g:AddCard(c)
			end
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end

-- ==================== 辅助函数：连锁结束破坏 ====================
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and tc:GetFlagEffect(id+4)>0
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
	e:Reset() -- 炸完之后直接注销该挂载效果
end

-- ==================== ②效果：被除外的场合 ====================
function s.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return true -- 只要被除外即可触发
end
function s.rmfilter2(c)
	return c:IsSetCard(0x3327) and not c:IsCode(id) and c:IsAbleToRemove()
end
function s.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter2,tp,LOCATION_DECK,0,1,nil)
		and c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter2,tp,LOCATION_DECK,0,1,1,nil)
	-- 先除外卡组的卡
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		-- 判定自身是否还在除外区，如果还在则加入手卡
		if c:IsRelateToEffect(e) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
		end
	end
end
