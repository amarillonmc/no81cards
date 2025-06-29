-- 爱奥丽菈-幻想同人女-（罗塔字段辅助怪兽）
local s,id=GetID()
function s.initial_effect(c)
	local e0=aux.AddLinkProcedure(c,s.matfil,2,4)
	e0:SetProperty(e0:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(s.spcost)
	c:RegisterEffect(e0)
	-- ①主阶段双效联动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.mphasecon)
	e1:SetTarget(s.mphasetg)
	e1:SetOperation(s.mphaseop)
	c:RegisterEffect(e1)
	
	-- ②墓地回收效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(s.sumcon)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
end
function s.matfil(c)
	return c:IsLinkType(TYPE_EFFECT)
end
function s.ffil(c)
	return c:IsCode(60000228) and c:IsFaceup()
end
function s.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.IsExistingMatchingCard(s.ffil,tp,LOCATION_FZONE,0,1,nil)
end

-- 主阶段条件
function s.mphasecon(e,tp,eg,ep,ev,re,r,rp)
	return  (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end

function s.fit1(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x3624) and not c:IsCode(id)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.mphasetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local e1=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
	local e2=Duel.IsExistingMatchingCard(s.fit1,tp,0,LOCATION_MZONE,1,nil)
	local e3=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return e1 or e2 or e3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local   op=aux.SelectFromOptions(tp,
		{e1,aux.Stringid(id,3)},{e2,aux.Stringid(id,4)},{e3,aux.Stringid(id,5)})	 
	e:SetLabel(op)
end

function s.mphaseop(e,tp,eg,ep,ev,re,r,rp)  
	-- 效果分支处理
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then -- 翻自己里侧
		local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 then
			Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
		end
	elseif op==2 then -- 盖对方表侧
		local g=Duel.SelectMatchingCard(tp,s.fit1,tp,0,LOCATION_MZONE,1,1,nil)
		if #g>0 then
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
	else -- 特召罗塔
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			local sc=g:GetFirst()
			if sc:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(id,6)) then
				Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE)
			end
		end
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g1=Duel.GetMatchingGroup(Card.IsPublic,tp,LOCATION_HAND,0,nil)
	if #g1>0 then
	g:Sub(g1)
	end
	local pg=g:Select(tp,1,1,nil)
	if #pg>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		pg:GetFirst():RegisterEffect(e1)
	end
end

-- ②墓地回收效果
function s.tdfil(c)
	return (c:IsLocation(LOCATION_HAND) and not c:IsPublic())
		or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown())
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	and #Duel.GetDecktopGroup(tp,1)~=0 and c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetDecktopGroup(tp,1)
	if Duel.SendtoGrave(dg,REASON_EFFECT)~=0 and Duel.SendtoDeck(c,nil,1,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(s.tdfil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc:IsLocation(LOCATION_MZONE) then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		elseif tc:IsLocation(LOCATION_HAND) then
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
			local e11=Effect.CreateEffect(c)
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetCode(EFFECT_PUBLIC)
			e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e11)
		end
	end
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end