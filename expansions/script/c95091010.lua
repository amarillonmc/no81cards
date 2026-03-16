-- 卡片：女神诗蔻蒂的托宣（变体）
local s, id = GetID()
s.valkyrie_set = 0x122
s.codes = {38576155, 64961254, 91969909}  -- 三女神卡号

function s.initial_effect(c)
	-- 决斗开始时变卡并盖放
	if Duel.DisableActionCheck then
		local ct=Duel.GetFieldGroupCount(0,0,LOCATION_DECK+LOCATION_REMOVED)
		local ct2=Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)
		local tp=0
		if ct>0 or ct2>0 then tp=1 end
		local move=(function()
			local ct=Duel.GetFieldGroupCount(0,0,LOCATION_DECK+LOCATION_REMOVED)
			local ct2=Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)
			local tp=0
			if ct>0 or ct2>0 then tp=1 end
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false)
		end)
		Duel.DisableActionCheck(true)
		pcall(move)
		Duel.DisableActionCheck(false)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(0xff)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(s.startop)
	c:RegisterEffect(e1)
end

function s.startcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==1
end

function s.startop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 将自身移动到场上盖放（若不在）
	if not c:IsLocation(LOCATION_SZONE) then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false)
	elseif c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN)
	end

	-- 变成女神诗蔻蒂的托宣
	c:SetEntityCode(38576155, true)

	-- 自肃：不能发动女武神以外的怪兽效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.disvalue)
	e1:SetReset(0)  -- 永久
	Duel.RegisterEffect(e1,tp)

	-- 效果①：三女神在场时，手卡回卡组检索女武神
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1, id+EFFECT_COUNT_CODE_DUEL)  -- 决斗中一次
	e2:SetCondition(s.con1)
	e2:SetTarget(s.tg1)
	e2:SetOperation(s.op1)
	c:RegisterEffect(e2)

	-- 效果②：三女神送墓时，盖放其中一张（一回合一次）
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.con2)
	e3:SetOperation(s.op2)
	Duel.RegisterEffect(e3,tp)
end

-- 自肃判断
function s.disvalue(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsSetCard(s.valkyrie_set)
end

-- 效果①条件：三女神都在场上
function s.con1(e,tp)
	for _,code in ipairs(s.codes) do
		if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,code) then
			return false
		end
	end
	return true
end

-- 效果①目标
function s.thfilter(c)
	return c:IsSetCard(s.valkyrie_set) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- 效果①操作
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if #g1==0 then return end
	if Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g2>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end

-- 效果②条件：有三女神从自己场上送去墓地
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	for _,code in ipairs(s.codes) do
		if eg:IsExists(Card.IsCode,1,nil,code) and eg:FilterCount(Card.IsControler,nil,tp)>0 then
			return true
		end
	end
	return false
end

-- 效果②操作：盖放其中一张（一回合一次）
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id+100)~=0 then return end
	local g=eg:Filter(Card.IsControler,nil,tp):Filter(Card.IsCode,nil,unpack(s.codes))
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false)
		Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE+PHASE_END,0,1)
	end
end