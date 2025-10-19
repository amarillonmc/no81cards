-- 卡片：魂铸意志的召唤师
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：展示手卡特召并上级召唤（自己回合）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost1)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	
	-- 效果①：展示手卡特召并上级召唤（对方回合，存在遗忘之地时）
	local e0=e1:Clone()
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCondition(s.spcon1)
	c:RegisterEffect(e0)
	
	-- 效果②：解放怪兽特召墓地怪兽（双方回合）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.spcost2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end

-- 定义字段常量
s.soul_setcode = 0x396c -- 魂铸意志字段

-- 效果①：存在遗忘之地时的发动条件
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,95015000)
end

-- 效果①：代价（展示手卡）
function s.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end

-- 效果①：目标设定
function s.spfilter1(c,e,tp)
	return c:IsSetCard(s.soul_setcode) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end

function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

-- 效果①：操作处理
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- 从墓地里侧守备表示特殊召唤4星以下魂铸意志怪兽
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
			Duel.ConfirmCards(1-tp,tc)
			
			-- 表侧表示进行这张卡的上级召唤
			if c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
				and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) then
				Duel.BreakEffect()
				Duel.Summon(tp,c,true,nil,1)
			end
		end
	end
end

-- 效果②：代价（解放这张卡以外的自己场上1只怪兽）
function s.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,Card.IsReleasableByEffect,1,e:GetHandler())
	end
	local g=Duel.SelectReleaseGroup(tp,Card.IsReleasableByEffect,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end

-- 效果②：目标设定
function s.spfilter2(c,e,tp)
	return c:IsSetCard(s.soul_setcode) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
			and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_GRAVE,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end

-- 效果②：操作处理
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	
	-- 从墓地里侧守备表示特殊召唤2只魂铸意志怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>2 then ct=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	if g:GetCount()>0 then
		local t1=g:GetFirst()
		local t2=g:GetNext()
		Duel.SpecialSummonStep(t1,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		if t2 then
			Duel.SpecialSummonStep(t2,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		end
		Duel.SpecialSummonComplete()
	end
end