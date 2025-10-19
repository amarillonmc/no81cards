-- 怪兽卡：魂铸操控者
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：召唤时夺取对方怪兽控制权
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.ctltg)
	e1:SetOperation(s.ctlop)
	c:RegisterEffect(e1)
	
	-- 效果②：手卡时除外墓地魂铸意志卡进行上级召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+1)	
	e2:SetCost(s.sumcost)
	e2:SetTarget(s.sumtg)
	e2:SetOperation(s.sumop)
	c:RegisterEffect(e2)
	
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCondition(s.sumcon)
	c:RegisterEffect(e3)
end

-- 定义魂铸意志字段和遗忘之地卡号
s.soul_setcode = 0x396c
s.forgotten_land_code = 95015000

-- 效果①：目标设定
function s.ctltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end

-- 效果①：操作处理
function s.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end

-- 效果②：发动条件（检查场上是否有遗忘之地）
function s.fieldcon(c)
	return c:IsFaceup() and c:IsCode(s.forgotten_land_code)
end

function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(s.fieldcon,tp,LOCATION_ONFIELD,0,1,nil)
end

-- 效果②：代价（除外墓地1张其他魂铸意志卡）
function s.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end

-- 效果②：除外筛选器
function s.exfilter(c)
	return c:IsSetCard(s.soul_setcode) and not c:IsCode(id) and c:IsAbleToRemoveAsCost()
end

-- 效果②：目标设定
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsSummonable(true,nil,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end

-- 效果②：操作处理
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- 进行表侧表示上级召唤
	if c:IsSummonable(true,nil,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Summon(tp,c,true,nil,1)
	end
end