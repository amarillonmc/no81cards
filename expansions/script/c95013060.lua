-- 破晓军师 雅阁
local s, id = GetID()
s.dawn_set = 0x696d  -- 破晓字段代码

function s.initial_effect(c)
	-- 效果①：特殊召唤时控制权回归并选对方墓地卡回卡组（墓地无卡则只回归）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.returntg)
	e1:SetOperation(s.returnop)
	c:RegisterEffect(e1)

	-- 效果②：送去墓地时从卡组加入「破晓」魔法卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- 效果①的目标：无条件发动（只设置操作信息）
function s.returntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local owner=e:GetHandler():GetOwner()
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-owner,LOCATION_GRAVE)
end

function s.returnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local owner=c:GetOwner()
	local player=c:GetControler()
	if owner~=player then
		-- 检查原本持有者场上是否有空位
		if Duel.GetLocationCount(owner,LOCATION_MZONE)>0 then
			Duel.GetControl(c,owner)
		end
		-- 如果无法转移，控制权不变，但后续仍由原本持有者操作
	end
	-- 原本持有者选择对方墓地1张卡回到卡组洗切（如果有的话）
	local opp=1-owner
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,owner,0,LOCATION_GRAVE,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,owner,HINTMSG_TODECK)
		local sg=g:Select(owner,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	-- 如果墓地没有卡，则只完成控制权回归，无事发生
end

-- 效果②：检索「破晓」魔法卡（保持不变）
function s.thfilter(c)
	return c:IsSetCard(s.dawn_set) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end