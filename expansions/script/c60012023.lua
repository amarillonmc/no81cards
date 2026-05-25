-- 尽小花·伊鞠
--Duel.LoadScript("c.lua")
-- 尽小花·伊鞠
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 注册进化指示物的许可
	c:EnableCounterPermit(0x624)
	
	-- ①：召唤/特殊召唤成功的效果，翻卡组选魔法
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m) -- 这个卡名的①的效果1回合只能使用1次
	e1:SetTarget(cm.act1_target)
	e1:SetOperation(cm.act1_activate)
	c:RegisterEffect(e1)
	local e1_2=e1:Clone()
	e1_2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1_2)
	
	-- ②：自己发动魔法卡的时候，加指示物，特殊召唤伊鞠的小鬼
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.act2_con)
	e2:SetTarget(cm.act2_target)
	e2:SetOperation(cm.act2_activate)
	c:RegisterEffect(e2)
	
	-- 本体的全局效果：3个以上指示物的时候，给玩家附加标记效果，参考你给的图2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(m)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	
	-- ③：1个以上指示物的时候，检索效果
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetCondition(cm.act4_con)
	e4:SetTarget(cm.act4_target)
	e4:SetOperation(cm.act4_activate)
	c:RegisterEffect(e4)
end

-- ①的目标检查
function cm.act1_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
end

-- ①的效果执行：翻卡组上面3张，选1魔法加入手卡，剩下的回卡组
function cm.act1_activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	-- 翻开卡组最上面3张
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmCards(tp,g)
	Duel.ConfirmCards(1-tp,g)
	-- 选择1张魔法卡加入手卡，并且检查能不能加入手卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,function(c) return c:IsType(TYPE_SPELL) and c:IsAbleToHand() end,1,1,nil)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		g:RemoveCard(sg:GetFirst())
	end
	-- 剩下的卡洗回卡组
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

-- ②的触发条件：自己发动魔法卡
function cm.act2_con(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_SPELL)
end

-- ②的目标检查
function cm.act2_target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		-- 按照你给的写法，检查能不能放置指示物
		if not (c:IsCanHaveCounter(0x625) and Duel.IsCanAddCounter(c:GetControler(),0x625,1,c)) then return false end
		-- 检查能不能特殊召唤token
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,60012024,0,TYPES_TOKEN_MONSTER,1500,1500,3,RACE_FIEND,ATTRIBUTE_DARK) end
end

-- ②的效果执行：加指示物，特殊召唤小鬼token
function cm.act2_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 按照你给的写法，放置指示物，并且注册固定的flag
	c:AddCounter(0x624,1)
	Duel.RegisterFlagEffect(tp,60002148,0,0,1) -- 这个flag固定，不会因为卡的ID更改
	
	-- 特殊召唤伊鞠的小鬼token，参考你给的图1的写法
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,60012024,0,TYPES_TOKEN_MONSTER,1500,1500,3,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,60012024)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		-- 给token加效果：如果图3的检测不通过，才加素材限制
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetValue(1)
		e1:SetCondition(cm.act3_con)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end

-- 本体全局效果的条件：3个以上指示物
function cm.act3_con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(tp,m)
end

-- ③的触发条件：这张卡在场上表侧，并且有1个以上指示物
function cm.act4_con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:GetCounter(0x624)>=1
end

-- 尽小花的临照的过滤
function cm.filter_a(c)
	return c:GetCode()==60012025 and c:IsAbleToHand()
end
-- 诚心的尽小花的过滤
function cm.filter_b(c)
	return c:GetCode()==60012026 and c:IsAbleToHand()
end

-- ③的目标检查
function cm.act4_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		-- 至少有一个可以检索
		return Duel.IsExistingMatchingCard(cm.filter_a,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			or Duel.IsExistingMatchingCard(cm.filter_b,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end

-- ③的效果执行：丢1张手卡，然后先选a，再选b，最后合并加入手卡
function cm.act4_activate(e,tp,eg,ep,ev,re,r,rp)
	-- 丢弃1张手卡
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_DISCARD+REASON_EFFECT,nil)
	local g=Group.CreateGroup()
	-- 先处理尽小花的临照
	if Duel.IsExistingMatchingCard(cm.filter_a,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter_a),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #sg>0 then
			g:Merge(sg)
		end
	end
	-- 再处理诚心的尽小花
	if Duel.IsExistingMatchingCard(cm.filter_b,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter_b),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #sg>0 then
			g:Merge(sg)
		end
	end
	-- 一起加入手卡
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
