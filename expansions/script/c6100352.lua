--永世的凝结
local s,id,o=GetID()
function s.initial_effect(c)
	--①：发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--手卡发动许可
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end

-- 检查是否有可解放的水属性连接怪兽
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_LINK) and c:IsReleasable()
end

-- 手卡发动条件：存在Cost所需的怪兽
function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

-- 发动代价
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 如果是从手卡发动，必须能解放怪兽
		if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
			return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		else
			return true
		end
	end
	-- 只有从手卡发动时才执行解放
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Release(g,REASON_COST)
	end
end

-- 取对象过滤器：自己的场上·墓地 水属性 连接怪兽
function s.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_LINK)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and s.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_MZONE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local lk=tc:GetLink()
		-- 选最多有那个连接标记数量的对方场上的怪兽
		if lk>0 then
			local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_MZONE,nil)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
				-- 1到lk张
				local sg=g:Select(tp,1,lk,nil)
				if #sg>0 then
					Duel.HintSelection(sg)
					local c=e:GetHandler()
					for sc in aux.Next(sg) do
						Duel.NegateRelatedChain(sc,RESET_TURN_SET)
						-- 攻击力·守备力变成0
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_SET_ATTACK_FINAL)
						e1:SetValue(0)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						sc:RegisterEffect(e1)
						local e2=e1:Clone()
						e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
						sc:RegisterEffect(e2)
						-- 效果无效化
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetCode(EFFECT_DISABLE)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD)
						sc:RegisterEffect(e3)
						local e4=Effect.CreateEffect(c)
						e4:SetType(EFFECT_TYPE_SINGLE)
						e4:SetCode(EFFECT_DISABLE_EFFECT)
						e4:SetValue(RESET_TURN_SET)
						e4:SetReset(RESET_EVENT+RESETS_STANDARD)
						sc:RegisterEffect(e4)
					end
				end
			end
		end
	end
end