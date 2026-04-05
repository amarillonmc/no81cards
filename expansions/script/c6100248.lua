--赤晶的清扫
local s,id,o=GetID()
function s.initial_effect(c)
	--手卡发动许可
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)

	--①：同列弹手卡 + 追加召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--②：墓地发动并复刻适用效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.gycost)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
end

-- === 手卡发动条件 ===
function s.hwfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsSetCard(0x613)
end
function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.hwfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

-- === 效果①：目标选取逻辑 ===
-- 第1对：自己的卡 过滤器 (至少它自己或同列对面的卡是朦雨)
function s.first_my_filter(c,tp,e)
	if not c:IsAbleToHand() or not c:IsCanBeEffectTarget(e) then return false end
	-- 找到同列的对方的卡
	local col_g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToHand,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
	if #col_g==0 then return false end
	-- 保证自己是朦雨，或者同列有对面的朦雨卡可以选
	if c:IsSetCard(0x613) then return true end
	return col_g:IsExists(Card.IsSetCard,1,nil,0x613)
end

-- 第1对：对方的卡 过滤器 (强制满足朦雨要求)
function s.tc2_filter(c,col_g,tc1)
	return col_g:IsContains(c) and (tc1:IsSetCard(0x613) or c:IsSetCard(0x613))
end

-- 后续对：自己的卡 过滤器 (只需合法，不再强制要求朦雨)
function s.next_my_filter(c,tp,e,tg)
	if not c:IsAbleToHand() or not c:IsCanBeEffectTarget(e) then return false end
	local col_g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToHand,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
	-- 剔除已经被选作目标的卡
	if tg then col_g:Sub(tg) end
	return #col_g>0
end

-- 后续对：对方的卡 过滤器
function s.ntc2_filter(c,col_g)
	return col_g:IsContains(c)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end -- 屏蔽单体自动选取，全部由手动脚本控制
	if chk==0 then return Duel.IsExistingMatchingCard(s.first_my_filter,tp,LOCATION_ONFIELD,0,1,nil,tp,e) end
	
	local tg=Group.CreateGroup()
	
	-- 选择第1对的第1张卡（自己场上）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc1=Duel.SelectTarget(tp,s.first_my_filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp,e):GetFirst()
	tg:AddCard(tc1)
	
	-- 选择第1对的第2张卡（对方场上同列）
	local col_g1=tc1:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToHand,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc2=Duel.SelectTarget(tp,s.tc2_filter,tp,0,LOCATION_ONFIELD,1,1,nil,col_g1,tc1):GetFirst()
	tg:AddCard(tc2)
	tg:AddCard(e:GetHandler())
	
	-- 循环：是否继续追加选择后续同列对
	while true do
		local cg1=Duel.GetMatchingGroup(s.next_my_filter,tp,LOCATION_ONFIELD,0,tg,tp,e,tg)
		-- 若没有符合后续条件的对位卡，或者玩家选择不继续选，则退出循环
		if #cg1==0 or not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then break end 
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local ntc1=Duel.SelectTarget(tp,s.next_my_filter,tp,LOCATION_ONFIELD,0,1,1,tg,tp,e,tg):GetFirst()
		tg:AddCard(ntc1)
		
		local ncol_g=ntc1:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToHand,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
		ncol_g:Sub(tg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local ntc2=Duel.SelectTarget(tp,s.ntc2_filter,tp,0,LOCATION_ONFIELD,1,1,tg,ncol_g):GetFirst()
		tg:AddCard(ntc2)
	end
	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
end

-- 追加召唤过滤器
function s.sumfilter(c)
	return c:IsSetCard(0x613) and c:IsSummonable(true,nil)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	-- 那些卡回到手卡
	if Duel.SendtoHand(tg,nil,REASON_EFFECT)>0 then
		-- 如果自己场上没有怪兽存在
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
			local sumg=Duel.GetMatchingGroup(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
			-- 可以再进行1只「朦雨」怪兽的召唤
			if #sumg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local sc=sumg:Select(tp,1,1,nil):GetFirst()
				Duel.Summon(tp,sc,true,nil)
			end
		end
	end
end

-- === 效果②：墓地复刻效果 ===
function s.gycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end

function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then 
		-- 判断复用①效果的Target能否取到合法对象，以及本卡能否回卡组
		return e:GetHandler():IsAbleToDeck() and s.target(e,tp,eg,ep,ev,re,r,rp,0,chkc) 
	end
	-- 真实运行①效果的Target选取逻辑
	s.target(e,tp,eg,ep,ev,re,r,rp,1,chkc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	-- 直接复刻①效果的结算处理
	s.activate(e,tp,eg,ep,ev,re,r,rp)
	
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		-- 那之后，墓地的这张卡回到卡组
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end