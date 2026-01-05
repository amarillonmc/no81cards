--朦雨的秘遗·莱伊
local s,id,o=GetID()
function s.initial_effect(c)
	--同调召唤
	--调整＋调整以外的水属性怪兽1只以上
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	c:EnableReviveLimit()

	--①：检索+变星
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) -- 变星不属于主要Category，可选加CATEGORY_LVCHANGE
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	--②：遗言（预约结束阶段盖卡）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.tgfilter(c,tp)
	if not c:IsSetCard(0x613) then return false end
	-- 获取该卡的基础类型（怪兽/魔法/陷阱）
	local ty = c:GetType() & (TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	-- 检查卡组里是否有非此类型的「朦雨」卡
	return ty~=0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,ty)
end

function s.thfilter(c,exclude_type)
	-- 属于「朦雨」且不包含目标卡的基础类型
	return c:IsSetCard(0x613) and c:IsAbleToHand() and not c:IsType(exclude_type)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	
	-- 获取目标卡的类型
	local ty = tc:GetType() & (TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,ty)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			
			local c=e:GetHandler()
			-- 那之后，可以宣言1～12的任意等级，这张卡的等级变成宣言的等级
			if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				local lv=Duel.AnnounceLevel(tp,1,12,e:GetHandler():GetLevel())
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(lv)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
			end
		end
	end
end

-- === 效果② ===
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	-- 注册一个在结束阶段触发的效果
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.setcon)
	e1:SetOperation(s.setop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.setfilter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end

function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	-- 确保只在注册的回合生效（虽然Reset控制了，但双重保险）并且有卡可盖
	return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end