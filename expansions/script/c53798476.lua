local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id+4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.ritfilter(c,e,tp,p)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,p,false,true) then return false end
	local mg=Duel.GetRitualMaterial(p)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,p)
	else
		mg:RemoveCard(c)
	end
	local lv=c:GetLevel()
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,"Greater")
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,p,c,lv,"Greater")
	Auxiliary.GCheckAdditional=nil
	return res
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ritfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,tp) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.ritfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,g)
		local p=tp
		if s.ritfilter(tc,e,tp,1-tp) and Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
			p=1-tp
		end
		local mg=Duel.GetRitualMaterial(p)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,p)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_RELEASE)
		local lv=tc:GetLevel()
		Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(tc,lv,"Greater")
		local mat=mg:SelectSubGroup(p,Auxiliary.RitualCheck,true,1,lv,p,tc,lv,"Greater")
		Auxiliary.GCheckAdditional=nil
		if mat then
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,p,p,false,true,POS_FACEUP)
			tc:CompleteProcedure()
			if tc:IsCode(id+4) then
				e:SetLabelObject(tc)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAIN_END)
				e1:SetOperation(s.evop)
				e1:SetLabelObject(e)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.evop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetLabelObject()
	Duel.RaiseEvent(tc,EVENT_CUSTOM+id,te,0,tp,tp,0)
	te:SetLabelObject(nil)
	e:Reset()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function s.thfilter(c,e,tp)
	return c:IsReason(REASON_RELEASE)
		and c:IsAbleToHand(tp) and c:IsCanBeEffectTarget(e)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=eg:GetFirst()
	local mat=tc:GetMaterial()
	if chkc then return mat:IsContains(chkc) and s.thfilter(chkc,e,tp) end
	if chk==0 then return mat:IsExists(s.thfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=mat:FilterSelect(tp,s.thfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
