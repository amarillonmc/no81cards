-- 魁杓七圣-破军瑶光
local s,id=GetID()

function s.initial_effect(c)
	-- ①：战阶二速展示自身和本家特召（同一连锁上最多1次）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	-- 0代表不限制回合次数，EFFECT_COUNT_CODE_CHAIN 代表同一连锁最多1次
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN) 
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- ②：相同纵列的对方怪兽效果无效
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(s.distg)
	c:RegisterEffect(e2)

	-- ③：从场上以外送墓检索/回收本家或「星落九霄」
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id) -- 这个卡名的③效果1回合1次
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

-- ==================== ①效果：展示并双重特召 ====================
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function s.cfilter(c,e,tp)
	-- 寻找手卡中可以被特召的本家怪兽
	return c:IsSetCard(0x3328) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 检查：自己能特召、不被“青眼精灵龙”等卡片限制（不能同时特召2只）、有两个以上的空位、并且手卡有本家
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,c,e,tp)
	g:AddCard(c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	
	-- 给被展示的2张卡打上标记，仅在这个连锁（RESET_CHAIN）内有效，方便处理时精准找到它们
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end -- 已经在Cost里把所有的条件预判好了
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	-- 通过标记找回刚才展示的那两张卡
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(function(c) return c:GetFlagEffect(id)>0 end,tp,LOCATION_HAND,0,nil)
	if #g~=2 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end

-- ==================== ②效果：相同纵列无效 ====================
function s.distg(e,c)
	-- 核心判定：对方怪兽(c)所在的纵列，是否包含这张卡(e:GetHandler())
	return e:GetHandler():GetColumnGroup():IsContains(c)
end

-- ==================== ③效果：场上以外送墓检索 ====================
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.thfilter(c)
	-- 必须是「魁杓七圣」怪兽（除同名卡） 或者 是「星落九霄」（代码 33201858）
	local is_archetype = c:IsSetCard(0x3328) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
	local is_magic = c:IsCode(33201858)
	return (is_archetype or is_magic) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	-- 配合 NecroValleyFilter，防止王家谷状态下试图从墓地检索
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end