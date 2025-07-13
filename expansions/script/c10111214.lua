local s,id,o=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	-- 添加全局效果监控手卡/墓地特殊召唤
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
	ge1:SetOperation(s.regop)
	Duel.RegisterEffect(ge1,0)
	-- 对方特殊召唤时从卡组/墓地特招10星光属性机械族怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon2)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
    	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.tdcon)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
end
-- 记录对方从手卡/墓地特殊召唤
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local loc=tc:GetSummonLocation()
		local p=tc:GetSummonPlayer()
		-- 获取对方玩家索引
		local opp = 1-p
		
		-- 检查是否从手卡或墓地特殊召唤
		if (loc == LOCATION_HAND or loc == LOCATION_GRAVE) then
			-- 使用RESET_DISABLE确保标记在整个决斗中持续
			Duel.RegisterFlagEffect(opp, id, RESET_DISABLE, 0, 1)
		end
	end
end

-- 特殊召唤条件
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	-- 检查对方玩家是否有标记
	return Duel.GetFlagEffect(tp, id) > 0 and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
end

-- 新效果的触发条件：对方特殊召唤怪兽
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(aux.FilterEqualFunction(Card.GetSummonPlayer,1-tp),1,nil)
end

-- 新效果的目标设置（只从卡组选择）
function s.spfilter(c,e,tp)
	return c:IsLevel(10) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and not c:IsCode(id) and c:IsAttackBelow(3000) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,true,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- 新效果的操作：特殊召唤符合条件的怪兽（只从卡组）
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		if tc then
			-- 无视召唤条件特殊召唤
			Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL,tp,tp,true,false,POS_FACEUP)
		end
	end
end

function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=e:GetHandler():GetPreviousLocation()
	return loc&(LOCATION_HAND|LOCATION_DECK)==0
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end