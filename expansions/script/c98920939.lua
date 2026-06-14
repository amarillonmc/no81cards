--№系猎人-光子模式
-- NO猎人
local s,id=GetID()
function s.initial_effect(c)
	-- ①：特召手续
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- ②：被解放时的效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
	
	-- ②：作为超量素材为发动效果被取除送去墓地时的效果
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.spcon2)
	c:RegisterEffect(e3)
end

-- 特召条件：场上有超量素材可以取除
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_COST)
end

-- 特召操作
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	-- 选择场上1个有超量素材的怪兽
	local g=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,1,REASON_COST)
	local tc=g:GetFirst()
	if tc then
		-- 判断是否为「No.」怪兽 (字段 0x48)
		local is_no=tc:IsSetCard(0x48)
		-- 取除素材
		tc:RemoveOverlayCard(tp,1,1,REASON_COST)
		
		-- 如果是「No.」怪兽，数值翻倍
		if is_no then
			-- 等级变为2倍 (增加原本的等级)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(c:GetBaseLevel())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
			c:RegisterEffect(e1)
			-- 攻击力变为2倍
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_ATTACK)
			e2:SetValue(c:GetBaseAttack()*2)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
			c:RegisterEffect(e2)
			-- 守备力变为2倍
			local e3=e2:Clone()
			e3:SetCode(EFFECT_SET_BASE_DEFENSE)
			e3:SetValue(c:GetBaseDefense()*2)
			c:RegisterEffect(e3)
		end
	end
end

-- 作为超量怪兽发动效果的COST送墓
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_OVERLAY) and c:IsReason(REASON_COST) 
		and re and re:IsHasType(0x7f0) and re:GetHandler():IsType(TYPE_XYZ)
end

-- 检索过滤条件：「光子」0x55 或 「银河」0x7b，且4星以下，且非同名卡，且为怪兽
function s.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and (c:IsSetCard(0x55) or c:IsSetCard(0x7b)) 
		and not c:IsCode(id) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 效果② Target
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- 效果② Operation
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end