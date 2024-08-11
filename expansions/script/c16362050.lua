--超星审判 圣光灵神
function c16362050.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,c16362050.matfilter1,c16362050.matfilter2,2,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--splimit
	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e00:SetCode(EVENT_SPSUMMON_SUCCESS)
	e00:SetCondition(c16362050.regcon)
	e00:SetOperation(c16362050.regop)
	c:RegisterEffect(e00)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,16362050)
	e1:SetCondition(c16362050.descon)
	e1:SetTarget(c16362050.destg)
	e1:SetOperation(c16362050.desop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c16362050.imtg)
	e2:SetValue(c16362050.efilter)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,16362150)
	e3:SetCondition(c16362050.tgcon)
	e3:SetTarget(c16362050.tgtg)
	e3:SetOperation(c16362050.tgop)
	c:RegisterEffect(e3)
end
function c16362050.matfilter1(c)
	return c:IsFusionSetCard(0xdc0) and c:IsFusionType(TYPE_FUSION+TYPE_SYNCHRO)
end
function c16362050.matfilter2(c)
	return c:IsFusionSetCard(0xdc0)
end
function c16362050.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c16362050.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c16362050.splimit1)
	Duel.RegisterEffect(e1,tp)
end
function c16362050.splimit1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(16362050) and bit.band(sumtype,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c16362050.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c16362050.pfilter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsSetCard(0xdc0)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c16362050.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16362050.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c16362050.cpfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsSetCard(0xdc0) and c:IsFaceup()
end
function c16362050.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16362050.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local ct=Duel.GetMatchingGroupCount(c16362050.cpfilter,tp,LOCATION_SZONE,0,nil)
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		if ct>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(16362050,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,ct,nil)
			if #dg>0 then
				Duel.HintSelection(dg)
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end
function c16362050.cpfilter2(c,e)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsSetCard(0xdc0) and c:IsFaceup()
		and c:IsControler(e:GetHandlerPlayer())
end
function c16362050.imtg(e,c)
	return c:IsSetCard(0xdc0) and c:IsLevelAbove(8) and c:GetColumnGroup():IsExists(c16362050.cpfilter2,1,nil,e)
end
function c16362050.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c16362050.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsSetCard(0xdc0)
end
function c16362050.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16362050.cfilter,1,nil,tp)
end
function c16362050.pfilter2(c,tp,cg)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsSetCard(0xdc0)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp) and not cg:IsContains(c)
end
function c16362050.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=eg:Filter(c16362050.cfilter,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c16362050.pfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp,cg) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c16362050.tgop(e,tp,eg,ep,ev,re,r,rp)
	local cg=eg:Filter(c16362050.cfilter,nil)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16362050.pfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp,cg):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end