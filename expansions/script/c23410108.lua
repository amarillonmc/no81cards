--狂潮
local s,id=GetID()

function s.initial_effect(c)
	-- 添加卡名记述
	aux.AddCodeList(c,23410101)
	
	-- ① 主要效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- ② 墓地回收效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+10000000)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

-- ① 特殊召唤目标
function s.spfilter(c,e,tp)
	return c:IsCode(23410101) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- ① 效果处理
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local c=e:GetHandler()
		-- 盖放发动时的追加效果
		if not e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
			local op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
			if op==0 then
				-- 直接盖放
				Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
				c:CancelToGrave()
			else
				-- 支付LP强化
				local lp=Duel.GetLP(tp)
				if Duel.PayLPCost(tp,math.floor(lp/2)) then
					-- 攻击力提升
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetTargetRange(LOCATION_MZONE,0)
					e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,23410101))
					e1:SetValue(math.floor(lp/2))
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
					-- 效果抗性
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetCode(EFFECT_IMMUNE_EFFECT)
					e2:SetTargetRange(LOCATION_MZONE,0)
					e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,23410101))
					e2:SetValue(s.efilter)
					e2:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e2,tp)
				end
			end
		end
	end
end

-- ② 条件判断
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

-- ② 目标设置
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
-- ② 效果处理
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c) then
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,23410101)
			and Duel.IsPlayerCanDraw(tp,1) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

-- 效果过滤
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end