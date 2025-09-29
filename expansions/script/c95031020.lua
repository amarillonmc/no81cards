-- 场地魔法卡：剑技修炼场
local s, id = GetID()

function s.initial_effect(c)
	-- 场地魔法卡
	c:EnableCounterPermit(0x96e) -- 使用0x96e作为剑气指示物类型
	
	-- 效果①：发动时从卡组把1只普通剑客加入手卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	--e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	-- 效果②：自己场上的普通剑客攻击力·守备力提升100
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,s.swordman_id))
	e2:SetValue(100)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
	-- 效果③：剑技魔法卡发动时放置剑气指示物
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.ctcon)
	e4:SetOperation(s.ctop)
	c:RegisterEffect(e4)
	
	-- 效果④：去除4个剑气指示物，除外对方场上·墓地·手卡1张卡
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,id+1)
	e5:SetCost(s.rmcost)
	e5:SetTarget(s.rmtg)
	e5:SetOperation(s.rmop)
	c:RegisterEffect(e5)
end

-- 定义卡号常量
s.swordman_id = 95031010  -- 普通剑客
s.sword_tech_setcode = 0x960  -- 剑技字段

-- 效果①：目标设定
function s.thfilter(c)
	return c:IsCode(s.swordman_id) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- 效果①：操作处理
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
	   local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	   if #g>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
	   end
	end
end

-- 效果③：条件判断（剑技魔法卡发动时）
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(s.sword_tech_setcode)
		and re:GetHandler():IsType(TYPE_SPELL)
end

-- 效果③：操作处理（放置剑气指示物）
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x96e,1)
end

-- 效果④：代价（去除4个剑气指示物）
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x96e,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x96e,4,REASON_COST)
end

-- 效果④：目标设定
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND)
end

-- 效果④：操作处理
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	-- 选择除外位置
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	local loc
	if op==0 then
		loc=LOCATION_ONFIELD
	elseif op==1 then
		loc=LOCATION_HAND
	end
	
	local g
	if loc==LOCATION_HAND then
		-- 手卡随机选择
		g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #g>0 then
			local tc=g:RandomSelect(tp,1):GetFirst()
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	else
		-- 场上或墓地选择
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,loc,1,1,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end