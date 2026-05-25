--朦雨的远目·艾科
local s,id,o=GetID()
function s.initial_effect(c)

	aux.AddLinkProcedure(c,nil,2,99,s.lcheck)
	c:EnableReviveLimit()
	
	--①：连接区有怪兽则加攻+抗性
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.lkcon)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	
	--②：三选一 (二速)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(2,id)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)
	
end

-- 连接素材检查
function s.lfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO)
end
function s.lcheck(g)
	return g:IsExists(s.lfilter,1,nil)
end

-- === 效果① ===
function s.lkcon(e)
	return e:GetHandler():GetLinkedGroupCount() > 0
end

-- === 效果② ===
function s.tgfilter(c,atk,b1,b2)
	if not (c:IsFaceup() and c:GetAttack() < atk) then return false end
	-- b1 代表"破坏"选项尚未被使用过
	local can_des = b1
	-- b2 代表"无效"选项尚未被使用过，且该怪兽可以被无效
	local can_dis = b2 and aux.NegateAnyFilter(c)
	return can_des or can_dis
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local b1 = Duel.GetFlagEffect(tp,id)==0
	local b2 = Duel.GetFlagEffect(tp,id+1)==0
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc,c:GetAttack(),b1,b2) end
	if chk==0 then return (b1 or b2) and Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack(),b1,b2) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c:GetAttack(),b1,b2)
	local tc=g:GetFirst()
	
	local can_des = b1
	local can_dis = b2 and aux.NegateAnyFilter(tc)
	local op=0
	
	-- 根据当前合法且未被使用过的选项弹出选择窗口
	if can_des and can_dis then
		op = Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif can_des then
		op = Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		op = Duel.SelectOption(tp,aux.Stringid(id,1)) + 1
	end
	e:SetLabel(op)
	
	if op==0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local op=e:GetLabel()
	
	if op==0 then
		-- ●那只怪兽破坏。
		Duel.Destroy(tc,REASON_EFFECT)
		
	elseif op==1 then
		-- ●那只怪兽的效果无效化。
		if tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		end
	end
end