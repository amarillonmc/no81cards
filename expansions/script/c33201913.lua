local s,id=GetID()

function s.initial_effect(c)
	-- ①：发动效果（取对象，二选一）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END+TIMINGS_CHECK_MONSTER)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

-- ==================== 取对象与二选一预判 ====================
function s.tgfilter(c,e,tp)
	-- 能够成为对象的：自己场上表侧表示的「特诺奇」怪兽
	return c:IsFaceup() and c:IsSetCard(0x5328)
end
function s.exfilter(c,e,tp,mc,rank)
	-- 升阶特召的条件：额外卡组对应阶级的「特诺奇」超量怪兽
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x5328) and c:GetRank()==rank
		and mc:IsCanBeXyzMaterial(c,tp)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.can_rank_up(c,e,tp)
	-- 判断该怪兽能否进行升阶
	local rank=0
	if c:IsLevelAbove(0) then rank=c:GetLevel()+2
	elseif c:IsType(TYPE_XYZ) then rank=c:GetRank()+2
	else return false end
	
	return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rank)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	
	-- 判定对象满足哪个效果条件
	local b1 = s.can_rank_up(tc,e,tp)
	local b2 = true -- 只要是表侧表示的本家怪兽，赋予抗性的选项始终合法
	
	local op=0
	-- 需在 cdb 录入文本：[1] 升阶超量召唤； [2] 赋予抗性并盖放这张卡
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	e:SetLabel(op)
	
	-- 根据所选的选项，动态向系统汇报 Category（方便对方被灰流丽等卡片识别连锁）
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		e:SetCategory(0)
	end
end

-- ==================== 效果执行 ====================
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local op=e:GetLabel()
	
	-- 确认对象依然在场、表侧表示，且没有被对方牛走
	if not tc or not tc:IsRelateToEffect(e) or not tc:IsFaceup() or tc:IsControler(1-tp) then return end

	if op==0 then
		-- 【选项A：升阶超量召唤】
		if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) or tc:IsImmuneToEffect(e) then return end
		
		local rank=0
		if tc:IsLevelAbove(0) then rank=tc:GetLevel()+2
		elseif tc:IsType(TYPE_XYZ) then rank=tc:GetRank()+2 end
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,rank)
		local sc=g:GetFirst()
		if sc then
			local mg=tc:GetOverlayGroup()
			if #mg>0 then Duel.Overlay(sc,mg) end
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end

	elseif op==1 then
		-- 【选项B：不受影响并自身盖放】
		
		-- 1. 赋予直到连锁结束时的抗性
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN) -- RESET_CHAIN：在这条连锁处理完毕后立刻失效
		tc:RegisterEffect(e1)
		
		-- 2. 直接盖放这张卡（代替送去墓地）
		if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
			c:CancelToGrave() -- 打断系统默认的“用完送墓”流程
			Duel.ChangePosition(c,POS_FACEDOWN) -- 转为盖放状态
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) -- 触发“卡片被盖放”的系统事件
		end
	end
end
function s.efilter(e,re)
	-- 不受对方（发动者以外）的卡片效果影响
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end