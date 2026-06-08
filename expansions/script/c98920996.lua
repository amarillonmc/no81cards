local s,id=GetID()
function s.initial_effect(c)
	--①：把场上的这张卡除外才能发动。等级合计直到6为止（合计必须为6），把效果怪兽以外的怪兽最多2只从额外卡组特殊召唤。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

-- 发动Cost：除外场上的这张卡
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

-- 过滤额外卡组中符合条件的怪兽：必须是怪兽、非效果怪兽、有等级、且可以特殊召唤
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT)
		and c:GetLevel() > 0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 子集检测函数：检测选出的怪兽数量是否不超过怪兽区域空位，且等级合计必须正好等于6
function s.goal_check(sg,ft)
	return #sg <= ft and sg:GetSum(Card.GetLevel) == 6
end

-- 目标判断
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		-- 计算可用怪兽区域（若这张卡在主要怪兽区，除外后会多腾出1个格子）
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if c:GetSequence()<5 then ft=ft+1 end
		if ft<=0 then return false end
		
		-- 如果受到“青眼精灵龙”等卡片的影响，特召数量限制为最多1只
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUE_EYES_SPIRIT) then ft=1 end
		
		-- 获取所有合法的额外卡组怪兽
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		
		-- 检测是否存在数量在1-2之间、等级合计正好为6、且数量不超过场地空余格子的怪兽组合
		return g:CheckSubGroup(s.goal_check,1,2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

-- 效果处理
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUE_EYES_SPIRIT) then ft=1 end

	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if #g==0 then return end

	-- 提示玩家选择符合条件的怪兽（等级合计必须为6，数量1-2只，且不超过ft）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,s.goal_check,false,1,2,ft)
	
	if sg and #sg>0 then
		local fid=c:GetFieldID()
		local tc=sg:GetFirst()
		while tc do
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				-- 给特召成功的怪兽打上标记，用于结束阶段破坏
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			end
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		
		-- 过滤出确实成功特召上场的怪兽并注册结束阶段破坏效果
		local sg2=sg:Filter(function(tc) return tc:GetFlagEffectLabel(id)==fid end, nil)
		if #sg2>0 then
			sg2:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(sg2)
			e1:SetCondition(s.descon)
			e1:SetOperation(s.desop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

-- 破坏效果条件：场上还存在持有对应标记的怪兽
function s.desfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:Exists(s.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	end
	return true
end

-- 破坏效果执行
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(s.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
	g:DeleteGroup()
	e:Reset()
end