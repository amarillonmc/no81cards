--星海游侠 奥罗拉·阿尔法
function c60152314.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),3,2,nil,nil,99)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60152314,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c60152314.e1con)
	e1:SetTarget(c60152314.e1tg)
	e1:SetOperation(c60152314.e1op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60152314,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,60152314)
	e2:SetCode(EVENT_FREE_CHAIN)
	--e2:SetCost(c60152314.e2cost)
	e2:SetTarget(c60152314.e2tg)
	e2:SetOperation(c60152314.e2op)
	c:RegisterEffect(e2)
	--summon
	local e99=Effect.CreateEffect(c)
	e99:SetDescription(aux.Stringid(60152314,2))
	e99:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e99:SetType(EFFECT_TYPE_QUICK_O)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCountLimit(1,6012314)
	e99:SetCode(EVENT_FREE_CHAIN)
	e99:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e99:SetTarget(c60152314.e99tg)
	e99:SetOperation(c60152314.e99op)
	c:RegisterEffect(e99)
end
function c60152314.e1con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c60152314.e1tgfilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function c60152314.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60152314.e1tgfilter,tp,LOCATION_GRAVE+LOCATION_OVERLAY,LOCATION_GRAVE+LOCATION_OVERLAY,1,nil,e) and e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_MZONE) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152314.e1op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_MZONE) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152314,1))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60152314.e1tgfilter),tp,LOCATION_GRAVE+LOCATION_OVERLAY,LOCATION_GRAVE+LOCATION_OVERLAY,1,1,nil,e)
	Duel.HintSelection(g)
	Duel.Overlay(e:GetHandler(),g)
end
function c60152314.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60152314.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetOverlayCount(tp,1,1)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152314.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=Duel.GetOverlayCount(tp,1,1)
	local ct2=g:GetCount()
	if ct<=0 then return end
	if ct>ct2 then
		Duel.RemoveOverlayCard(tp,1,1,1,ct2,REASON_EFFECT)
		local a=Duel.GetOperatedGroup():GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,a,a,nil)
		if g2:GetCount()>0 then
			Duel.HintSelection(g2)
			local tc=g2:GetFirst()
			while tc do
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetDescription(aux.Stringid(60152314,2))
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
				e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e2:SetValue(1)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_IMMUNE_EFFECT)
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e3:SetValue(c60152314.efilter)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
				tc=g2:GetNext()
			end
		end
	else
		Duel.RemoveOverlayCard(tp,1,1,1,ct,REASON_EFFECT)
		local a=Duel.GetOperatedGroup():GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,a,a,nil)
		if g2:GetCount()>0 then
			Duel.HintSelection(g2)
			local tc=g2:GetFirst()
			while tc do
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetDescription(aux.Stringid(60152314,3))
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
				e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e2:SetValue(1)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_IMMUNE_EFFECT)
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e3:SetValue(c60152314.efilter)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
				tc=g2:GetNext()
			end
		end
	end
end
function c60152314.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c60152314.e2opcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60152314.e2opop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60152314)
	Duel.Draw(e:GetHandler():GetPreviousControler(),1,REASON_EFFECT)
	e:Reset()
end
function c60152314.e99tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER)
end
function c60152314.e99tgfilter3(c,e,tp)
	return c:IsSetCard(0xcb26) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true) 
end
function c60152314.e99tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g0=Group.CreateGroup()
	local gb=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local ga=Duel.GetOverlayGroup(tp,1,0)
	Group.Merge(g0,ga)
	Group.Merge(g0,gb)
	local gc=g0:Filter(c60152314.e99tgfilter3,nil,e,tp)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c60152314.e99tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60152314.e99tgfilter,tp,LOCATION_MZONE,0,1,nil) 
		and gc:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c60152314.e99tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152314.e99op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g0=Group.CreateGroup()
		local gb=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
		local ga=Duel.GetOverlayGroup(tp,1,0)
		Group.Merge(g0,ga)
		Group.Merge(g0,gb)
		local gc=g0:Filter(c60152314.e99tgfilter3,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=gc:Select(tp,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			local tc2=g:GetFirst()
			Duel.SpecialSummon(tc2,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP)
			if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then 
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.Overlay(tc2,og)
				end
				Duel.Overlay(tc2,Group.FromCards(tc))
			end
			if Duel.IsPlayerAffectedByEffect(tp,60152321) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(c60152314.e99opfilter)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_CHAIN)
				tc2:RegisterEffect(e1)
			end
			tc2:CompleteProcedure()
		end
	end
end
function c60152314.e99opfilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end