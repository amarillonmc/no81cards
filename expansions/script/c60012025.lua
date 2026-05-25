-- 尽小花的临照
--Duel.LoadScript("c.lua")
-- 尽小花的临照
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 添加尽小花系列的卡名记述，方便其他卡识别
	aux.AddCodeList(c,60012023)
	
	-- 通常魔法的激活效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end

-- 尽小花·伊鞠的过滤函数
function cm.ijufilter(c,e,tp)
	return c:GetCode()==60012023 and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end

-- 目标选择函数
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- 二选一的效果选项，让玩家选择
	local opt=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	e:SetLabel(opt)
	if opt==0 then
		-- 第一个选项：检索/特殊召唤伊鞠
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		-- 第二个选项：回复+抽卡
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,100)
		-- 检查进化指示物的存在，用你给的判断条件
		if Duel.IsCanRemoveCounter(tp,1,0,0x624,1,REASON_RULE) then
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
		end
	end
end

-- 效果执行函数
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	if opt==0 then
		-- 第一个选项：从卡组找尽小花·伊鞠
		local g=Duel.GetMatchingGroup(cm.ijufilter,tp,LOCATION_DECK,0,nil,e,tp)
		if #g==0 then return end
		local tc=g:GetFirst()
		-- 检查两个子选项的可用性
		local b1=tc:IsAbleToHand()
		local b2=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
		elseif b2 then
			op=1
		else
			op=0
		end
		
		if op==0 then
			-- 加入手卡
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			-- 特殊召唤
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		-- 第二个选项：回复100基本分
		Duel.Recover(tp,100,REASON_EFFECT)
		-- 检查进化指示物，有的话抽1张
		if Duel.IsCanRemoveCounter(tp,1,0,0x624,1,REASON_RULE) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
