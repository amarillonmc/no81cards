--再临之姬神 艾库莉亚·菲弥琳丝
function c67200832.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200832,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200832)
	e1:SetCost(c67200832.stcon)
	e1:SetTarget(c67200832.sttg)
	e1:SetOperation(c67200832.stop)
	c:RegisterEffect(e1)
	--set p 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200832,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCondition(c67200832.pencon)
	e3:SetTarget(c67200832.pentg)
	e3:SetOperation(c67200832.penop)
	c:RegisterEffect(e3)   
end
function c67200832.stfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_PZONE) 
end
function c67200832.stcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg:IsExists(c67200832.stfilter,1,nil,tp)
end
function c67200832.setfilter1(c,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function c67200832.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c67200832.setfilter1,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,c,tp) end
end
function c67200832.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=Duel.SelectMatchingCard(tp,c67200832.setfilter1,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,c,tp)
	local tc1=g1:GetFirst()
	if tc then
		if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 and c:IsDestructable(e) and Duel.SelectYesNo(tp,aux.Stringid(67200832,3)) then
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
--
function c67200832.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA)
end
function c67200832.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c67200832.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local gg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	if gg:GetCount()>0 then
		Duel.HintSelection(gg)
		if Duel.Destroy(gg,REASON_EFFECT)~=0 then
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
			if res and Duel.SelectYesNo(tp,aux.Stringid(67200832,2)) then
				local tg=Duel.GetMatchingGroup(aux.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
				tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,e1)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				aux.GCheckAdditional=aux.PendOperationCheck(ft1,ft2,ft)
				local g=tg:SelectSubGroup(tp,aux.TRUE,false,1,1)
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
	end
end