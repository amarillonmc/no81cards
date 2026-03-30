--四季的鲜花之主
local s,id=GetID()
function s.initial_effect(c)
	--连接召唤：植物族怪兽3只以上
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PLANT),3,5)
	
	--①：素材检查与状态赋予 (标准写法)
	--1. 特召成功时触发的操作（赋予属性与抗性）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(s.immcon)
	e1:SetOperation(s.immop)
	c:RegisterEffect(e1)
	--2. 素材检查（连接召唤时检查素材信息）
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	e2:SetLabelObject(e1) --将检查结果传递给e1
	c:RegisterEffect(e2)

	--②：回收墓地 & 解放对方卡片
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.mcon)
	e3:SetTarget(s.mtg)
	e3:SetOperation(s.mop)
	c:RegisterEffect(e3)

	--③：送墓特召
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,id+1)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end

--①：Material Check (valcheck)
function s.matfilter(c)
	return c:GetLink()>=3
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	--如果有Link-3以上的素材，设置Label为1，否则为0
	if g:IsExists(s.matfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end

--①：Condition (检查召唤方式和Label)
function s.immcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end

--①：Operation (赋予属性和抗性)
function s.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--变成风属性
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_WIND)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	--不受植物族以外的效果影响
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetValue(s.efilter)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end

--①：抗性过滤器
function s.efilter(e,te)
	return not te:GetHandler():IsRace(RACE_PLANT)
end

--②：Condition
function s.mcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

--②：Target
function s.thfilter(c)
	return c:IsRace(RACE_PLANT) and (c:IsAbleToHand() or c:IsAbleToDeck())
end
function s.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return ct>0 
		and Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,2,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g-1,0,0)
end

--②：Operation
function s.mop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==1 then
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	elseif sg:GetCount()>1 then
		local og=sg:Filter(Card.IsAbleToDeck,nil)
		local sg1=nil
		if og:GetCount()==0 then
			return
		elseif og:GetCount()==1 then
			sg1=sg-og
		elseif og:GetCount()>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			sg1=sg:Select(tp,1,1,nil)
		end
		local c=e:GetHandler()
		if Duel.SendtoHand(sg1,nil,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
			Duel.ConfirmCards(1-tp,sg1)
			sg:Sub(sg1)
			local sc=sg:GetFirst()
			if sc:IsAbleToDeck() then
				Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
			end
		end
	end
		local og=Duel.GetOperatedGroup()
			ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 and Duel.IsExistingTarget(Card.IsReleasableByEffect,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
			Duel.HintSelection(rg)
			Duel.Release(rg,REASON_EFFECT)
		end
end

--③：送墓 Condition
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK)
end

--③：Target
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

--③：Operation
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end