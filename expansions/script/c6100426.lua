--辉色追忆 翡翠色散
local s,id,o=GetID()
function s.initial_effect(c)
	--必须记述的卡号声明
	aux.AddCodeList(c,6100146)

	--发动后继续留在场上
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e0)

	--①：卡片的发动 (二选一)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)

	--②：作为同调素材离场，变成下次召唤覆盖
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4)) -- "变更下次对方召唤为里侧"
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.mtcon)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
end

-- === 效果①：条件与目标 ===
function s.spellfilter(c)
	if not c:IsType(TYPE_SPELL) then return false end
	-- 排除里侧除外的卡片（无法确定其是否为魔法卡）
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	return true
end

function s.faceup_spell_filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end

function s.thfilter1(c,ec)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c~=ec
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	-- 选项1：卡组至少有3张卡，且本回合没有使用过选项1
	local b1 = Duel.GetFlagEffect(tp,id)==0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,c,TYPE_SPELL)>0
	-- 选项2：场上有其它魔法·陷阱卡可回手，且本回合没用过选项2
	local b2 = Duel.GetFlagEffect(tp,id+1)==0 
		and Duel.IsExistingMatchingCard(s.thfilter1, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, c, c)
		
	if chk==0 then return b1 or b2 end 
	
	local op=0
	if b1 and b2 then
		local sel=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		op=sel
	elseif b1 then
		Duel.SelectOption(tp,aux.Stringid(id,1))
		op=0
	else
		Duel.SelectOption(tp,aux.Stringid(id,2))
		op=1
	end
	e:SetLabel(op)
	
	if op==0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif op==1 then
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_ONFIELD)
	end
end

-- === 效果①：处理分歧 ===
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	
	if op==0 then
		-- ● 选项1：确认任意数量，翻开N+3张，赋记述，洗切置顶，抽1
		local max_sel = Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) - 3
		if max_sel < 0 then return end
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
		-- 可以不选（即选0张，直接翻最底线的3张）
		local g = Duel.SelectMatchingCard(tp, s.spellfilter, tp, LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED, 0, 0, max_sel, c)
		local n = 0
		if #g > 0 then
			Duel.ConfirmCards(1-tp, g)
			n = #g
		end
		
		local flip_ct = n + 3
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) < flip_ct then return end
		
		-- 翻开卡片
		Duel.ConfirmDecktop(tp, flip_ct)
		local dg = Duel.GetDecktopGroup(tp, flip_ct)
		
		-- 获取自己场上表侧魔法卡的数量
		local m_count = Duel.GetMatchingGroupCount(s.faceup_spell_filter, tp, LOCATION_ONFIELD, 0, nil)
		
		if m_count > 0 and dg:IsExists(Card.IsType, 1, nil, TYPE_SPELL) then
			if Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPERATECARD)
				-- 选出最多等于自己场上魔法卡数量的魔法卡
				local sg = dg:FilterSelect(tp, Card.IsType, 1, m_count, nil, TYPE_SPELL)
				if #sg > 0 then
					Duel.ConfirmCards(1-tp,sg)
					for tc in aux.Next(sg) do
						local code = tc:GetOriginalCodeRule()
						local mt = _G["c"..code]
						if mt then
							if not mt.card_code_list then mt.card_code_list = {} end
							mt.card_code_list[6100146] = true
							
							-- 全场标记光环提示
							local ag = Duel.GetMatchingGroup(Card.IsOriginalCodeRule, tp, 0xff, 0xff, nil, code)
							for ac in aux.Next(ag) do
								ac:RegisterFlagEffect(0, nil, EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(id, 4))
							end
						end
					end
				end
					if #dg > 0 then
					local tg=dg:FilterSelect(tp, s.excfilter, 1, 1, nil)
					Duel.SendtoHand(tg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tg)
					dg:Sub(tg)
					end
			end
		end
		
		
		Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT,tp,true)

	elseif op==1 then
		-- ● 选项2：这张卡和另外1张魔陷回手
		if not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,c)
		Duel.HintSelection(g)
		if #g>0 then
			g:AddCard(c)
			c:CancelToGrave() -- 防止速攻魔法在结算后自动进墓地
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end

function s.excfilter(c)
	return aux.IsCodeListed(c,6100146) and c:IsAbleToHand()
end

-- === 效果②：同调素材离场，赋予下次召唤强制里侧 ===
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(1-tp,id+100)>0 then return false end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(s.posop)
	Duel.RegisterEffect(e1, tp)
	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2, tp)
	
	e1:SetLabelObject(e2)
	e2:SetLabelObject(e1)
	Duel.RegisterFlagEffect(1-tp,id+100,nil,0,1)
end

-- 拦截召唤成功的瞬间
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	-- 筛选出由对方召唤·特殊召唤的怪兽
	local g = eg:Filter(Card.IsSummonPlayer, nil, 1-tp)

	if #g > 0 then
		local tg = g:Filter(Card.IsCanTurnSet, nil)
		if #tg > 0 then
			Duel.Hint(HINT_CARD, 0, id)
			Duel.ChangePosition(tg, POS_FACEDOWN_DEFENSE)
		end
		local sibling = e:GetLabelObject()
		if sibling then sibling:Reset() end
		e:Reset()
	end
end