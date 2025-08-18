--英豪挑战召集

local s, id = GetID()

function s.initial_effect(c)

	-- 效果1：从手卡和卡组送墓，特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- 效果2：墓地发动，改变表示形式
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.poscon)
	e2:SetCost(s.poscost)
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)
end
function s.tdfilter(c)
   return c:IsSetCard(0x6f) and c:IsAbleToGraveAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		-- 检查手卡和卡组是否有「英豪」卡
		local hg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND,0,nil,0x6f)
		local dg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x6f)
		return hg:GetCount()>0 and dg:GetCount()>0 
	end
	
	-- 选择手卡1张英豪卡
	local hg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,nil,0x6f)
	-- 选择卡组1张英豪卡
	local dg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x6f)
	if #hg==0 or #dg==0 then return end
	hg:Merge(dg)
	Duel.SendtoGrave(hg,REASON_COST)
end
-- 效果1：目标检查
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- 效果1：特殊召唤过滤
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x106f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 效果1：操作
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		-- 特殊召唤英豪挑战者怪兽
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			local tc=g:GetFirst()
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
				-- 攻击力翻倍
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK)
				e1:SetValue(tc:GetBaseAttack()*2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				-- 主要阶段效果无效化
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE)
				e2:SetCondition(s.discon)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
end

-- 主要阶段无效条件
function s.discon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_MAIN1 and ph<=PHASE_MAIN2
end

-- 效果2：条件（LP500以下）
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=500
end

-- 效果2：代价（除外自身）
function s.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

-- 效果2：目标（对方场上1只怪兽）
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end

-- 效果2：操作（改变表示形式）
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local pos=0
		if tc:IsAttackPos() then
			pos=POS_FACEUP_DEFENSE
		else
			pos=POS_FACEUP_ATTACK
		end
		Duel.ChangePosition(tc,pos)
	end
end

-- 全局一回合一次检查
function s.global_check(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)>0 then
		c:ResetFlagEffect(id)
	end
end
