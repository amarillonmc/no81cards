-- 陷阱卡：魂铸牺牲
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：支付一半基本分，解放怪兽并发动场地
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	
	-- 效果②：代替破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end

-- 定义魂铸意志字段和遗忘城堡卡号
s.soul_setcode = 0x396c
s.forgotten_castle_code = 95015100  -- 请替换为实际卡号

-- 效果①：代价（支付一半基本分并丢弃自身）
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

-- 效果①：目标设定
function s.rlfilter(c)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end

function s.fcfilter(c)
	return c:IsCode(95015100) and c:IsAbleToHand() 
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查是否有可解放的魂铸意志怪兽
		local rlg=Duel.GetMatchingGroup(s.rlfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
		-- 检查卡组或墓地是否有遗忘城堡
		local fcg=Duel.GetMatchingGroup(s.fcfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		return #rlg>0 and #fcg>0
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end

-- 效果①：操作处理
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	-- 从卡组·手卡解放1只魂铸意志怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rlg=Duel.SelectMatchingCard(tp,s.rlfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if #rlg==0 then return end
	Duel.Release(rlg,REASON_EFFECT)
		-- 从卡组·墓地把1张「魂铸意志·遗忘城堡」在场上发动
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local fcg=Duel.SelectMatchingCard(tp,s.fcfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #fcg>0 then
		local tc=fcg:GetFirst()
		Duel.BreakEffect()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

-- 效果②：代替破坏
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(s.soul_setcode) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end

function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end