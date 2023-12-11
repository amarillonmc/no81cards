--雪狱之罪哀 大月梨花
function c9911365.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911365,0))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9911365)
	e2:SetCondition(c9911365.rlcon)
	e2:SetTarget(c9911365.rltg)
	e2:SetOperation(c9911365.rlop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9911366)
	e3:SetCondition(c9911365.spcon)
	e3:SetCost(c9911365.spcost)
	e3:SetTarget(c9911365.sptg)
	e3:SetOperation(c9911365.spop)
	c:RegisterEffect(e3)
end
function c9911365.confilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c9911365.rlcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9911365.confilter,1,nil)
end
function c9911365.rlfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc956) and c:IsReleasableByEffect()
end
function c9911365.tgfilter(c)
	return c:IsAbleToGrave() or c:IsAbleToRemove()
end
function c9911365.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911365.rlfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c9911365.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c9911365.gselect1(g)
	return g:GetClassCount(Card.GetLocation)==#g
end
function c9911365.gselect2(g)
	return #g==1 or g:IsExists(Card.IsAbleToGrave,2,nil) or g:IsExists(Card.IsAbleToRemove,2,nil)
end
function c9911365.rlop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c9911365.rlfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c9911365.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,0,nil)
	local ct=1
	if g2:IsExists(Card.IsAbleToGrave,2,nil) or g2:IsExists(Card.IsAbleToRemove,2,nil) then ct=2 end
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g1:SelectSubGroup(tp,c9911365.gselect1,false,1,ct)
		if #sg>0 then
			local rct=Duel.SendtoGrave(sg,REASON_RELEASE+REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tg=g2:SelectSubGroup(tp,c9911365.gselect2,false,rct,rct)
			Duel.HintSelection(tg)
			local b1=tg:FilterCount(Card.IsAbleToGrave,nil)==#tg
			local b2=tg:FilterCount(Card.IsAbleToRemove,nil)==#tg
			local opt=-1
			if b1 and not b2 then
				opt=Duel.SelectOption(tp,1191)
			elseif not b1 and b2 then
				opt=Duel.SelectOption(tp,aux.Stringid(9911365,1))+1
			elseif b1 and b2 then
				opt=Duel.SelectOption(tp,1191,aux.Stringid(9911365,1))
			end
			if opt==0 then
				Duel.SendtoGrave(tg,REASON_EFFECT)
			elseif opt==1 then
				if Duel.Remove(tg,0,REASON_EFFECT+REASON_TEMPORARY)>0 and tg:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
					local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
					for tc in aux.Next(og) do
						tc:RegisterFlagEffect(9911365,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
					end
					og:KeepAlive()
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetLabelObject(og)
					e1:SetCountLimit(1)
					e1:SetCondition(c9911365.retcon)
					e1:SetOperation(c9911365.retop)
					Duel.RegisterEffect(e1,tp)
				end
			end
		end
	end
	Duel.RegisterFlagEffect(tp,9911366,RESET_PHASE+PHASE_END,0,1)
end
function c9911365.retfilter(c)
	return c:GetFlagEffect(9911365)~=0
end
function c9911365.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(c9911365.retfilter,1,nil)
end
function c9911365.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c9911365.retfilter,nil)
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
end
function c9911365.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911366)==0
end
function c9911365.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c9911365.spfilter(c,e,tp)
	return c:IsSetCard(0xc956) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911365.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911365.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c9911365.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=Duel.GetMatchingGroup(c9911365.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c9911365.gselect1,false,1,math.min(ft,2))
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c9911365.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9911365.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
