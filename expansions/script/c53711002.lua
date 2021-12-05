local m=53711002
local cm=_G["c"..m]
cm.name="魔理沙役 KHK"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.scon)
	e2:SetCost(cm.scost)
	e2:SetTarget(cm.stg)
	e2:SetOperation(cm.sop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_CUSTOM+53711005)
	e5:SetRange(LOCATION_HAND)
	e5:SetCost(cm.spcost)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
end
function cm.spfilter1(c,e,tp)
	if c:IsLocation(LOCATION_HAND) then
		return c:IsType(TYPE_SPELL) and c:IsDiscardable()
	else
		return e:GetHandler():IsOriginalSetCard(0x3538) and e:GetHandler():IsLevel(4) and c:IsAbleToRemove() and c:IsHasEffect(53711009,tp)
	end
end
function cm.spfilter2(c,e,tp)
	return c:IsSetCard(0x3538) and c:IsType(TYPE_SPELL)
end
function cm.timefilter(c,tp)
	return c:IsHasEffect(53711065,tp) and c:GetFlagEffect(53711015)<2
end
function cm.fselect(g,ct)
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	return aux.dncheck(g2) and #g2<=ct
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ltime=0
	local timeg=Duel.GetMatchingGroup(cm.timefilter,tp,LOCATION_MZONE,0,c,tp)
	if #timeg>0 then
		local ttct=0
		for timec in aux.Next(timeg) do
			local timect=timec:GetFlagEffect(53711015)
			ttct=ttct+timect
		end
		ltime=2*#timeg-ttct
	end
	local g=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,e,tp)
	local gdg=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_DECK,0,c,e,tp)
	local ct=gdg:GetClassCount(Card.GetCode)
	if ct>ltime then ct=ltime end
	if chk==0 then return #g+ct>1 end
	g:Merge(gdg)
	if ltime>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,ct)
		local dg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if #dg>0 then
			if #timeg>1 then
				for i=1,#dg do
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
					local usedg=timeg:FilterSelect(tp,cm.timefilter,1,1,nil)
					Duel.HintSelection(usedg)
					local usedc=usedg:GetFirst()
					local trg=usedc:GetFlagEffect(53711015)
					usedc:RegisterFlagEffect(53711015,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53711015,trg+3))
				end
			else
				for i=1,#dg do
					local trg=timeg:GetFirst():GetFlagEffect(53711015)
					timeg:GetFirst():RegisterFlagEffect(53711015,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53711015,trg+3))
				end
			end
		end
		local tc=sg:GetFirst()
		while tc do
			local te=tc:IsHasEffect(53711009,tp)
			if te then
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
			else
				Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
			end
			tc=sg:GetNext()
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,c,e,tp)
		local tc=sg:GetFirst()
		while tc do
			local te=tc:IsHasEffect(53711009,tp)
			if te then
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
			else
				Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
			end
			tc=sg:GetNext()
		end
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function cm.sfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function cm.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),1-tp,LOCATION_GRAVE)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.filter(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
