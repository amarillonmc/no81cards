local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	s.AddSpecialBodyXyzProcedure(c)
	c:EnableReviveLimit()
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

-- 过滤器：通常魔法卡
function s.rmfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsAbleToGrave()
end

-- 过滤器：结束阶段盖放（怪兽或S/T）
function s.setfilter(c,e,tp)
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		return c:IsSSetable()
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 选项1检测：是否有通常魔法素材可取除
	local b1=c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) 
		and c:GetOverlayGroup():IsExists(s.rmfilter,1,nil)
	
	-- 选项2检测：是否能预约结束阶段效果（只要卡在场通常均可，具体是否有素材留到EP由效果处理时判断）
	local b2=true 
	
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	e:SetLabel(op)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	
	if op==0 then
		-- ●这张卡作为超量素材中的1张通常魔法卡取除...
		if c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
			local g=c:GetOverlayGroup():FilterSelect(tp,s.rmfilter,1,1,nil)
			local tc=g:GetFirst()
			if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
				-- 赋予墓地卡片发动效果的能力
				local ae=tc:GetActivateEffect()
				if ae then
					local e1=Effect.CreateEffect(tc)
					e1:SetDescription(ae:GetDescription())
					e1:SetType(EFFECT_TYPE_IGNITION)
					e1:SetRange(LOCATION_GRAVE)
					e1:SetCountLimit(1)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					e1:SetCondition(s.spellcon)
					e1:SetCost(s.spellcost)
					e1:SetTarget(s.spelltg)
					e1:SetOperation(s.spellop)
					tc:RegisterEffect(e1)
				end
			end
		end
	else
		-- ●这个回合的结束阶段...
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,2))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetOperation(s.setop)
		c:RegisterEffect(e2)
	end
end

-- 复制效果：Condition检查
function s.spellcon(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetHandler():GetActivateEffect()
	local con=te:GetCondition()
	return not con or con(e,tp,eg,ep,ev,re,r,rp)
end
-- 复制效果：Cost检查与支付
function s.spellcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetHandler():GetActivateEffect()
	local cost=te:GetCost()
	if chk==0 then return not cost or cost(e,tp,eg,ep,ev,re,r,rp,0) end
	if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
end
-- 复制效果：Target检查与执行
function s.spelltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=e:GetHandler():GetActivateEffect()
	local tg=te:GetTarget()
	if chkc then return tg and tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
-- 复制效果：Operation执行
function s.spellop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetHandler():GetActivateEffect()
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

-- 结束阶段盖放处理
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 必须在场且有素材才能执行
	if c:IsLocation(LOCATION_MZONE) and c:GetOverlayCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=c:GetOverlayGroup():FilterSelect(tp,s.setfilter,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			if tc:IsType(TYPE_MONSTER) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SSet(tp,tc)
			end
		end
	end
end

function s.AddSpecialBodyXyzProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165) -- "超量召唤"的系统描述
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.SpecialBodyXyzCondition)
	e1:SetTarget(s.SpecialBodyXyzTarget)
	e1:SetOperation(s.SpecialBodyXyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end

-- 1. 过滤场上的6星怪兽
function s.SpecialBodyXyzFilterM(c,xyzc,tp)
	return c:IsFaceup() and c:IsLevel(6) and c:IsCanBeXyzMaterial(xyzc) 
		and (c:IsControler(tp) or c:IsHasEffect(EFFECT_XYZ_MATERIAL)) -- 兼容对方场上可作为素材的情况
end

-- 2. 过滤墓地的魔法/陷阱卡
function s.SpecialBodyXyzFilterST(c,xyzc)
	return (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) 
		and not c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL) -- 确保没有禁止作为素材的效果
		and (not c:IsHasEffect(EFFECT_NECRO_VALLEY)) -- 确保不被王长眠等卡限制
end

-- 3. 核心判断逻辑：检查组合是否合法
-- g: 选中的卡片组
-- tp: 玩家
-- xyzc: 要召唤的超量怪兽
function s.SpecialBodyXyzGoal(g,tp,xyzc)
	-- 必须正好是2张卡（CheckSubGroup会自动限制数量，但这里为了保险再次确认）
	if #g~=2 then return false end
	
	-- 魔法卡最多1张
	local ct_spell = g:FilterCount(function(c)
		return c:GetType()==TYPE_SPELL
	end, nil)
	if ct_spell > 1 then return false end
	
	-- 陷阱卡最多1张
	local ct_trap = g:FilterCount(Card.IsType, nil, TYPE_QUICKPLAY)
	if ct_trap > 1 then return false end
	
	-- 检查位置是否合法（如果选了场上的卡，它们离场后必须有格子给超量怪兽）
	return Duel.GetLocationCountFromEx(tp, tp, g, xyzc) > 0
end
function s.SpecialBodyXyzCondition(e,c,og,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	
	-- 必须素材检查（如“必须作为超量素材”的效果）
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
	-- 构建素材池 mg
	local mg=nil
	if og then
		-- 【关键修复】：如果传入了 og（通过效果召唤），则只能使用 og 内的卡
		-- 此时不能使用墓地的卡，否则会导致逻辑穿透
		mg=og
	else
		-- 只有在正常进行超量召唤（非效果）时，才混合场上和墓地资源
		local mg_field = Duel.GetMatchingGroup(s.SpecialBodyXyzFilterM, tp, LOCATION_MZONE, 0, nil, c, tp)
		local mg_gy = Duel.GetMatchingGroup(s.SpecialBodyXyzFilterST, tp, LOCATION_GRAVE, 0, nil, c)
		mg = mg_field + mg_gy
	end
	-- 必须包含强制素材
	if #sg > 0 then
		if not mg:Includes(sg) then return false end
		Duel.SetSelectedCard(sg)
	end
	
	-- 检查是否存在满足条件的组合（固定为2张）
	-- 注意：如果是通过效果召唤(og存在)，min/max可能会变，但此卡限制固定为2
	-- 为了兼容性，如果 min > 2 或 max < 2 则无法召唤
	local minc = min or 2
	local maxc = max or 2
	if minc > 2 or maxc < 2 then return false end
	return mg:CheckSubGroup(s.SpecialBodyXyzGoal, 2, 2, tp, c)
end
function s.SpecialBodyXyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then return true end
	local tp=c:GetControler()
	local mg=nil
	
	-- 同 Condition，严格区分 og 和 自由选材
	if og then
		mg=og
	else
		local mg_field = Duel.GetMatchingGroup(s.SpecialBodyXyzFilterM, tp, LOCATION_MZONE, 0, nil, c, tp)
		local mg_gy = Duel.GetMatchingGroup(s.SpecialBodyXyzFilterST, tp, LOCATION_GRAVE, 0, nil, c)
		mg = mg_field + mg_gy
	end
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local cancel = Duel.IsSummonCancelable()
	
	local g=mg:SelectSubGroup(tp, s.SpecialBodyXyzGoal, cancel, 2, 2, tp, c)
	
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
function s.SpecialBodyXyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		-- 极其罕见的情况，通常由特定效果触发
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg=e:GetLabelObject()
		if not mg then return end
		
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
end