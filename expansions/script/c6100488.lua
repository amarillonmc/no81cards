--红魔乡的笼中鸟
local s,id,o=GetID()
function s.initial_effect(c)
	--超量召唤 (4星怪兽×3)
	c:EnableReviveLimit()
	-- aux.AddXyzProcedure(c, 常规过滤, 等级, 最小数量, 替代过滤, 替代描述, 最大数量, 替代操作)
	aux.AddXyzProcedure(c,nil,4,3,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)

	--①：宣言种类翻卡检索，下回合赋予自肃与离场除外
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	--②：超量召唤的此卡因对方离场时特召并吸材
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- === 超量召唤叠加手续 (天霆号标准写法) ===
-- 叠加底材过滤器：自己场上1只可以通常召唤的怪兽
function s.ovfilter(c)
	return c:IsFaceup() and c:IsSummonableCard()
end

-- 墓地除外Cost过滤器
function s.rmfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsAbleToRemoveAsCost()
end

-- 叠加时的额外操作（即Cost支付）
function s.xyzop(e,tp,chk)
	-- chk==0 为判定阶段，严禁执行实质动作
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,3,nil) end
	-- chk==1 为执行阶段，正式除外墓地
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end

-- === 效果①：翻卡检索 ===
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 检查下个回合的自肃标记
	if c:GetFlagEffect(id)>0 then
		local labels={c:GetFlagEffectLabel(id)}
		for _,label in ipairs(labels) do
			if label==Duel.GetTurnCount() then return false end
		end
	end
	return true
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	-- 0: 怪兽, 1: 魔法, 2: 陷阱
	local ty=Duel.AnnounceType(tp)
	e:SetLabel(ty)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ty=e:GetLabel()
	local card_type=0
	if ty==0 then card_type=TYPE_MONSTER
	elseif ty==1 then card_type=TYPE_SPELL
	elseif ty==2 then card_type=TYPE_TRAP end

	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end

	local exc_count=0
	-- 模拟翻卡：找到第2张符合种类卡片的位置
	for i=1,dcount do
		local tg=Duel.GetDecktopGroup(tp,i)
		local ct=tg:FilterCount(Card.IsType,nil,card_type)
		exc_count=i
		if ct>=2 then break end
	end

	-- 翻开并处理
	Duel.ConfirmDecktop(tp,exc_count)
	local exc_g=Duel.GetDecktopGroup(tp,exc_count)
	local match_g=exc_g:Filter(Card.IsType,nil,card_type)

	if #match_g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local th=match_g:Select(tp,1,1,nil)
		Duel.SendtoHand(th,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,th)
		exc_g:Sub(th) -- 将选入手的卡从被翻开的卡群中剔除
	end
	
	-- 剩余的卡回到卡组洗切
	if #exc_g>0 then
		Duel.SendtoDeck(exc_g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	
	-- 挂载：下个回合的自肃与离场重定向
	if c:IsRelateToEffect(e) then
		local next_turn = Duel.GetTurnCount() + 1
		-- 标记本卡在下回合不可发动此效果
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,next_turn)
		
		-- 离场除外
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2)) -- 提示："下回合离场除外"
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetCondition(s.rdcon)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e1:SetLabel(next_turn)
		c:RegisterEffect(e1)
	end
end

-- 离场除外的生效判定：只在发动的“下个回合”生效
function s.rdcon(e)
	return Duel.GetTurnCount() == e:GetLabel()
end

-- === 效果②：离场复活与吸材 ===
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ) 
		and c:GetReasonPlayer()==1-tp
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	-- 不能对应这个发动把场上的怪兽的效果发动
	Duel.SetChainLimit(s.chlimit)
end

function s.chlimit(e,ep,tp)
	return tp==ep or not (e:IsActiveType(TYPE_MONSTER) and e:GetHandler():IsOnField())
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 抓取场上所有非衍生物的怪兽
		local g=Duel.GetMatchingGroup(function(tc) return tc:IsType(TYPE_MONSTER) and not tc:IsType(TYPE_TOKEN) end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			-- 选场上1只怪兽作为这张卡的超量素材
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
				if not tc:IsImmuneToEffect(e) then
   				local og=tc:GetOverlayGroup()
					if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
					end
					Duel.Overlay(c,Group.FromCards(tc))
			end
		end
	end
end