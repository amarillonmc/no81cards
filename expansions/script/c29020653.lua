--方舟骑士团－梓兰·焰狐龙
local m=29020653
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.syrcon)
	e1:SetTarget(cm.syrtg)
	e1:SetOperation(cm.syrop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	--toex and sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.textg)
	e3:SetOperation(cm.texop)
	c:RegisterEffect(e3)
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
	local loc=LOCATION_GRAVE
	if not Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.GetHandSynchro),c:GetControler(),LOCATION_MZONE,0,1,nil) then
		loc=loc+LOCATION_HAND 
	end
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
	local loc=LOCATION_GRAVE
	if not Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.GetHandSynchro),c:GetControler(),LOCATION_MZONE,0,1,nil) then
		loc=loc+LOCATION_HAND 
	end
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
function cm.desfilter(c,tp,seq)
	return c:IsOnField() and c:IsControler(1-tp) and aux.GetColumn(c,tp)==seq
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=aux.GetColumn(c,tp)
	if chk==0 then return seq and Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil,tp,seq) end
	e:SetLabel(seq)
	local cg=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil,tp,seq)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,cg,#cg,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	if not seq then return end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil,tp,seq)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.spfilter(c,e,tp)
	local setcard=(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
	return c:IsType(TYPE_TUNER) and setcard and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.textg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function cm.texop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_EXTRA) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end


