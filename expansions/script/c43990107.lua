--蔷薇猎人
local m=43990107
local cm=_G["c"..m]
function c43990107.initial_effect(c)
	-- 超量召唤规则
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c43990107.mfilter,nil,2,99)
	aux.AddXyzProcedure(c,aux.TRUE,4,1)
	
	-- 效果①：破怪+检索+自爆连锁
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990107,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,43990107)
	e1:SetCost(c43990107.descost)
	e1:SetTarget(c43990107.destg)
	e1:SetOperation(c43990107.desop)
	c:RegisterEffect(e1)
	
	-- 效果②：离场回收+抽卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990107,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c43990107.tdtg)
	e2:SetOperation(c43990107.tdop)
	c:RegisterEffect(e2)
end

function c43990107.mfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_ILLUSION)
end
-- 效果①代价：去除超量素材
function c43990107.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

-- 效果①目标选择   
function c43990107.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsAttackAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0)
	local tc=g:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.floor(tc:GetPreviousAttackOnField()/2))
end
function c43990107.thfilter(c)
	return c:IsSetCard(0x5510) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c43990107.gcheck(g,e,tp,max_atk)
	return g:GetSum(Card.GetAttack)<=max_atk

end
-- 效果①操作处理
function c43990107.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		-- 计算伤害
		local dam=math.floor(tc:GetPreviousAttackOnField()/2)
		local max_atk=tc:GetPreviousAttackOnField()
		local g=Duel.GetMatchingGroup(c43990107.thfilter,tp,LOCATION_DECK,0,nil)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
		if max_atk>0 and g:CheckSubGroup(c43990107.gcheck,1,1,e,tp,max_atk) and Duel.SelectYesNo(tp,aux.Stringid(43990107,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.BreakEffect()
			local sg=g:SelectSubGroup(tp,c43990107.gcheck,false,1,99,e,tp,max_atk)
			if sg and sg:GetCount()>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		-- 检索处理
		end
		if tc==e:GetHandler() and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43990107,3)) then 
			Duel.BreakEffect()
			local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end


-- 效果②目标选择
function c43990107.tdfilter(c)
	return c:IsRace(RACE_ILLUSION) and c:IsFaceupEx()
end
function c43990107.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c43990107.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c43990107.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c43990107.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c43990107.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end