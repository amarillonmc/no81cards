local s, id = GetID()

function s.initial_effect(c)
	-- 可从手牌发动的特殊处理
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	
	-- 效果①：解放昆虫族结束战斗阶段
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- ===== 手牌发动条件 =====
function s.handfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_INSECT)
end
function s.handcon(e)
	return not Duel.IsExistingMatchingCard(s.handfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

-- ===== 效果①处理 =====
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end

function s.relfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsReleasableByEffect()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.relfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 and Duel.Release(g,REASON_EFFECT)>0 then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end