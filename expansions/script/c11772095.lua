local s,id=GetID()
function s.initial_effect(c)
	-- 添加卡名记述
	aux.AddCodeList(c,11772075,11772070)
	
	-- 卡片发动（仅作翻开用，如果是盖放状态下发动并同时使用②效果，见下方 clone 处理）
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	-- ①：只要场上有「11772075」，5星以上怪兽不受对方怪兽效果影响
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tg1)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	
	-- ①：只要场上有「11772075」，对方4星以下怪兽不能攻击
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.con1)
	e2:SetTarget(s.tg2)
	c:RegisterEffect(e2)
	
	-- ②：以5星以上怪兽为对象的效果（场上表侧表示发动）
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)
	

end

-- ==================== ① 效果相关 ====================
function s.cfilter(c)
	-- 检查场上是否有「11772075」
	return c:IsFaceup() and c:IsCode(11772075)
end
function s.con1(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.tg1(e,c)
	-- 对自己场上5星以上的怪兽适用
	return c:IsLevelAbove(5)
end
function s.val1(e,te)
	-- 不受控制者不是自己的怪兽效果影响
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function s.tg2(e,c)
	-- 对对方场上4星以下的怪兽适用
	return c:IsLevelBelow(4)
end

-- ==================== ② 效果相关 ====================
function s.thfilter(c,code)
	-- 检索同名卡
	return c:IsCode(code) and c:IsAbleToHand()
end
function s.setfilter(c)
	-- 检索卡名记述有「11772070」的魔陷并盖放
	return aux.IsCodeListed(c,11772070) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.efftgfilter(c,tp)
	-- 作为对象的条件：表侧表示的5星以上怪兽，且满足下面两个效果中至少一个的处理条件
	if not (c:IsFaceup() and c:IsLevelAbove(5)) then return false end
	local b1 = Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
	local b2 = c:IsReleasableByEffect() and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
	return b1 or b2
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.efftgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.efftgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.efftgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	-- 此时不确定适用哪个效果，暂时不写具体的 Category
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	-- 永续陷阱通用防空发处理：如果卡不在场上，效果不处理
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	
	-- 再次核实满足哪些选项
	local b1 = Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode())
	local b2 = tc:IsReleasableByEffect() and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
	
	if not (b1 or b2) then return end
	local op=0
	if b1 and b2 then
		-- stringid 的 1 和 2 是选项提示，你可以在 strings.conf 加上对应的中文
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	
	if op==0 then
		-- 效果1：加入手卡
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		-- 效果2：解放并盖放
		if Duel.Release(tc,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #sg>0 then
				local sc=sg:GetFirst()
				if Duel.SSet(tp,sc)>0 then
					-- 赋予当回合可以发动的权限
					if sc:IsType(TYPE_TRAP) then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						sc:RegisterEffect(e1)
					elseif sc:IsType(TYPE_QUICKPLAY) then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						sc:RegisterEffect(e1)
					end
				end
			end
		end
	end
end