-- 龗龘连接怪兽
local s,id=GetID()

function s.initial_effect(c)
	-- 连接怪兽特性
	c:EnableReviveLimit()
	
	-- 连接召唤条件
	aux.AddLinkProcedure(c,s.matfilter,2)
	
	-- 效果①：连接召唤成功时处理墓地怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.lkcon)
	e1:SetTarget(s.lktg)
	e1:SetOperation(s.lkop)
	c:RegisterEffect(e1)
	
	-- 效果②：主要阶段特召墓地龗龘怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- 连接素材条件
function s.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x5450)
end

-- 效果①条件：连接召唤成功
function s.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.spfilter0(c,e,tp,zone)
	return  ( c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 ) or c:IsAbleToDeck()
end
function s.fit1(c)
	return c:IsLink(2)
end
-- 效果①目标：选择墓地1只怪兽
function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=Duel.GetMatchingGroup(s.fit1,tp,LOCATION_MZONE,0,nil)
	local zone=0
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetLinkedZone())
	end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE)  and s.spfilter0(chkc,e,tp,zone) end
	if chk==0 then return  Duel.IsExistingMatchingCard(s.spfilter0,tp,LOCATION_GRAVE,0,1,nil,e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

-- 效果①操作：选择效果处理
function s.lkop(e,tp,eg,ep,ev,re,r,rp)
	local lg=Duel.GetMatchingGroup(s.fit1,tp,LOCATION_MZONE,0,nil)
	local zone=0
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetLinkedZone())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,s.spfilter0,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,zone)
	if #g>0 then
		local tc=g:GetFirst()
		local op=aux.SelectFromOptions(tp,
		{tc:IsAbleToDeck(),aux.Stringid(id,2)},
		{Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone),1152})
			-- 返回卡组
			if op==1 then
				Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			elseif op==2 then
						Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
			end
	end
end

-- 效果②目标：选择墓地1只龗龘怪兽
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5450) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

-- 效果②操作：特殊召唤并设置限制
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 and  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tc=g:GetFirst() 
		-- 效果无效化
		
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		
		-- 种族限制
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetTarget(s.splimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end

-- 效果②的种族限制
function s.splimit(e,c)
	return not c:IsRace(RACE_DRAGON+RACE_DINOSAUR+RACE_SEASERPENT+RACE_WYRM)
end
