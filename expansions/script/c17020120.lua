--授权！升级！
local m=17020120
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand and spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17020120,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,17020120)
	e2:SetCost(cm.tscost)
	e2:SetTarget(cm.tstg)
	e2:SetOperation(cm.tsop)
	c:RegisterEffect(e2)
end
function cm.filter1(c,tp,slv)
	local lv1=c:GetLevel()
	return c:IsFaceup() and c:IsSetCard(0x37fb) and lv1>0
		and Duel.IsExistingTarget(cm.filter2,tp,0,LOCATION_GRAVE,1,nil,lv1,slv)
end
function cm.filter2(c,lv1,slv)
	local lv2=c:GetLevel()
	return c:IsFaceup() and c:IsAbleToDeck() and lv2>0 and lv1+lv2>=slv
end
function cm.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x37fb) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and (not lv or c:IsLevelBelow(lv))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then
		if sg:GetCount()==0 then return false end
		local mg,mlv=sg:GetMinGroup(Card.GetLevel)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil,tp,mlv)
	end
	local mg,mlv=sg:GetMinGroup(Card.GetLevel)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp,mlv)
	g1:GetFirst():RegisterFlagEffect(17020120,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,cm.filter2,tp,0,LOCATION_GRAVE,1,1,nil,g1:GetFirst():GetLevel(),mlv)
	g1:Merge(g2)
	e:SetLabel(g1:GetSum(Card.GetLevel))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	local tc=tg:GetFirst()
	while tc do
		if tc:GetFlagEffect(17020120)==0 then 
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		tc=tg:GetNext()
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SOUND,0,aux.Stringid(tc:GetCode(),4))
	if tc.KamenRider_name==17020110 then 
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,3))
	elseif tc.KamenRider_name==17020000 and tc:GetCode()~=17020060 then
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,2))
	elseif tc.KamenRider_name==17020070 then
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,4))
	elseif tc.KamenRider_name==17020000 and tc:GetCode()==17020060 then
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,5))
	elseif tc.KamenRider_name==17020210 then
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,6))
	end
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		Duel.BreakEffect()
		c:SetCardTarget(tc)
	end
	Duel.SpecialSummonComplete()
	Duel.Hint(HINT_SOUND,0,aux.Stringid(tc:GetCode(),5))
end
function cm.tscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.thfilter(c,e,tp,ft)
	return c:IsFaceup() and c:IsSetCard(0x37fb) and c:IsAbleToHand() and (ft>0 or c:GetSequence()<5)
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetCode())
end
function cm.spfilter2(c,e,tp,code)
	return c:IsSetCard(0x37fb) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.tstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.thfilter(chkc,e,tp,ft) end
	if chk==0 then return ft>-1 and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.tsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode())
		local tc=sg:GetFirst()
		Duel.Hint(HINT_SOUND,0,aux.Stringid(tc:GetCode(),4))
		if tc.KamenRider_name==17020110 then 
			Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,3))
		elseif tc.KamenRider_name==17020000 and tc:GetCode()~=17020060 then
			Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,2))
		elseif tc.KamenRider_name==17020070 then
			Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,4))
		elseif tc.KamenRider_name==17020000 and tc:GetCode()==17020060 then
			Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,5))
		elseif tc.KamenRider_name==17020210 then
			Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,6))
		end
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
			Duel.Hint(HINT_SOUND,0,aux.Stringid(tc:GetCode(),5))
		end
	end
end