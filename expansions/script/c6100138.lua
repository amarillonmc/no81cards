--女神之令-授
local s, id = GetID()

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.rstg)
	e1:SetOperation(s.rsop)
	c:RegisterEffect(e1)
end

function s.costfilter1(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

function s.costfilter2(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function s.ritualfilter(c,e,tp)
	return c:IsSetCard(0x611) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end

function s.rstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查是否有足够的卡可以送墓
		local g2=Duel.GetMatchingGroup(s.costfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		local g3=Duel.GetMatchingGroup(s.costfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		return #g2>0 and #g3>0 and Duel.IsExistingMatchingCard(s.ritualfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.rsop(e,tp,eg,ep,ev,re,r,rp)
	-- 选择送墓的卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,s.costfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,s.costfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	
	if #g1==0 or #g2==0 then return end
	g1:Merge(g2)
	
	-- 送墓
	if Duel.SendtoGrave(g1,REASON_EFFECT+REASON_RELEASE)==2 then
		-- 选择仪式怪兽
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.ritualfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			-- 特殊召唤
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			
			-- 赋予不成为效果对象的抗性
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(aux.tgoval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end