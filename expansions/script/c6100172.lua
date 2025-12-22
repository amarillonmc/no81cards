--破碎世界的教皇-对立
local s,id,o=GetID()
function s.initial_effect(c)
	--超量召唤
	-- Xyz Summon
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,3,3)
	c:EnableReviveLimit()
	
	--只能在自己场上存在1只
	c:SetUniqueOnField(1,0,id)

	--①：特召堆墓 + 条件获得纵列无效
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)

	--②：加攻 + (通常素材)无效除外
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.atkcost)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end

-- === 超量素材过滤器 ===
function s.mfilter(c,xyzc)
	return (c:IsRace(RACE_SPELLCASTER) and c:IsLevel(9)) or (c:IsSetCard(0x616) and c:IsLevel(3))
end

-- === 效果① ===
function s.tgfilter(c)
	return c:IsSetCard(0x616) and c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function s.countfilter(c)
	return c:IsSetCard(0x616) and c:IsType(TYPE_TRAP)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		
		-- 检查场上·墓地「破碎世界」陷阱卡种类
		local ct=Duel.GetMatchingGroup(s.countfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
		local c=e:GetHandler()
		
		if ct>=4 and c:IsRelateToEffect(e) and c:IsFaceup() then
			-- 注册纵列无效效果
			-- 提示玩家已获得效果
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
			
			-- 效果无效
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0,LOCATION_ONFIELD)
			e1:SetTarget(s.distarget)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			-- 发动无效
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			c:RegisterEffect(e2)
			-- 陷阱怪兽无效
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			c:RegisterEffect(e3)
		end
	end
end

function s.distarget(e,c)
	return c:IsControler(1-e:GetHandlerPlayer()) and c:GetColumnGroup()
end

-- === 效果② ===
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	
	-- 记录是否移除了通常怪兽
	if tc:IsType(TYPE_NORMAL) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	
	Duel.SendtoGrave(sg,REASON_COST)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 攻击力上升
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	
	-- 如果移除了通常怪兽，追加效果
	if e:GetLabel()==1 then
		local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
				if tc then
					Duel.HintSelection(sg)
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
				Duel.AdjustInstantly()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
				end
		end
	end
end