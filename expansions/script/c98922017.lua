--劝请之珀耳修斯
local s,id,o=GetID()
function s.initial_effect(c)
	-- 记述有「天空的圣域」
	aux.AddCodeList(c,56433456)
	
	-- 发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	-- 这个卡名的卡1回合只能发动1张
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

-- 检索过滤条件
function s.filter(c)
	local is_parshath = c:IsSetCard(0x10a) and not c:IsCode(id)
	local is_counter_trap = c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER)
	return (is_parshath or is_counter_trap) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		
		local tc=g:GetFirst()
		-- 如果加入手卡的是反击陷阱卡，则应用自肃效果
		if tc:IsType(TYPE_TRAP) and tc:IsType(TYPE_COUNTER) then
			local code=tc:GetCode()
			-- 注册这次决斗中的限制效果
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(s.aclimit)
			e1:SetLabel(code)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

-- 限制发动的逻辑
function s.aclimit(e,re,tp)
	-- 若卡名相同，且场上不存在「天空的圣域」（56433456）则不能发动
	local tc=re:GetHandler()
	-- Duel.IsEnvironment 专门用于检测场地魔法或被当作特定名称处理的卡片
	local has_sanctuary = Duel.IsEnvironment(56433456)
	
	return tc:IsCode(e:GetLabel()) and not has_sanctuary
end
