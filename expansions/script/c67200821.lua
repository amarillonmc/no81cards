--深凌之楔魔 萨哈尼
function c67200821.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destory
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200821,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200822)
	e1:SetCost(c67200821.thcon)
	e1:SetTarget(c67200821.thtg)
	e1:SetOperation(c67200821.thop)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200821,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e3:SetCountLimit(1,67200821)
	e3:SetTarget(c67200821.sptg)
	e3:SetOperation(c67200821.spop)
	c:RegisterEffect(e3)	
end
function c67200821.cfilter1(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSummonPlayer(tp)
end
function c67200821.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200821.cfilter1,1,nil,tp)
end
function c67200821.thfilter(c)
	return c:IsSetCard(0x6678) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c67200821.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() and Duel.IsExistingMatchingCard(c67200821.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200821.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c67200821.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--
function c67200821.setfilter1(c,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function c67200821.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c67200821.setfilter1,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE,0,1,c,tp) end
end
function c67200821.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=Duel.SelectMatchingCard(tp,c67200821.setfilter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_EXTRA,0,1,1,c,tp)
	local tc1=g1:GetFirst()
	if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
			tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		c:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local eset={e1}
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	if ft1>0 then loc=loc|LOCATION_HAND end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
	local g2=Duel.GetFieldGroup(tp,loc,0)
	local res=g2:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
	e1:Reset()
	if res and Duel.SelectYesNo(tp,aux.Stringid(67200821,2)) then
		local tg=Duel.GetMatchingGroup(aux.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
		tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,e1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		aux.GCheckAdditional=aux.PendOperationCheck(ft1,ft2,ft)
		local g=tg:SelectSubGroup(tp,aux.TRUE,false,1,math.min(#tg,ft))
		aux.GCheckAdditional=nil
		if not g then
			e1:Reset()
			return
		end
		local sg=Group.CreateGroup()
		sg:Merge(g)
		Duel.HintSelection(Group.FromCards(lpz))
		Duel.HintSelection(Group.FromCards(rpz))
		Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
		e1:Reset()
	end
end
