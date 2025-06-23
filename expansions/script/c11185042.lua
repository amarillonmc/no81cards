-- 龗龘永续魔法
local s,id=GetID()

function s.initial_effect(c)
	-- 永续魔法特性
		local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- 效果①：展示+检索+丢弃
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	-- 效果②：回合结束抽卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	
	-- 效果③：龙帝攻击力提升
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5450))
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
   local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
end
-- 效果①目标：展示+检索
function s.thfilter1(c,tp)
	return c:IsSetCard(0x5450) and c:IsType(TYPE_MONSTER) and not c:IsPublic()  and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetRace())
end
function s.thfilter(c,race)
	return c:IsSetCard(0x5450) and c:IsType(TYPE_MONSTER) and not c:IsRace(race) and c:IsAbleToHand() 
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_HAND,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end

-- 效果①操作：检索+丢弃
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local race=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,race)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
	
	-- 限制场地魔法发动
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	Duel.RegisterEffect(e1,tp)
end

-- 效果②条件：对方回合结束阶段
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

-- 效果②目标：计算抽卡数量
function s.drfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM+RACE_SEASERPENT+RACE_DINOSAUR+RACE_DRAGON)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.drfilter,tp,LOCATION_MZONE,0,nil)
		local races={}
		for tc in aux.Next(g) do
			races[tc:GetRace()]=true
		end
		local count=0
		for _ in pairs(races) do
			count=count+1
		end
		return count>0 and Duel.IsPlayerCanDraw(tp,count)
	end
	local g=Duel.GetMatchingGroup(s.drfilter,tp,LOCATION_MZONE,0,nil)
	local races={}
	for tc in aux.Next(g) do
		races[tc:GetRace()]=true
	end
	local count=0
	for _ in pairs(races) do
		count=count+1
	end
	e:SetLabel(count)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,count)
end

-- 效果②操作：抽卡
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local count=e:GetLabel()
	if count>0 then
		Duel.Draw(tp,count,REASON_EFFECT)
		
		-- 设置效果发动限制
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.limitval)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end

-- 效果③计算：攻击力提升
function s.atkval(e,c)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)*50
end

-- 限制场地魔法发动
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and not re:GetHandler():IsSetCard(0x5450)
end

-- 效果②限制：不能发动非龗龘卡效果
function s.limitval(e,re,tp)
	return not re:GetHandler():IsSetCard(0x5450)
end
function s.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.limop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsSetCard(0x5450) then
		Duel.NegateEffect(ev)
	end
end
function s.limcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.limop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id)
end
