--源能特工 黑梦
-- 源能特工·纵列压制者
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：自己主要阶段2从手卡特殊召唤（规则效果）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon1)
	c:RegisterEffect(e1)

	-- 效果②：自己主要阶段，从卡组把1只「源能特工」怪兽特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)

	-- 效果③：自己·对方回合，使相同纵列及相邻纵列的卡效果无效（决斗中一次）
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+200+EFFECT_COUNT_CODE_DUEL) -- 决斗中一次
	e3:SetTarget(s.distg3)
	e3:SetOperation(s.disop3)
	c:RegisterEffect(e3)
end

-- 效果①条件
function s.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

-- 效果②：从卡组特召「源能特工」怪兽
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0x3962) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- 效果③：发动条件（无特殊条件）
function s.distg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.disop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local seq=c:GetSequence()
	-- 获取双方场上所有表侧表示的卡
	local g=Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
	for tc in aux.Next(g) do
		local tc_seq=tc:GetSequence()
		-- 只考虑主区域（0-4），且排除自身，且纵列在自身所在列及其相邻列
		if  tc~=c and tc_seq>=seq-1 and tc_seq<=seq+1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE_EFFECT)  -- 使卡片效果无效
			e1:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			--e2:SetTarget(s.eftg)
			tc:RegisterEffect(e2)
		end
	end
end
-- 无效过滤器：排除自身，并在相同纵列或相邻纵列的卡
function s.disablefilter(e,c)
	local center=e:GetLabel()
	local seq=c:GetSequence()
	-- 排除自身
	if c==e:GetHandler() then return false end
	-- 只考虑主怪兽区和魔法陷阱区的纵列 (0-4)
	if seq<0 or seq>4 then return false end
	-- 检查是否在中心列的相邻范围内（包括中心列本身）
	return seq>=center-1 and seq<=center+1
end
