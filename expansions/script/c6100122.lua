--女神之令-光秀
local s, id = GetID()

function s.initial_effect(c)

	-- 效果①：主要阶段展示手卡发动
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.mtcost1)
	e1:SetTarget(s.mttg1)
	e1:SetOperation(s.mtop1)
	c:RegisterEffect(e1)
	local e0 = Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id, 1))
	e0:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1, id)
	e0:SetCost(s.mtcost1)
	e0:SetTarget(s.mttg2)
	e0:SetOperation(s.mtop2)
	c:RegisterEffect(e0)
	
	-- 效果②：召唤/特召回合赋予场发效果
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id+1)
	e2:SetCondition(s.sccon)
	e2:SetTarget(s.sctg)
	e2:SetOperation(s.scop)
	c:RegisterEffect(e2)
   --to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end

-- 效果①：目标设置
function s.mtfilter1(c,e,tp)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.mtfilter2(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end

function s.cfilter1(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end

function s.cfilter2(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_TRAP) and not c:IsPublic()
end

function s.mtcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end

function s.mttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(s.mtfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local rc=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,rc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,0,0)
end

-- 效果①：操作处理
function s.mtop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.mtfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #sg>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,sg)
			Duel.SendtoGrave(c,REASON_EFFECT)
		end
end

function s.mttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(s.mtfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_HAND,0,1,nil) end
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
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sc=Duel.SelectMatchingCard(tp,mtfilter2,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if sc then
		Duel.SendtoGrave(sc,REASON_EFFECT)
		end
	end
end

function s.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end

-- 效果②：赋予场发效果
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end

function s.thfilter(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.dcfilter(c)
	return c:IsSetCard(0x611) and c:IsDisabled()
end

function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil)
	-- 丢弃手卡
	if Duel.SendtoGrave(tg,REASON_EFFECT)>0 and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
	   -- 效果①：主要阶段/战斗阶段展示手卡发动
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
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
	e0:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
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
	end
end
