local s, id = GetID()

function s.initial_effect(c)
	-- 永续魔法设置
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	-- 效果①：攻击力1500以上怪兽不能攻击1星昆虫族
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(s.atkcon)
	e1:SetValue(s.atkcv)
	c:RegisterEffect(e1)
	
	-- 效果②：1星昆虫族战斗伤害提升攻击力
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.damcon)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	
	-- 效果③：被对方破坏时特召「嗡嗡军团」怪兽
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

-- ===== 效果①：攻击限制 =====
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(s.atktg,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end

function s.atkfilter(c)
	return c:IsLevel(1) and c:IsRace(RACE_INSECT)
end

function s.atkcv(e)
	return Duel.IsExistingMatchingCard(s.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function s.atktg(c)
	return c:IsAttackAbove(1500)
end

-- ===== 效果②：战斗伤害提升攻击力 =====
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep==1-tp and tc:IsLevel(1) and tc:IsRace(RACE_INSECT)
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

-- ===== 效果③：被对方破坏时特召 =====
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():IsReason(REASON_EFFECT)
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x3962) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end