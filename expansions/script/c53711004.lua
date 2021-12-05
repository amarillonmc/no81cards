local m=53711004
local cm=_G["c"..m]
cm.name="魔理沙役 YUH"
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
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.scon)
	e2:SetTarget(cm.stg)
	e2:SetOperation(cm.sop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.discon)
	e3:SetCost(cm.discost)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
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
		return c:IsDiscardable()
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
	if chk==0 then return #g+ct>3 end
	g:Merge(gdg)
	if ltime>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local sg=g:SelectSubGroup(tp,cm.fselect,false,4,4,ct)
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
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,4,4,c,e,tp)
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
function cm.sfilter(c,e,tp)
	return c:IsSetCard(0x3538) and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_SELF,tp,false,false) and not c:IsCode(m)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function cm.costfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_SPELLCASTER)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,cm.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
