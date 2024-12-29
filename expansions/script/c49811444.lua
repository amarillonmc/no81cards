--真っ青符
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(s.splimit)
	c:RegisterEffect(e0)
	--pendulum summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	--e1:SetCondition(s.pcon)
	e1:SetTarget(s.ptg)
	e1:SetOperation(s.pop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetCondition(s.regcon)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TO_DECK)
		ge2:SetCondition(s.regcon2)
		ge2:SetOperation(s.regop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_ZOMBIE)
end
--function s.cfilter(c,tp)
function s.cfilter1(c)
	--return c:IsControler(tp) and c:IsType(TYPE_PENDULUM)
	return c:IsType(TYPE_PENDULUM)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	--local v=0
	--if eg:IsExists(s.cfilter,1,nil,0) then v=v+1 end
	--if eg:IsExists(s.cfilter,1,nil,1) then v=v+2 end
	--if v==0 then return false end
	--e:SetLabel(({0,1,PLAYER_ALL})[v])
	--return true
	return eg:IsExists(s.cfilter1,1,nil)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+id,re,r,rp,ep,ev)
end
--function s.cfilter2(c,tp)
function s.cfilter2(c)
	--return c:IsControler(tp) and c:IsType(TYPE_PENDULUM) and c:IsPosition(POS_FACEUP) and c:IsLocation(LOCATION_EXTRA)
	return c:IsType(TYPE_PENDULUM) and c:IsPosition(POS_FACEUP) and c:IsLocation(LOCATION_EXTRA)
end
function s.regcon2(e,tp,eg,ep,ev,re,r,rp)
	--local v=0
	--if eg:IsExists(s.cfilter2,1,nil,0) then v=v+1 end
	--if eg:IsExists(s.cfilter2,1,nil,1) then v=v+2 end
	--if v==0 then return false end
	--e:SetLabel(({0,1,PLAYER_ALL})[v])
	--return true
	return eg:IsExists(s.cfilter2,1,nil)
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+id,re,r,rp,ep,ev)
end
--function s.pcon(e,tp,eg,ep,ev,re,r,rp)
--  return ev==tp or ev==1-tp or ev==PLAYER_ALL
--end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if lpz==nil or rpz==nil then return false end
		local loc=0
		--if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
		if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
		if loc==0 then return false end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(aux.TRUE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local eset={e1}
		local lscale=lpz:GetLeftScale()
		local rscale=rpz:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		local g=Duel.GetFieldGroup(tp,loc,0)
		local res=g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
		e1:Reset()
		return res
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
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
	if ft1>0 then ft1=1 end
	if ft2>0 then ft2=1 end
	ft=1
	--if ft1>0 then loc=loc|LOCATION_HAND end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
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
	Duel.RaiseEvent(sg,EVENT_SPSUMMON_SUCCESS_G_P,e,REASON_EFFECT,tp,tp,0)
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
	e1:Reset()
end
function s.confilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function s.spfilter(c,e,tp)
	return c:IsCode(24530661) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end