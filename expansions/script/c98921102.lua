--真魔导法皇 审判之海隆
local s,id,o=GetID()
function c98921102.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),7,3,c98921102.ovfilter,aux.Stringid(98921102,1))	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921102,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98921102.actcon)
	e1:SetCost(c98921102.actcost)
	e1:SetTarget(c98921102.target)
	e1:SetOperation(c98921102.activate)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(98921102,1))
e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
e2:SetCode(EVENT_CHAINING)
e2:SetProperty(EFFECT_FLAG_DELAY)
e2:SetRange(LOCATION_MZONE)
e2:SetCountLimit(1) 
e2:SetCondition(c98921102.cond2)
e2:SetTarget(c98921102.tg2)
e2:SetOperation(c98921102.op2)
c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.thcon2)
	e3:SetTarget(s.thtg2)
	e3:SetOperation(s.thop2)
	c:RegisterEffect(e3)
end
function c98921102.ovfilter(c)
	return c:IsFaceup() and c:IsCode(92918648)
end
function c98921102.actcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c98921102.costfilter(c,tp)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
		and not Duel.IsExistingMatchingCard(c98921102.excfilter,tp,LOCATION_REMOVED,0,1,nil,c:GetCode())
end
function c98921102.excfilter(c,code)
	return c:GetCode()==code and c:GetReason()==REASON_COST and c:GetReasonEffect():GetHandler()==c98921102
end
function c98921102.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and Duel.IsExistingMatchingCard(c98921102.costfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	
	-- 取除超量素材
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	
	-- 选择并除外魔导书魔法
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98921102.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
   		e:SetLabel(tc:GetCode())
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98921102.rmlimit)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function c98921102.rmlimit(e,c,tp,r,re)
	return c:IsCode(e:GetLabel()) and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsCode(98921102) and r==REASON_COST
end
function c98921102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98921102.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c98921102.cond2(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandlerPlayer() == tp
		and re:GetHandler():IsSetCard(0x106e)  -- 魔导书系列
		and re:IsActiveType(TYPE_SPELL)		-- 魔法卡类型
end
function c98921102.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		-- 检查对方场上有可破坏的魔陷
		return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP)
	end
	-- 存储发动的魔法卡
	e:SetLabelObject(re:GetHandler())
	-- 设置破坏目标
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98921102.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()  -- 获取发动的魔法卡
	if not rc then return end
	
	-- 将发动的魔法卡除外
	if rc:IsRelateToEffect(e) or rc:IsLocation(LOCATION_GRAVE) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
	
	-- 破坏对方场上1张魔法·陷阱卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp)
end
function s.thfilter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL)
		and c:IsSetCard(0x106e)
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_REMOVED,0,1,3,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end