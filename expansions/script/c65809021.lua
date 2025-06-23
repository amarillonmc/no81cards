-- 永续魔法卡：资源争夺战
local s,id=GetID()
function s.initial_effect(c)
	-- 效果①：双方翻卡+选择除外+剩余送墓转手
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	
	-- 效果②：除外时回收资源
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end

-- 效果①处理函数
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 
			and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,PLAYER_ALL,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,PLAYER_ALL,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	-- 双方各翻3张卡
	local g1=Duel.GetDecktopGroup(tp,3)
	local g2=Duel.GetDecktopGroup(1-tp,3)
	if #g1<3 or #g2<3 then return end   
	local mg=Group.CreateGroup()
	mg:Merge(g1)
	mg:Merge(g2)
	Duel.ConfirmCards(tp,mg)
	Duel.ConfirmCards(1-tp,mg)
	-- 双方各选1张除外
	local rg=Group.CreateGroup()
	
	-- 己方选择
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg1=mg:Select(tp,1,1,nil)
	rg:Merge(sg1)
	mg:Sub(sg1)
	
	-- 对方选择
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local sg2=mg:Select(1-tp,1,1,nil)
	rg:Merge(sg2)
	mg:Sub(sg2)
	
	-- 执行除外
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
	
		Duel.SendtoGrave(mg,REASON_EFFECT)
		-- 送墓卡加入对方手卡
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		local tc=og:GetFirst()
		while tc do
			if tc:GetOwner()==tp then
				Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
			else
				Duel.SendtoHand(tc,tp,REASON_EFFECT)
			end
			tc=og:GetNext()
		end
end

-- 效果②处理函数
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then  return Duel.IsExistingMatchingCard(s.resfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,s.resfilter,1,1,REASON_COST,nil)
end
function s.resfilter(c)
	return c:IsSetCard(0xca30) and c:IsDiscardable()
end
function s.fit2(c,tp)
	return c:GetOwner()==tp and c:IsAbleToHand()
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return  Duel.IsExistingMatchingCard(s.fit2,tp,0,LOCATION_HAND,1,nil,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_REMOVED,1,nil,1-tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_REMOVED)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	-- 回收对方手卡中原本属于自己的卡
	local hg=Duel.GetMatchingGroup(s.fit2,1-tp,LOCATION_HAND,0,nil,tp)
	if #hg>0 then
		Duel.SendtoHand(hg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)   
	-- 对方选择1张除外的卡回收
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local rg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,1-tp,LOCATION_REMOVED,0,1,1,nil,1-tp)
		if #rg>0 then
		Duel.SendtoHand(rg,1-tp,REASON_EFFECT)
		end
	end
end
