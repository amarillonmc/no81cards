-- 场地魔法卡：魂铸领域
local s, id = GetID()

function s.initial_effect(c)
	
	-- 效果①：发动时从卡组解放1只魂铸意志怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.rltg)
	e1:SetOperation(s.rlop)
	c:RegisterEffect(e1)
	
	-- 效果②：魂铸意志怪兽召唤不会被无效化
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,s.soul_setcode))
	c:RegisterEffect(e2)
	
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	c:RegisterEffect(e3)
	
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e4)
	
	-- 效果③：双方特殊召唤怪兽攻击力·守备力下降800
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(s.atktg)
	e5:SetValue(-800)
	c:RegisterEffect(e5)
	
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
end

-- 定义魂铸意志字段
s.soul_setcode = 0x396c 

-- 效果①：目标设定
function s.rlfilter(c)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end

function s.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.rlfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_DECK)
end

-- 效果①：操作处理
function s.rlop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.rlfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.Release(g,REASON_EFFECT)
	end
end

-- 效果③：目标筛选（特殊召唤的怪兽）
function s.atktg(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end