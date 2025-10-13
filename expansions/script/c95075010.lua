-- 怪兽卡：鸣神使者
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：召唤·特殊召唤时发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)	
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end

-- 定义鸣神字段常量
s.thunder_setcode = 0x396e

-- 效果①：目标设定
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_THUNDER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(3)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查墓地是否有可特殊召唤的雷族怪兽
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		-- 检查手卡是否有鸣神卡
		local b2=Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,nil,s.thunder_setcode)
		-- 检查卡组是否有鸣神怪兽
		local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.thunderfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		return b1 or (b2 and b3)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end

-- 鸣神怪兽筛选器
function s.thunderfilter(c,e,tp)
	return c:IsSetCard(s.thunder_setcode) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 同调怪兽筛选器
function s.synchrofilter(c,sc,tuner)
	return c:IsSetCard(s.thunder_setcode) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(5)
end

-- 效果①：操作处理
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	
	-- 检查手卡是否有鸣神卡
	local hand_g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND,0,nil,s.thunder_setcode)
	local show_card=false
	
	if #hand_g>0 then
		-- 让玩家选择是否展示手卡
		if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			-- 选择要展示的手卡
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local sg=hand_g:Select(tp,1,1,nil)
			Duel.ConfirmCards(1-tp,sg)
			show_card=true
			Duel.ShuffleHand(tp)
		end
	end
	
	local tc=nil
	
	if show_card then
		-- 从卡组特殊召唤鸣神怪兽
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.thunderfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		tc=g:GetFirst()
	else
		-- 从墓地特殊召唤雷族怪兽
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		tc=g:GetFirst()
	end
	
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local synchro_g=Duel.GetMatchingGroup(s.synchrofilter,tp,LOCATION_EXTRA,0,nil,c,tc)
		Duel.ShuffleDeck
		
		 (tp)
		Duel.BreakEffect()
		if #synchro_g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=synchro_g:Select(tp,1,1,nil)
			local synchro_monster=sg:GetFirst()
			if synchro_monster then				
				Duel.SynchroSummon(tp,sg:GetFirst(),c)
			end
		end
	end
end