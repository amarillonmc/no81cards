-- 仪式怪兽卡：暗月神兽
local s, id = GetID()

function s.initial_effect(c)
	-- 仪式怪兽属性
	c:EnableReviveLimit()
	
	-- 效果①：展示手卡返回卡组并除外低星暗月怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.excost)
	e1:SetTarget(s.extg)
	e1:SetOperation(s.exop)
	c:RegisterEffect(e1)
	
	-- 效果②：场上卡片因效果离场时改为除外
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetTarget(s.rmtg)
	c:RegisterEffect(e2)
end

-- 定义暗月字段
s.darkmoon_setcode = 0x696c

-- 效果①：代价（展示手卡）
function s.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- 展示手卡中的这张卡
	Duel.ConfirmCards(1-tp,e:GetHandler())
end

-- 效果①：目标设定
function s.exfilter(c)
	return c:IsSetCard(s.darkmoon_setcode) and c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end

function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end

-- 效果①：操作处理
function s.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- 这张卡返回卡组洗切
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		-- 从卡组把1只4星以下的「暗月」怪兽除外
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end

-- 效果②：条件（场上卡片因效果离场）
function s.rmtg(e,c)
	local re=c:GetReasonEffect()
	return re and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsReason(REASON_EFFECT)
end