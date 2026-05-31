-- 猎杀虚幻的偏执狂 (永续陷阱版)
local s,id=GetID()

function s.initial_effect(c)
	-- 永续陷阱的卡片发动（盖放后翻开的基础系统逻辑）
	local e0b=Effect.CreateEffect(c)
	e0b:SetType(EFFECT_TYPE_ACTIVATE)
	e0b:SetCode(EVENT_FREE_CHAIN)
	e0b:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e0b)

	-- ①：抽卡以外加入手卡的场合，表侧表示放置
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tfcon)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)

	-- ②：二速效果 - 支付800基本分，除外卡组本家并除外场上对象
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O) -- 永续陷阱的场上效果是标准的二速效果
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.rmcost)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end

-- ==================== ①效果：检索/回收后放置 ====================
function s.tfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 必须是“抽卡以外”的方法加入手卡
	return not c:IsReason(REASON_DRAW)
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 预判魔陷区是否有空位
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 确保卡片还在手卡，且魔陷区有空位
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		-- 陷阱卡在手卡适用这个效果时，将作为“表侧表示的永续陷阱”直接放置到场上
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

-- ==================== ②效果：二速卡组除外与场上除外 ====================
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 支付 800 LP
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function s.tgtfilter(c,ec)
	-- 目标不能是发动效果的这张卡自身，且可以被除外
	return c~=ec and c:IsAbleToRemove()
end
function s.rmfilter(c)
	-- 从卡组除外1张同名卡以外的「ESP」卡
	return c:IsSetCard(0x3327) and not c:IsCode(id) and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and s.tgtfilter(chkc,c) end
	-- 预判：场上是否有对象，且卡组是否有本家可以除外
	if chk==0 then return Duel.IsExistingTarget(s.tgtfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c)
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.tgtfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 永续陷阱卡规则：如果效果处理时这张卡已经离场（例如被旋风破坏），则不处理效果
	if not c:IsRelateToEffect(e) then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	
	-- 先除外卡组的卡
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		-- 再除外场上的对象
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end