--影牙 艾莉莎
-- 影牙追踪者
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：战斗阶段从手卡特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- 效果②：攻击宣言过的自己战斗阶段才能发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.actcon)
	e2:SetTarget(s.acttg)
	e2:SetOperation(s.actop)
	c:RegisterEffect(e2)
	
	-- 全局攻击宣言检测
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

-- 全局攻击宣言检测操作
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	  Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
	  Duel.RegisterFlagEffect(1-tp,id+2,RESET_PHASE+PHASE_END,0,1)
end

-- 效果①：发动条件（战斗阶段）
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end

-- 效果①：特殊召唤目标
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

-- 效果①：特殊召唤操作
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- 效果②：发动条件（自己战斗阶段且攻击宣言过）
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
		 and Duel.GetFlagEffect(tp,id+2)>0
end

-- 效果②：目标设定
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查卡组是否有影牙怪兽可以送墓
		return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE)
end

-- 送墓过滤器（影牙怪兽）
function s.tgfilter(c)
	return c:IsSetCard(0xc96c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsCode(id) 
end

-- 回收过滤器（影牙魔法卡）
function s.thfilter(c)
	return c:IsSetCard(0xc96c) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end

-- 效果②：操作处理
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	-- 从卡组送墓1只影牙怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		-- 那之后，可以从墓地把1张影牙魔法卡加入手卡
		local g2=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE,0,nil)
		if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g2:Select(tp,1,1,nil)
			if #sg>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end