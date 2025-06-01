--人理的分岐
function c22023250.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023250,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22023250)
	e1:SetTarget(c22023250.target)
	e1:SetOperation(c22023250.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023250,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,22023251)
	e2:SetTarget(c22023250.target2)
	e2:SetOperation(c22023250.activate2)
	c:RegisterEffect(e2)
end
function c22023250.tgfilter(c)
	return c:IsFaceup() and c:IsCode(22023210) and c:IsAbleToGrave()
end
function c22023250.spfilter(c,e,tp)
	return c:IsCode(22023230) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22023250.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023250.tgfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) and e:GetHandler():IsCanOverlay()
		and Duel.IsExistingMatchingCard(c22023250.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22023250.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22023250.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c22023250.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(nil)
			if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
				sc:CompleteProcedure()
				if c:IsRelateToEffect(e) then
					c:CancelToGrave()
					Duel.Overlay(sc,Group.FromCards(c))
				end
			end
		end
	end
end
function c22023250.tgfilter2(c)
	return c:IsFaceup() and c:IsCode(22023230) and c:IsAbleToGrave()
end
function c22023250.spfilter2(c,e,tp)
	return c:IsCode(22023210) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22023250.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023250.tgfilter2,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c22023250.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22023250.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22023250.tgfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22023250.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
		if tc then
			tc:SetMaterial(nil)
			if Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
				Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(22023250,2))
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_CANNOT_INACTIVATE)
				e3:SetLabel(3)
				e3:SetValue(c22023250.effectfilter)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e3,tp)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_CANNOT_DISEFFECT)
				e4:SetLabel(4)
				Duel.RegisterEffect(e4,tp)
				e3:SetLabelObject(e4)
				e4:SetLabelObject(tc)
			end
		end
	end
end
function c22023250.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local label=e:GetLabel()
	local tc
	if label==3 then
		tc=e:GetLabelObject():GetLabelObject()
	else
		tc=e:GetLabelObject()
	end
	return tc and tc==te:GetHandler()
end