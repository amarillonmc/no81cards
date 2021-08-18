local m=15000301
local cm=_G["c"..m]
cm.name="世界墟207的寂静"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(15000301,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsCode(15000300)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(15000301,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsCode(15000300)
end
function cm.filter(c,e,tp)
	return c:IsCode(15000110) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sfilter(c)
	return c:IsCode(15000110) or c:IsCode(15000300)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.zfilter(c)
	return c:GetOriginalCode()==15000110 and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local b=Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local b1=Duel.GetFlagEffect(tp,15000301)==0
	local b2=(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)) or (b and (b1 or b2)) end
	if (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)) and not b then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
		e:SetLabel(1)
	end
	if (b and (b1 or b2)) then
		e:SetLabel(2)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local b=Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)) and not b then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif b then
		local b1=Duel.GetFlagEffect(tp,15000301)==0
		local b2=(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0)
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		elseif b1 and not b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
		elseif b2 and not b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
		else return end
		if op==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_MOVE)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(cm.descon)
			e1:SetOperation(cm.desop)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,15000301,RESET_PHASE+PHASE_END,0,2)
		end
		if op==1 then
			if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)==0 then return end
			local ac=Duel.GetDecktopGroup(tp,1):GetFirst()
			local bc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
			if Duel.SendtoGrave(Group.FromCards(ac,bc),REASON_EFFECT)~=0 then
				local g=Duel.GetMatchingGroup(cm.zfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
				if g:GetCount()~=0 then
					local tc=g:GetFirst()
					while tc do
						Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+15000111,e,0,0,0,0)
						tc=g:GetNext()
					end
				end
			end
		end
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetFlagEffect(tp,15000301)~=0 and (tc:IsCode(15000110) or tc:IsCode(15000300)) and tc:IsPreviousLocation(LOCATION_ONFIELD) and tc:IsLocation(LOCATION_ONFIELD)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local cg=tc:GetColumnGroup():Filter(cm.tgfilter,tc)
	Duel.Destroy(cg,REASON_EFFECT)
end