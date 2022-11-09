local m=53711015
local cm=_G["c"..m]
cm.name="由朽木到现世的不死导游"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(53711099)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.schfilter(c,e,tp)
	local cd=c:GetOriginalCode()-53711000
	local ltime=0
	local timeg=Duel.GetMatchingGroup(cm.timefilter,tp,LOCATION_MZONE,0,c,tp)
	if #timeg>0 then
		local ttct=0
		for timec in aux.Next(timeg) do
			local timect=timec:GetFlagEffect(53711065)
			ttct=ttct+timect
		end
		ltime=2*#timeg-ttct
	end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,c,e,tp,cd,ltime)
	return c:IsSetCard(0x3538) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:CheckSubGroup(cm.fselect,cd,cd,ltime)
end
function cm.timefilter(c,tp)
	return c:IsHasEffect(53711099,tp) and c:GetFlagEffect(53711065)<2
end
function cm.spfilter(c,e,tp,cd,ct)
	if c:IsLocation(LOCATION_HAND) then
		if cd<3 then return c:IsType(TYPE_SPELL) and c:IsDiscardable()
		elseif cd==3 then return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
		else return c:IsDiscardable() end
	elseif c:IsLocation(LOCATION_GRAVE) then
		return c:IsAbleToRemove() and c:IsHasEffect(53711009,tp)
	else
		return c:IsSetCard(0x3538) and c:IsType(TYPE_SPELL) and ct>0
	end
end
function cm.fselect(g,ct)
	local dg=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	return aux.dncheck(dg) and #dg<=ct
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(cm.schfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		sel=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(m,1))
	else
		Duel.SelectOption(tp,aux.Stringid(m,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.schfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) and g:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,g)
			Duel.RaiseSingleEvent(g:GetFirst(),EVENT_CUSTOM+53711005,e,0,0,0,0)
		end
	end
end
