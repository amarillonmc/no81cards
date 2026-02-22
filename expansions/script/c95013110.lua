--破晓出击
-- 破晓双临
local s, id = GetID()
s.dawn_set = 0x696d  -- 破晓字段代码

function s.initial_effect(c)
	-- 效果①：从卡组把2只卡名不同的「破晓」怪兽在自己·对方的场上各1只特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCost(s.cost)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)  -- 同名卡一回合一次
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- 效果②：墓地除外自身，回收1只「破晓」怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
-- 效果①目标：检查双方场上空位和卡组不同名怪兽
function s.spfilter(c,e,tp,code_list)
	return c:IsSetCard(s.dawn_set) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not code_list[c:GetCode()]
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查自己场上和对方场上是否都有空位
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<=0 then
			return false
		end
		-- 从卡组检查是否存在两只不同名的破晓怪兽
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp,{})
		if #g<2 then return false end
		-- 进一步检查能否选出两个不同名的
		local codes={}
		for tc in aux.Next(g) do
			codes[tc:GetCode()]=true
		end
		local count=0
		for _ in pairs(codes) do
			count=count+1
		end
		return count>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end

-- 效果①操作
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<=0 then return end
	-- 获取卡组所有破晓怪兽
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp,{})
	if #g<2 then return end
	-- 选出两只不同名的
	local selected={}
	local sg=Group.CreateGroup()
	local function select_one()
		local available=g:Filter(function(c) return not selected[c:GetCode()] end,nil)
		if #available==0 then return nil end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=available:Select(tp,1,1,nil):GetFirst()
		selected[tc:GetCode()]=true
		return tc
	end
	local tc1=select_one()
	if not tc1 then return end
	local tc2=select_one()
	if not tc2 then return end
	-- 分别特殊召唤到双方场上
	Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummon(tc2,0,tp,1-tp,false,false,POS_FACEUP)
end

-- 效果②代价：除外自身
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

-- 效果②目标：墓地有破晓怪兽
function s.thfilter2(c)
	return c:IsSetCard(s.dawn_set) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end

-- 效果②操作
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end