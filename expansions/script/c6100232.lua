--朦雨的过客·晓
local s,id,o=GetID()
function s.initial_effect(c)
	--①：检索 + 变星
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--②：赋予抗性
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.effcon)
	e3:SetCost(s.effcost)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)
end

-- === 效果① ===
function s.thfilter(c)
	return c:IsSetCard(0x613) and c:IsAbleToHand()
end

function s.lvfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and not c:IsPublic()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			local c=e:GetHandler()
			-- 检索成功后，处理变星逻辑
			if c:IsRelateToEffect(e) and c:IsFaceup() 
				and Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_HAND,0,1,nil) 
				and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
				local cg=Duel.SelectMatchingCard(tp,s.lvfilter,tp,LOCATION_HAND,0,1,1,nil)
				if #cg>0 then
					Duel.ConfirmCards(1-tp,cg)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_ADD_TYPE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(TYPE_TUNER)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					c:RegisterEffect(e1)
				end
			end
		end
	end
end

-- === 效果② ===
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	-- 发动时已有至少1个连锁链，意味着此卡必定作为连锁2或以上发动
	return Duel.GetCurrentChain() >= 3
end

function s.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local cl=Duel.GetCurrentChain()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetLabel(cl)
	e1:SetCondition(s.retcon)
	e1:SetOperation(s.retop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.retfilter(c,tp)
	-- 原持有者是发动者，且不在场上被当成衍生物
	return c:IsPreviousControler(tp) and not c:IsType(TYPE_TOKEN) and c:IsLocation(LOCATION_REMOVED)
end

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	-- 事件里包含自己的卡，且可用次数大于0
	return eg:IsExists(s.retfilter,1,nil,tp) and e:GetLabel()>0
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.retfilter,nil,tp)
	if #g==0 then return end
	
	-- 询问是否使用其中1次权利
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_CARD,0,id) -- 弹个本卡的卡图提示来源
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		if #sg>0 then
			Duel.HintSelection(sg)
			-- 把选中的除外的卡回到墓地
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
			-- 次数减1
			e:SetLabel(e:GetLabel()-1)
		end
	end
end