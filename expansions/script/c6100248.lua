--朦雨的清扫 (赤晶的清扫)
local s,id,o=GetID()
function s.initial_effect(c)
	--①：弹手卡 + 允许手卡发动陷阱
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id) -- 绑定 id
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--②：墓地复刻适用效果并回卡组
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id) -- 同样绑定 id，实现二选一
	e2:SetCost(s.gycost)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
end

-- 判定是否为表侧的「朦雨」卡
function s.is_faceup_mengyu(c)
	return c:IsFaceup() and c:IsSetCard(0x613)
end

-- 获取某张自己场上的卡，所能对应的【对方合法的目标卡】
function s.get_valid_opp_cards(c,tp,e,selected_group)
	-- 获取对方场上能成为对象、且没确定送墓（能回手卡）的卡
	local opp_g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,0,LOCATION_ONFIELD,nil,e)
	opp_g=opp_g:Filter(Card.IsAbleToHand,nil)
	
	-- 剔除已经被循环选过的卡，防止同一张卡被取对象2次
	if selected_group then
		opp_g:Sub(selected_group)
	end
	
	-- 如果这张卡不是自己场上【处于连接状态的怪兽】，则严格限制为同纵列
	if not (c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and (c:IsLinkState() or (c:GetSequence()>4 and c:IsType(TYPE_LINK)))) then
		local col_g=c:GetColumnGroup()
		opp_g = opp_g:Filter(function(tc, cg) return cg:IsContains(tc) end, nil, col_g)
	end
	
	return opp_g
end

-- 自己的卡综合过滤器
function s.my_filter(c,tp,e,selected_group,need_mengyu)
	-- 排除发动卡自身，必须能回手且能被取对象
	if c==e:GetHandler() or not c:IsAbleToHand() or not c:IsCanBeEffectTarget(e) then return false end
	-- 不能重复选同一张卡
	if selected_group and selected_group:IsContains(c) then return false end
	
	-- 必须有对应的对方场上的卡可供配对
	local opp_g=s.get_valid_opp_cards(c,tp,e,selected_group)
	if #opp_g==0 then return false end
	
	-- 第一对强制要求包含「朦雨」
	if need_mengyu then
		if s.is_faceup_mengyu(c) then return true end
		return opp_g:IsExists(s.is_faceup_mengyu,1,nil)
	end
	return true
end

-- === 效果① ===
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end -- 屏蔽单体自动选取
	if chk==0 then return Duel.IsExistingMatchingCard(s.my_filter,tp,LOCATION_ONFIELD,0,1,nil,tp,e,nil,true) end
	
	local tg=Group.CreateGroup()
	local has_mengyu=false
	
	-- 强制抓取第1对（必须满足包含「朦雨」的要求）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,s.my_filter,tp,LOCATION_ONFIELD,0,1,1,nil,tp,e,tg,true)
	local tc1=g1:GetFirst()
	tg:AddCard(tc1)
	Duel.SetTargetCard(tc1)
	if s.is_faceup_mengyu(tc1) then has_mengyu=true end
	
	-- 根据第1张自己的卡，获取可选的对方的卡
	local opp_g1=s.get_valid_opp_cards(tc1,tp,e,tg)
	if not has_mengyu then
		opp_g1=opp_g1:Filter(s.is_faceup_mengyu,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=opp_g1:Select(tp,1,1,nil)
	local tc2=g2:GetFirst()
	tg:AddCard(tc2)
	Duel.SetTargetCard(tc2)
	
	-- 循环：继续追加选择（不再强制要求「朦雨」）
	while true do
		local next_my_g=Duel.GetMatchingGroup(s.my_filter,tp,LOCATION_ONFIELD,0,nil,tp,e,tg,false)
		if #next_my_g==0 then break end
		if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then break end -- "是否继续选择目标？"
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local nt1=next_my_g:Select(tp,1,1,nil):GetFirst()
		tg:AddCard(nt1)
		Duel.SetTargetCard(nt1)
		
		local opp_next_g=s.get_valid_opp_cards(nt1,tp,e,tg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local nt2=opp_next_g:Select(tp,1,1,nil):GetFirst()
		tg:AddCard(nt2)
		Duel.SetTargetCard(nt2)
	end
	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
		-- 这个回合只有1次，自己可以把「朦雨」陷阱卡从手卡发动
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,3)) -- "可以从手卡发动1张「朦雨」陷阱卡"
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetTarget(function(eff,c) return c:IsSetCard(0x613) end)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		
		-- UI客户端光环提示
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))

end

-- === 效果② ===
function s.gycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end

function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then 
		-- 判断本卡能否回卡组，同时预执行①的选卡检测
		return e:GetHandler():IsAbleToDeck() and s.target(e,tp,eg,ep,ev,re,r,rp,0,chkc) 
	end
	s.target(e,tp,eg,ep,ev,re,r,rp,1,chkc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end