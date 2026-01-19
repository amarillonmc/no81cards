--永火巫师
local s, id = GetID()

s.infernity_setcode = 0xb

function s.initial_effect(c)
	-- 效果①：特殊召唤规则（手卡只有此卡时可以特殊召唤）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon1)
	c:RegisterEffect(e1)
	
	
	-- 效果②：解放永火怪兽从卡组特殊召唤
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.spcon2)
	e3:SetCost(s.spcost2)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
end

-- 效果①：特殊召唤条件（手卡只有此卡）
function s.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)==1
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

-- 效果②：发动条件（手卡是0张）
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end

-- 效果②：代价（解放自己场上1只永火怪兽）
function s.spfilter(c,tp)
	return c:IsSetCard(s.infernity_setcode) and c:IsReleasableByEffect() and not c:IsCode(id)
end

function s.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.spfilter,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,s.spfilter,1,1,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end

-- 效果②：目标设定（从卡组特殊召唤永火怪兽）
function s.spfilter2(c,e,tp)
	return not c:IsCode(id) and c:IsSetCard(s.infernity_setcode) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- 效果②：操作处理
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)>0 then
			-- 添加自肃效果：直到回合结束时，自己不能从手卡·墓地特殊召唤非永火怪兽
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetTargetRange(1,0)
			e1:SetTarget(s.sumlimit2)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

-- 效果②：自肃限制（不能从手卡·墓地特殊召唤非永火怪兽）
function s.sumlimit2(e,c)
	return not c:IsSetCard(s.infernity_setcode) and c:IsLocation(LOCATION_GRAVE+LOCATION_HAND)
end