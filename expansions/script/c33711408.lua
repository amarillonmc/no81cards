--动物朋友 牦牛
local m=33711408
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.rcost)
	e2:SetTarget(cm.rtg)
	e2:SetOperation(cm.rop)
	c:RegisterEffect(e2)
	--send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.ttg)
	e3:SetOperation(cm.top)
	c:RegisterEffect(e3) 
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) and mg:GetClassCount(Card.GetCode)==#mg
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function cm.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.rop(e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,1,nil,tp,LOCATION_DECK)
end
function cm.rfilter2(c)
	return c:IsSetCard(0x442)
end
function cm.top(e,tp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
	local ac=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 then
		ac=Duel.AnnounceNumber(tp,1,2,3)
	elseif Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 then
		ac=Duel.AnnounceNumber(tp,1,2)
	elseif Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
		ac=Duel.AnnounceNumber(tp,1)
	end
	local tg=Duel.GetDecktopGroup(tp,ac)
	if Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then
		local g=Duel.GetOperatedGroup()
		local sg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		Duel.BreakEffect()
		if sg:GetClassCount(Card.GetCode)==#sg then
			local rct=sg:FilterCount(cm.rfilter2,nil)
			local num=Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
			if rct==0 or num==0 then return end
			if rct>num then rct=num end
			if not Duel.SelectYesNo(tp,aux.Stringid(9910024,0)) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,rct,nil)
			if sg1:GetCount()>0 then
				Duel.SendtoHand(sg1,nil,REASON_EFFECT)
			end
		elseif sg:GetClassCount(Card.GetCode)<#sg then
			local num=Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
			if num<1 then return end
			if num>#sg then num=#sg end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,num,num,nil)
			if sg1:GetCount()>0 then
				Duel.SendtoGrave(sg1,REASON_EFFECT)
			end
		end
	end
end