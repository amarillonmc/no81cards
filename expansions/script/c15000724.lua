local m=15000724
local cm=_G["c"..m]
cm.name="噩梦茧机·娜塔莉"
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.psplimit)
	c:RegisterEffect(e1)
	--P Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,15000724)
	e2:SetTarget(cm.ptg)
	e2:SetOperation(cm.pop)
	c:RegisterEffect(e2)
	--only me
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(15000724)
	e3:SetRange(LOCATION_MZONE) 
	c:RegisterEffect(e3)
	--return
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EVENT_CUSTOM+15000725)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetOperation(cm.dop)  
	c:RegisterEffect(e5)
end
function cm.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_MACHINE) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.cfilter(c)
	return c:IsSetCard(0x6f38)
end
function cm.pfilter(c)
	return c:IsSetCard(0x6f38)
end
function cm.sumfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function cm.PConditionFilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=aux.PendulumSummonableBool(c)
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
end
function cm.check(e,tp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return false end
	local pcon=cm.PendCondition
	return pcon(e,lpz,g)
end
function cm.PendCondition()
	return  function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
				if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(cm.PConditionFilter,1,nil,e,tp,lscale,rscale)
			end
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.check(e,tp,nil) end
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp,sg,og)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return end
	--the summon should be done after the chain end
	local sg=Group.CreateGroup()
	local pspop=cm.pspop
	pspop(e,tp,eg,ep,ev,re,r,rp,lpz,sg,nil)
	if Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+15000725,re,r,rp,ep,ev)
	end
end
function cm.pspop(e,tp,eg,ep,ev,re,r,rp,lpz,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local eset={nil}
	local tg=nil
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
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(cm.PConditionFilter,nil,e,tp,lscale,rscale)
	else
		tg=Duel.GetMatchingGroup(cm.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale)
	end
	local ce=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=aux.PendOperationCheck(ft1,ft2,ft)
	local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
	aux.GCheckAdditional=nil
	if not g then return end
	sg:Merge(g)
	Duel.HintSelection(Group.FromCards(lpz))
	Duel.HintSelection(Group.FromCards(rpz))
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsAbleToHand() then Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) end
end