--占卜师-变化
function c67201509.initial_effect(c)
	aux.AddCodeList(c,67201503)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c67201509.target)
	e0:SetOperation(c67201509.activate)
	c:RegisterEffect(e0)
	--
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201509,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,67201509)
	e2:SetCondition(c67201509.drcon)
	e2:SetTarget(c67201509.drtg)
	e2:SetOperation(c67201509.drop)
	c:RegisterEffect(e2)	  
end

function c67201509.matfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0
end
function c67201509.mfilter(c,e)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0 and c:IsReleasableByEffect(e)
end
function c67201509.filter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_SPELLCASTER)
end
function c67201509.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c67201509.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
--
function c67201509.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(c67201509.matfilter,nil)
		local mg2=Duel.GetMatchingGroup(c67201509.mfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil)
		aux.RCheckAdditional=c67201509.rcheck
		aux.RGCheckAdditional=c67201509.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,c67201509.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c67201509.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp):Filter(c67201509.matfilter,nil)
	local mg2=Duel.GetMatchingGroup(c67201509.mfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c67201509.rcheck
	aux.RGCheckAdditional=c67201509.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,c67201509.filter,e,tp,mg1,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
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
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,#mg,tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		e:SetLabelObject(tc)
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsControlerCanBeChanged,nil)
	if tc:IsCode(67201503) and g:GetCount()>0 and Duel.GetFlagEffect(tp,67201509)==0 and Duel.SelectYesNo(tp,aux.Stringid(67201509,1)) then
		Duel.RegisterFlagEffect(tp,67201509,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.GetControl(g:GetFirst(),tp,PHASE_END,1)
		end
	end
end
--
function c67201509.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67201509.cfilter1,1,nil,tp)
end
function c67201509.cfilter1(c,tp)
	return c:IsCode(67201503) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c67201509.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c67201509.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end


