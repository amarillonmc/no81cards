--破晓的黎明
local s, id = GetID()
s.dawn_set = 0x696d  -- 破晓字段代码

function s.initial_effect(c)
	-- 发动效果（放置到场上）
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- 效果①：主要阶段从手卡·墓地特召「破晓」怪兽到对方场上
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)

	-- 效果②：永续效果，自己场上的「破晓」怪兽不受暗属性怪兽效果影响
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.immfilter)
	e2:SetValue(s.immval)
	c:RegisterEffect(e2)

	-- 效果③：怪兽特殊召唤时，以自己场上1只超量怪兽为对象，进行同调召唤
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.sccon)
	e3:SetTarget(s.sctg)
	e3:SetOperation(s.scop)
	c:RegisterEffect(e3)
end

-- 效果①：从手卡·墓地选一只「破晓」怪兽特殊召唤到对方场上
function s.spfilter(c,e,tp)
	return c:IsSetCard(s.dawn_set) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
	end
end

-- 效果②：免疫暗属性怪兽效果
function s.immfilter(e,c)
	return c:IsSetCard(s.dawn_set)
end
function s.immval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsAttribute(ATTRIBUTE_DARK)
end

function s.sccon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end

-- 目标阶段
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsType(TYPE_XYZ) end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ)
			and Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_MZONE,0,1,nil) -- 存在3星调整以外的怪兽
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_XYZ)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

-- 素材过滤：3星调整以外的怪兽
function s.mfilter(c)
	return c:IsFaceup() and c:IsLevel(3) and not c:IsType(TYPE_TUNER)
end

-- 操作处理
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()  -- 超量怪兽对象
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end

	-- 选择另一只3星调整以外的怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mg=Duel.SelectMatchingCard(tp,s.mfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #mg==0 then return end
	local nc=mg:GetFirst()
	if not nc then return end

	-- 计算所需的等级 = 超量怪兽的阶级 + 3星怪兽的等级
	local lv = tc:GetRank() + nc:GetLevel()

	-- 从额外卡组选择一只等级为lv的同调怪兽
	local sg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,lv)
	if #sg==0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=sg:Select(tp,1,1,nil):GetFirst()
	if not sc then return end

	-- 将两只素材送去墓地
	local mat=Group.FromCards(tc,nc)
	if Duel.SendtoGrave(mat,REASON_EFFECT)==0 then return end

	-- 特殊召唤同调怪兽（视为同调召唤）
	Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure()
end

-- 过滤额外卡组的同调怪兽，要求等级等于lv且是可以特殊召唤的
function s.synfilter(c,lv)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv)
end