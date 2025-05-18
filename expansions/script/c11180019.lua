-- 龙裔幻殇永续
local s, id = GetID()

function s.initial_effect(c)
	-- Continuous Trap type  
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- ①: Destroy same type card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
	-- ②: Destroy facedown when sent to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.gycon)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
	
	-- ③: Flip face-down when banished
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.rmcon)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end

-- ①: Cost function
function s.costfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and 
		   (c:IsAbleToGrave() or c:IsAbleToRemove())
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local types={}
	for tc in aux.Next(g) do
		local ttype=tc:GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		if ttype>0 and not types[ttype] then
			types[ttype]=true
		end
	end
	
	-- 2. 检测手卡/场上是否有可送去墓地/除外的同类型卡
	if chk==0 then
		for ttype,_ in pairs(types) do
			local sg=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler(),ttype)
			if #sg>0 then return true end
		end
		return false
	end
	
	-- 选择操作
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local types_list={}
	for ttype,_ in pairs(types) do
		table.insert(types_list,ttype)
	end
	table.sort(types_list)
	
	-- 让玩家选择要处理的卡类型
	local ttype=nil
	if #types_list>1 then
		local opts={}
		for i,v in ipairs(types_list) do
			if v&TYPE_MONSTER>0 then
				table.insert(opts,aux.Stringid(id,5)) -- 怪兽
			elseif v&TYPE_SPELL>0 then
				table.insert(opts,aux.Stringid(id,6)) -- 魔法
			elseif v&TYPE_TRAP>0 then
				table.insert(opts,aux.Stringid(id,7)) -- 陷阱
			end
		end
		local opt=Duel.SelectOption(tp,table.unpack(opts))
		ttype=types_list[opt+1]
	else
		ttype=types_list[1]
	end
	
	-- 选择要送去墓地/除外的卡
	local sg=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),ttype)
	local tc=sg:GetFirst()
	local opt=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
	if opt==0 then
		Duel.SendtoGrave(tc,REASON_COST)
		e:SetLabel(tc:GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP))
	else
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
		e:SetLabel(tc:GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP))
	end

end
function s.costfilter(c,ttype)
	return c:IsAbleToGrave() or c:IsAbleToRemove() and
		   c:IsType(ttype) and
		   (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
-- ①: Target function
function s.desfilter(c,ty)
	return c:IsFaceup() and c:IsType(ty) and c:IsCanBeEffectTarget()
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ty=e:GetLabel()
	if chkc then return chkc:IsOnField() and s.desfilter(chkc,ty) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,ty) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,ty)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

-- ①: Operation
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

-- ②: Condition for being sent to GY
function s.sentfilter(c)
	return c:IsSetCard(0x146) or c:IsSetCard(0x147) -- "Dragonborn" or "Phantom Sorrow"
end

function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	return re and 
		   (re:GetHandler():IsSetCard(0x3450) or re:GetHandler():IsSetCard(0x6450))
end

-- ②: Target for destroying facedown
function s.gyfilter(c)
	return c:IsFacedown() and c:IsCanBeEffectTarget()
end

function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.gyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.gyfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.gyfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

-- ②: Operation
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

-- ③: Condition for being banished
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re and 
		   (re:GetHandler():IsSetCard(0x3450) or re:GetHandler():IsSetCard(0x6450))
end

-- ③: Target for flipping face-down
function s.rmfilter(c)
	return c:IsFaceup() and c:IsCanBeEffectTarget() and c:IsCanTurnSet()
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end

-- ③: Operation
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
