-- 永续魔法卡：深渊掠夺
local s,id=GetID()
function s.initial_effect(c)
	-- 效果①：支付LP+墓地除外+抢夺对方卡组
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	
	-- 效果②：除外时丢弃对方手卡回收
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end

-- 效果①处理函数
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	-- 自己墓地全部除外
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	
	-- 对方卡组随机3张里侧除外
	local dg1=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local dg2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #dg1>2 and #dg2>=3 then
		Duel.DisableShuffleCheck()
		dg1=dg1:RandomSelect(tp,3)
		dg2=dg2:RandomSelect(tp,3)
		dg1:Merge(dg2)
		Duel.Remove(dg1,POS_FACEDOWN,REASON_EFFECT)   
	-- 里侧除外的卡加入自己卡组
		local exg=Duel.GetOperatedGroup()
		if #exg>0 then
				Duel.SendtoDeck(exg,tp,3,REASON_EFFECT)
		end
	end
end
function s.fit2(c,tp)
	return c:GetOwner()~=tp and c:IsDiscardable()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then   return Duel.IsExistingMatchingCard(s.fit2,tp,LOCATION_HAND,0,1,nil,tp)   end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		Duel.DiscardHand(tp,s.fit2,1,1,REASON_COST+REASON_DISCARD,nil,tp)
end
-- 效果②处理函数
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return  Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable()
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or not e:GetHandler():IsRelateToEffect(e) then return end
	-- 本卡盖放
	local c=e:GetHandler()
	Duel.SSet(tp,c)
end
