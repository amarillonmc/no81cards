local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,11772070,11772080)
	
	-- ①：特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	
	-- ②：其他5星以上怪兽特召加攻守（必发）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	
	-- ③：除外或墓地回收/特召
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.con3)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
end

-- ==================== ① 效果相关 ====================
function s.spfilter1(c,e,tp)
	return aux.IsCodeListed(c,11772070) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return false end
		local g=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.diff_code_filter(c,code)
	-- 用于第二步选择：过滤掉与第一张卡同名的卡
	return c:GetCode()~=code
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter1),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		-- 传统写法：先选第1张
		local g1=g:Select(tp,1,1,nil)
		if #g1>0 then
			local tc1=g1:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			-- 传统写法：再选第2张，并要求卡名与第1张不同
			local g2=g:FilterSelect(tp,s.diff_code_filter,1,1,tc1,tc1:GetCode())
			g1:Merge(g2)
			if #g1==2 and Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)>0 then
			end
		end
	end
end
function s.actcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end

-- ==================== ② 效果相关 ====================
function s.cfilter2(c,e,tp)
	-- 当前控制权在自己，且仍然在场上表侧表示
	return c:IsControler(tp) and c:IsFaceup() and c:IsLevelAbove(5) and c~=e:GetHandler()
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter2,1,nil,e,tp)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- 因为是不取对象效果，这里不再使用 Duel.SetTargetCard
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	-- 效果处理时，直接使用事件发生时的组 eg，并过滤出依然在场上满足条件的卡
	local g=eg:Filter(s.cfilter2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end

-- ==================== ③ 效果相关 ====================
function s.cfilter3(c,tp)
	return c:GetPreviousLevelOnField()>=5 and not c:IsCode(11772070)
		and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(s.cfilter3,1,nil,tp)
end
function s.rfilter(c)
	return c:IsLevelAbove(5) and c:IsReleasableByEffect()
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local b1=c:IsAbleToHand()
		local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.CheckReleaseGroup(tp,s.rfilter,1,nil)
		return b1 or b2
	end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=c:IsAbleToHand()
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.CheckReleaseGroup(tp,s.rfilter,1,nil)
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
	elseif b1 then
		op=0
	elseif b2 then
		op=1
	else
		return
	end
	
	if op==0 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=Duel.SelectReleaseGroup(tp,s.rfilter,1,1,nil)
		if #rg>0 and Duel.Release(rg,REASON_EFFECT)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end