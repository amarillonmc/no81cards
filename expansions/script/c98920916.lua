--微风吹拂
--微风吹拂
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 效果1的过滤条件：4星以下、风属性、反转怪兽
function s.thspfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_FLIP)
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)))
end

-- 效果2的过滤条件：4星以下、「凭依装着」怪兽
function s.spfilter(c,e,tp)
	-- 0x914c 是「凭依装着」的字段
	return c:IsLevelBelow(4) and c:IsSetCard(0x10c0)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(s.thspfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		-- 提示玩家选择效果 (此处使用系统自带的加入手卡/特召提示)
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	-- 记录发动过的选项，保证1回合各1次
	Duel.RegisterFlagEffect(tp,id+op,RESET_PHASE+PHASE_END,0,1)
	
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thspfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			local b1=tc:IsAbleToHand()
			local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
			local res=0
			if b1 and b2 then
				-- 1190是“加入手卡”，1152是“特殊召唤”的系统字符代码
				res=Duel.SelectOption(tp,1190,1152)
			elseif b1 then
				res=0
			else
				res=1
			end
			if res==0 then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			-- SUMMON_TYPE_SPECIAL+1 在YGOPRO中代表当作凭依装着自身效果特召，赋予其贯穿等特性
			Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
		end
	end
end
