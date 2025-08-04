--女神之令-信轩
local s, id = GetID()

function s.initial_effect(c)

	-- 效果①：主要阶段展示手卡发动
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.mtcost1)
	e1:SetTarget(s.mttg2)
	e1:SetOperation(s.mtop2)
	c:RegisterEffect(e1)
	local e0 = Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id, 1))
	e0:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1, id)
	e0:SetCost(s.mtcost1)
	e0:SetTarget(s.mttg1)
	e0:SetOperation(s.mtop1)
	c:RegisterEffect(e0)
	
	-- 效果②：召唤/特召回合赋予场发效果
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1, id+1)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(s.sctg)
	e2:SetOperation(s.scop)
	c:RegisterEffect(e2)
	
end

-- 效果①：目标设置
function s.mtfilter1(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.mtfilter2(c,e,tp)
	return c:IsSetCard(0x611) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end

function s.cfilter1(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_TRAP) and not c:IsPublic()
end

function s.cfilter2(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end

function s.mtcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end

function s.mttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(s.mtfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local rc=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,rc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,0,0)
end

-- 效果①：操作处理
function s.mtop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoGrave(c,REASON_EFFECT) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.mtfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

function s.mttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(s.mtfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local rc=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,rc)
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

-- 效果①：操作处理
function s.mtop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.mtfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(2500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end

-- 效果②：赋予场发效果
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end

function s.thfilter(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 丢弃手卡
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,c)>0 and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		-- 赋予场发效果
	   -- 效果①：主要阶段/战斗阶段展示手卡发动
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.mtcost1)
	e1:SetTarget(s.mttg1)
	e1:SetOperation(s.mtop1)
	c:RegisterEffect(e1)
	local e0 = Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id, 1))
	e0:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_MZONE)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	e0:SetCountLimit(1, id)
	e0:SetCost(s.mtcost1)
	e0:SetTarget(s.mttg2)
	e0:SetOperation(s.mtop2)
	c:RegisterEffect(e0)
	 Duel.SpecialSummonComplete()
			if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id, 3)) then
			Duel.BreakEffect()
			-- 从卡组加入魔法卡
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
			end
	end
end

