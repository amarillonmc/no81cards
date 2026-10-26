--血肉神明之降生
function c43990945.initial_effect(c)
	aux.AddCodeList(c,43990944)
	--leavl field
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVING)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCondition(c43990945.lfcon)
	e0:SetOperation(c43990945.lfop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43990942)
	e1:SetCost(c43990945.cost)
	e1:SetTarget(c43990945.target)
	e1:SetOperation(c43990945.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990945,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,43990945)
	e2:SetCondition(c43990945.thcon)
	e2:SetTarget(c43990945.thtg)
	e2:SetOperation(c43990945.thop)
	c:RegisterEffect(e2)
	--counter
	Duel.AddCustomActivityCounter(43990945,ACTIVITY_SPSUMMON,c43990945.counterfilter)
end
function c43990945.counterfilter(c)
	return c:IsSetCard(0x3511)
end
function c43990945.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(43990945,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c43990945.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c43990945.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x3511)
end
function c43990945.lfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and (not c:IsOnField() or not c:IsRelateToEffect(re))-- and re:IsActivated()
end
function c43990945.lfop(e,tp,eg,ep,ev,re,r,rp)
	--if not Duel.SelectYesNo(tp,aux.Stringid(43990945,2)) then return end
	Duel.Hint(HINT_CARD,0,43990945)
	Duel.Draw(rp,1,REASON_EFFECT)
end
function c43990945.mfilter(c)
	return c:IsSetCard(0x3511) and c:IsLevelAbove(4) and c:IsReleasable(REASON_EFFECT|REASON_MATERIAL|REASON_RITUAL)
end
function c43990945.rcheck(tp,g,c)
	return g:GetCount()==1
end
function c43990945.rgcheck(g,ec)
	return g:GetCount()==1
end
function c43990945.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local s1=aux.RitualUltimateTarget(aux.FilterBoolFunction(Card.IsCode,43990944),Card.GetOriginalLevel,"Greater",LOCATION_DECK+LOCATION_GRAVE,nil,nil,nil)(e,tp,eg,ep,ev,re,r,rp,0)
	aux.RCheckAdditional=c43990945.rcheck
	aux.RGCheckAdditional=c43990945.rgcheck
	local mg1=Duel.GetRitualMaterial(tp):Filter(c43990945.mfilter,nil)
	local mg2=Duel.GetMatchingGroup(c43990945.mfilter,tp,LOCATION_DECK,0,nil)
	local s2=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,aux.FilterBoolFunction(Card.IsCode,43990944),e,tp,mg1,mg2,Card.GetOriginalLevel,"Greater")
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
	local b1=s1-- and Duel.GetFlagEffect(tp,43990943)==0
	local b2=s2-- and Duel.GetFlagEffect(tp,43990942)==0
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(43990945,0)},
		{b2,aux.Stringid(43990945,1)})
	e:SetLabel(op)
	if op==1 then
		--Duel.RegisterFlagEffect(tp,43990943,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif op==2 then
		--Duel.RegisterFlagEffect(tp,43990942,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
end
function c43990945.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		aux.RitualUltimateOperation(aux.FilterBoolFunction(Card.IsCode,43990944),Card.GetOriginalLevel,"Greater",LOCATION_DECK+LOCATION_GRAVE,nil,nil,nil)(e,tp,eg,ep,ev,re,r,rp)
	else
		::cancel::
		aux.RCheckAdditional=c43990945.rcheck
		aux.RGCheckAdditional=c43990945.rgcheck
		local mg1=Duel.GetRitualMaterial(tp):Filter(c43990945.mfilter,nil)
		local mg2=Duel.GetMatchingGroup(c43990945.mfilter,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,aux.FilterBoolFunction(Card.IsCode,43990944),e,tp,mg1,mg2,Card.GetOriginalLevel,"Greater")
		local tc=g:GetFirst()
		if tc then
			local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			mg:Merge(mg2)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
			aux.GCheckAdditional=nil
			if not mat then
				aux.RCheckAdditional=nil
				aux.RGCheckAdditional=nil
				goto cancel
			end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
	end
end
function c43990945.cfilter(c)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousCodeOnField()==43990944
end
function c43990945.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990945.cfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c43990945.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c43990945.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3511))
	e2:SetValue(c43990945.sumlimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	Duel.RegisterEffect(e3,tp)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	Duel.RegisterEffect(e5,tp)
end
function c43990945.sumlimit(e,c,sumtype)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer()) and (e:GetCode()~=EFFECT_CANNOT_BE_FUSION_MATERIAL or sumtype==SUMMON_TYPE_FUSION)
end
