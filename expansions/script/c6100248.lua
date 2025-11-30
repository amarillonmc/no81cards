--赤晶的清扫
local s,id,o=GetID()
function s.initial_effect(c)
	--①：回卡组 + 盖怪
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	--②：自我回收
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.tdfilter1(c)
	return c:IsSetCard(0x613) and c:IsAbleToDeck()
end
function s.tdfilter2(c)
	return c:IsAbleToDeck()
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(s.tdfilter2,tp,0,LOCATION_GRAVE,1,nil) end
	
	-- 选自己墓地1张
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,s.tdfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	
	-- 选对方墓地1~2张
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,s.tdfilter2,tp,0,LOCATION_GRAVE,1,2,nil)
	g1:Merge(g2)
	
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,#g1,0,0)
	-- 设置可能的位置变更提示
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,1-tp,LOCATION_MZONE)
end

function s.lv4filter(c)
	return c:IsSetCard(0x613) and c:IsLevel(4) and c:IsFaceup()
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		-- 只要有卡回到了卡组或额外卡组
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
			-- 检查自己场上是否有4星「朦雨」怪兽
			if Duel.IsExistingMatchingCard(s.lv4filter,tp,LOCATION_MZONE,0,1,nil)
				and Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
				local sg=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,1,nil)
				if #sg>0 then
					Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
				end
			end
		end
	end
end

-- === 效果② ===
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:IsSetCard(0x613)
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end