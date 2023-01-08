local m=15004469
local cm=_G["c"..m]
cm.name="终诞唤核士·伊苏罗蒂"
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(cm.distg)
	c:RegisterEffect(e1)
	local e2=Effect.Clone(e1)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(cm.reptg)
	e3:SetValue(cm.repval)
	e3:SetOperation(cm.repop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCountLimit(1,15004469+EFFECT_COUNT_CODE_OATH)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(cm.sspcon)
	c:RegisterEffect(e4)
	--Pset
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_TOEXTRA)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,15004470)
	e5:SetCost(cm.pscost)
	e5:SetTarget(cm.pstg)
	e5:SetOperation(cm.psop)
	c:RegisterEffect(e5)
end
function cm.distg(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0xf40) and c:IsType(TYPE_MONSTER)
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsSetCard(0xf40) and c~=e:GetHandler() and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.filter,1,nil,e,tp)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.repval(e,c)
	return cm.filter(c,e,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function cm.sspcon(e,c)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if c==nil then return true end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	if aux.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
	local pc=0
	local x=0
	local y=0
	local lpc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if lpc==nil or rpc==nil then pc=pc+1 end
	local olpc=Duel.GetFieldCard(1-tp,LOCATION_PZONE,0)
	local orpc=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	if olpc==nil or orpc==nil or orpc:GetFieldID()~=olpc:GetFlagEffectLabel(31531170) then pc=pc+1 end
	if pc==2 then return false end
	if lpc and rpc then x=1 end
	if orpc and olpc and orpc:GetFieldID()==olpc:GetFlagEffectLabel(31531170) then y=1 end
	local res=0
	if x==1 then
		local lscale=lpc:GetLeftScale()
		local rscale=rpc:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		if aux.PConditionFilter(c,e,tp,lscale,rscale,eset) then res=res+1 end
	end
	if y==1 then
		local lscale=olpc:GetLeftScale()
		local rscale=orpc:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		if aux.PConditionFilter(c,e,tp,lscale,rscale,eset) then res=res+1 end
	end
	return Duel.GetLocationCountFromEx(c:GetControler(),c:GetControler(),nil,c)>0
		and c:IsFaceup() and res>=1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) --and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
end
function cm.pscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.psfilter(c)
	return c:IsSetCard(0x5f40) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(cm.psfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function cm.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoExtraP(c,nil,REASON_EFFECT)==0 then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.psfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end