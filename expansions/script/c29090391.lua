--方舟骑士-埃拉托
local m=29090391
local cm=_G["c"..m]
cm.named_with_Arknight=1
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon rule
	local e01=Effect.CreateEffect(c)
	e01:SetDescription(1164)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetCode(EFFECT_SPSUMMON_PROC)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetRange(LOCATION_EXTRA)
	e01:SetCondition(cm.syrcon)
	e01:SetTarget(cm.syrtg)
	e01:SetOperation(cm.syrop)
	e01:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e01)
	--Effect 1
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetCategory(CATEGORY_POSITION)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_MZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1,m)
	e51:SetTarget(cm.postg)
	e51:SetOperation(cm.posop)
	c:RegisterEffect(e51)  
	--synchro level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.slevel)
	c:RegisterEffect(e2)
end
function cm.slevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	return (5<<16)+lv
end
--synchro summon rule filter
function cm.syf(c,syc)
	local setcard=(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
	local loccheck=c:GetLocation()~=LOCATION_MZONE or c:IsFaceup()
	return loccheck and c:GetSynchroLevel(syc)>0 and setcard and c:IsSynchroType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial(syc)
end
function cm.ckf(c,syc)
	local setcard=(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
	return c:IsLocation(LOCATION_GRAVE+LOCATION_HAND) and c:GetSynchroLevel(syc)>0 and setcard and c:IsSynchroType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial(syc)
end
--synchro summon rule 
function cm.syrcon(e,c,smat,mg1,min,max)
	if c==nil then return true end
	local loc=LOCATION_GRAVE+LOCATION_HAND 
	--if not Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.GetHandSynchro),c:GetControler(),LOCATION_MZONE,0,1,nil) then
		--loc=loc+LOCATION_HAND 
	--end
	local tp=c:GetControler()
	local excheck=Duel.GetFlagEffect(tp,m)==0
	local exg=Duel.GetMatchingGroup(cm.syf,tp,loc,0,nil,c)
	local minc=2
	local maxc=99
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	local mg
	local mgchk=false
	if mg1 then
		mg=mg1
		mgchk=true
	else
		mg=aux.GetSynMaterials(tp,c)
	end
	if excheck and #exg>0 and mgchk==false then mg:Merge(exg) end
	if smat~=nil then mg:AddCard(smat) end
	return mg:CheckSubGroup(cm.syrcheck,2,2,minc,maxc,tp,c,smat,mgchk)
end
function cm.syrtg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
	local loc=LOCATION_GRAVE+LOCATION_HAND 
	--if not Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.GetHandSynchro),c:GetControler(),LOCATION_MZONE,0,1,nil) then
		--loc=loc+LOCATION_HAND 
	--end
	local excheck=Duel.GetFlagEffect(tp,m)==0
	local exg=Duel.GetMatchingGroup(cm.syf,tp,loc,0,nil,c)
	local minc=2
	local maxc=99
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	local mg
	local mgchk=false
	if mg1 then
		mg=mg1
		mgchk=true
	else
		mg=aux.GetSynMaterials(tp,c)
	end
	if excheck and #exg>0 and mgchk==false then mg:Merge(exg) end
	if smat~=nil then mg:AddCard(smat) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local matg=mg:SelectSubGroup(tp,cm.syrcheck,true,2,2,minc,maxc,tp,c,smat,mgchk)
	if matg then
		matg:KeepAlive()
		e:SetLabelObject(matg)
		return true
	else return false end
end
function cm.syrop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	if #g==0 then return end
	if Duel.GetFlagEffect(tp,m)==0 and g:FilterCount(cm.ckf,nil,c)>0 then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
	c:SetMaterial(g)
	local _SendtoGrave=Duel.SendtoGrave
	Duel.SendtoGrave=function(g,r)
						if r==REASON_MATERIAL+REASON_SYNCHRO then
							local tg=g:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_GRAVE)
							local rg=tg:Filter(Card.IsAbleToRemove,nil,tp,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
							g:Sub(rg)
							_SendtoGrave(g,r)
							Duel.Remove(rg,POS_FACEUP,r)
							Duel.SendtoGrave=_SendtoGrave
						else
							_SendtoGrave(g,r)
						end
					end
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function cm.syrcheck(g,min,max,tp,syncard,smat,mgchk)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if not g:CheckWithSumEqual(Card.GetSynchroLevel,syncard:GetLevel(),min,max,syncard)
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or not g:CheckWithSumEqual(aux.GetSynchroLevelFlowerCardian,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard))
		then return false end
	if smat and not g:IsContains(smat) then return false end
	if not g:IsExists(cm.ckf1,1,nil,syncard,g) then return false end
	if g:FilterCount(cm.ckf,nil,syncard)>1 then return false end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=hg:GetCount()
	if hct>0 and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.GetHandSynchro),tp,LOCATION_MZONE,0,1,nil) and not mgchk then
		local found=false
		for c in aux.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				found=true
				if hf and hg:IsExists(aux.SynLimitFilter,1,c,hf,he,syncard) then return false end
				if (hmin and hct<hmin) or (hmax and hct>hmax) then return false end
			end
		end
		if not found then return false end
	end
	for c in aux.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then return false end
			end
			if lf and g:IsExists(aux.SynLimitFilter,1,c,lf,le,syncard) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end
function cm.ckf1(c,syncard,g)
	return c:IsType(TYPE_TUNER) and g:IsExists(cm.syf,1,c,syncard)
end
--Effect 1
function cm.pf(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.pf,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,1-tp,LOCATION_MZONE)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.pf,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tag=g:Select(tp,1,1,nil)
	if #tag==0 then return end
	Duel.HintSelection(tag)
	--local tc=tag:GetFirst()
	Duel.ChangePosition(tag,POS_FACEDOWN_DEFENSE)
end
--Effect 2
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsFacedown() and bc:IsDefensePos()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() and Duel.SelectYesNo(tp,aux.Stringid(m,1))  then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Destroy(bc,REASON_EFFECT)
	end
end

