--千夜 暗地联络
function c60150602.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--extra to hand
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(60150602,3))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_PZONE)
	e11:SetCountLimit(1,600602)
	e11:SetTarget(c60150602.thtg1)
	e11:SetOperation(c60150602.thop1)
	c:RegisterEffect(e11)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150602,4))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,60150602)
	e1:SetTarget(c60150602.target)
	e1:SetOperation(c60150602.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150602,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCountLimit(1,6010602)
	e4:SetCondition(c60150602.descon)
	e4:SetTarget(c60150602.destg)
	e4:SetOperation(c60150602.desop)
	c:RegisterEffect(e4)

	--Duel.AddCustomActivityCounter(60150602,ACTIVITY_SPSUMMON,c60150602.counterfilter)
end
function c60150602.thfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3b21) and c:IsAbleToHand()
end
function c60150602.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150602.thfilter1,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150602.thop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60150602.thfilter1,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		if not c:IsRelateToEffect(e) then return end
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c60150602.counterfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c60150602.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(60150602,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60150602.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c60150602.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c60150602.rpfilter(c,e,tp)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_PENDULUM) and (not c:IsForbidden()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and not c:IsCode(60150602)
end
function c60150602.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150602.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c60150602.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150601,6))
		local g=Duel.SelectMatchingCard(tp,c60150602.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local op=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			op=Duel.SelectOption(tp,aux.Stringid(60150601,1),aux.Stringid(60150601,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(60150601,1))
		end
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c60150602.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x5b21)
end
function c60150602.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c60150602.filter3(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c60150602.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150602.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150602.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60150602.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60150602.filter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER) and not c:IsCode(60150602) and c:IsAbleToHand()
end
function c60150602.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150602.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150602.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60150602.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60150602.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c60150602.filter1(c,e,tp,immchk)
	if immchk and c:IsImmuneToEffect(e) then return false end
	return c:IsAbleToGrave() or (c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck())
end
function c60150602.filter2(c,e,tp,m,f,chkf)
	return (c:IsSetCard(0x3b21) and c:IsType(TYPE_FUSION)) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c60150602.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c60150602.filter1,nil,e,tp)
		local res=Duel.IsExistingMatchingCard(c60150602.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c60150602.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60150602.gfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsLocation(LOCATION_EXTRA)
end
function c60150602.activate2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c60150602.filter1,nil,e,tp,true)
	local sg1=Duel.GetMatchingGroup(c60150602.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c60150602.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			local mtc=mat1:GetFirst()
			while mtc do
					if not mtc:IsFaceup() then Duel.ConfirmCards(1-tp,mtc) end
					mtc=mat1:GetNext()
				end
			local g=mat1:Filter(c60150602.gfilter,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150602,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150602,1))
				local sg=g:Select(tp,1,g:GetCount(),nil)
				local gtc=sg:GetFirst()
				while gtc do
					mat1:RemoveCard(gtc)
					gtc=sg:GetNext()
				end
				Duel.SendtoExtraP(sg,nil,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end