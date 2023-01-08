local m=15004466
local cm=_G["c"..m]
cm.name="终诞唤核士·伊芙琳"
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
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,15004466)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(cm.srtg)
	e3:SetOperation(cm.srop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCountLimit(1,15004467+EFFECT_COUNT_CODE_OATH)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(cm.sspcon)
	c:RegisterEffect(e4)
	--SpecialSummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,15004468)
	e5:SetCost(cm.spcost)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
end
function cm.distg(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0xf40) and c:IsType(TYPE_MONSTER)
end
function cm.srfilter(c)
	return c:IsSetCard(0xf40) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
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
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3f40) and c:IsFaceup() and (c:IsAbleToHand() or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and not c:IsCode(15004466)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoExtraP(c,nil,REASON_EFFECT)==0 then return end
	--local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocationCountFromEx(tp,tp,nil,tc)<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end