-- 炽魂fb
local s, id = GetID()

-- 定义炽魂字段常量
s.soul_setcode = 0xa96c

-- 卡名常量
s.block_name = 95018060
s.impact_name = 95018080
s.escape_name = 95018070

function s.initial_effect(c)
	-- 启动效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

-- 代价：取除1个炽魂指示物
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,s.soul_setcode,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,s.soul_setcode,1,REASON_COST)
end

function s.costfilter(c)
	return c:GetCounter(s.soul_setcode)>0
end

-- 目标：选择场上1张魔法·陷阱卡
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

-- 操作处理
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	-- 破坏目标魔法·陷阱卡
	if tc and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			-- 询问是否解放连接怪兽
			local g=Duel.GetMatchingGroup(s.linkfilter,tp,LOCATION_MZONE,0,nil)
			if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local lg=g:Select(tp,1,1,nil)
				if #lg>0 then
					local lc=lg:GetFirst()
					local attr=lc:GetAttribute()
					e:SetLabel(attr)
					if Duel.Release(lc,REASON_EFFECT)>0 then
						-- 根据解放的怪兽适用效果
						s.apply_effect_based_on_monster(e,tp,lc)
					end
				end
			end
		end
	end
end

-- 筛选连接怪兽且放置有炽魂指示物
function s.linkfilter(c)
	return c:IsType(TYPE_LINK) and c:GetCounter(s.soul_setcode)>0
end

-- 根据解放的怪兽适用效果
function s.apply_effect_based_on_monster(e,tp,lc)
	local c=e:GetHandler()
	local attr=e:GetLabel()
	local code=lc:GetCode()
	local name=lc:GetCode()
	
	-- 检查是否是炽魂连接怪兽
	if lc:IsSetCard(s.soul_setcode) then
		-- 暗属性「炽魂之格挡」
		if attr==ATTRIBUTE_DARK and (name==s.block_name or string.find(name,s.block_name)) then
			s.effect_block(e,tp)
		-- 光属性「炽魂之冲击」
		elseif attr==ATTRIBUTE_LIGHT and (name==s.impact_name or string.find(name,s.impact_name)) then
			s.effect_impact(e,tp)
		-- 暗属性「炽魂之遁形」
		elseif attr==ATTRIBUTE_DARK and (name==s.escape_name or string.find(name,s.escape_name)) then
			s.effect_escape_dark(e,tp)
		-- 光属性「炽魂之遁形」
		elseif attr==ATTRIBUTE_LIGHT and (name==s.escape_name or string.find(name,s.escape_name)) then
			s.effect_escape_light(e,tp)
		end
	end
end

-- 效果：暗属性「炽魂之格挡」- 无效对方场上所有怪兽效果
function s.effect_block(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
	
	if #g>0 then
		for tc in aux.Next(g) do
			-- 无效怪兽效果
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,2))
	end
end

-- 效果：光属性「炽魂之冲击」- 破坏对方场上所有怪兽
function s.effect_impact(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
	
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,3))
	end
end

-- 效果：暗属性「炽魂之遁形」- 将对方墓地/除外1张卡返回卡组并无效同名卡
function s.effect_escape_dark(e,tp)
	local c=e:GetHandler()
	local opp=1-tp
	
	-- 选择要返回的卡的位置
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,8))
	local op=Duel.SelectOption(tp,aux.Stringid(id,6),aux.Stringid(id,7))
	local location=LOCATION_GRAVE
	if op==1 then
		location=LOCATION_REMOVED
	end
	
	-- 选择对方的墓地或除外的卡
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,opp,location,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		if #sg>0 then
			local rc=sg:GetFirst()
			if Duel.SendtoDeck(rc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
				-- 记录被返回的卡
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e1:SetTarget(s.distg)
				e1:SetLabelObject(rc)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(s.discon)
				e2:SetOperation(s.disop)
				e2:SetLabelObject(rc)
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
				
				Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,4))
			end
		end
	end
end

-- 无效场上同名怪兽效果
function s.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end

-- 连锁解决时无效同名卡的效果
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

function s.disablefilter(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end

-- 效果：光属性「炽魂之遁形」- 从卡组特殊召唤炽魂怪兽
function s.effect_escape_light(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,5))
		end
	end
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end