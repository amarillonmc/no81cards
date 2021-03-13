--时机龙骑·失落传说
local m=40009202
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,cm.mfilter,7,3)   
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.setcon1)
	e1:SetOperation(cm.pspop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(cm.nnegcost)
	e2:SetCondition(cm.setcon2)
	c:RegisterEffect(e2)	
	--place
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(cm.reg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.pcon)
	e5:SetTarget(cm.ptg)
	e5:SetOperation(cm.pop)
	c:RegisterEffect(e5)

	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.xyzcon)
	e3:SetTarget(cm.xyztg)
	e3:SetOperation(cm.xyzop)
	c:RegisterEffect(e3)
end

function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.getlevel(c)
	return c:IsType(TYPE_XYZ) and c:GetRank() or c:GetLevel()
end
function cm.matfilter0(c)
	return c:IsFaceup() and (c:IsRankAbove(1) or c:IsLevelAbove(1)) and c:IsCanBeXyzMaterial(nil) 
end
function cm.xyzfilter(c,mc,e,tp,matg,sg)
	local matg2 = matg:Filter(aux.TRUE,mc)
	local sg2 = sg:Clone()
	sg2:AddCard(c)
	local mc2 = matg2:GetFirst()
	return mc:IsCanBeXyzMaterial(c) and c:IsRank(cm.getlevel(mc) + 1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
			and (#matg2 == 0 or Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,sg2,mc2,e,tp,matg2,sg2))
end
function cm.xyzgcheck(g,e,tp)
	if not g:IsExists(aux.MustMaterialCheck,1,nil,tp,EFFECT_MUST_BE_XMATERIAL) then return false end
	if aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL):GetCount() > 1 then return false end
	if Duel.GetLocationCountFromEx(tp,tp,g,TYPE_XYZ) < #g then return false end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and #g > 1 then return false end
	if c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp] < #g then return false end
	local tc = g:GetFirst() 
	local sg = Group.CreateGroup()
	return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,sg,tc,e,tp,g,sg)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local matg = Duel.GetMatchingGroup(cm.matfilter0,tp,LOCATION_MZONE,0,c)
	if chk==0 then return matg:CheckSubGroup(cm.xyzgcheck,1,#matg,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xyzop(e,tp)
	local matg = Duel.GetMatchingGroup(cm.matfilter0,tp,LOCATION_MZONE,0,aux.ExceptThisCard(e))
	if not matg:CheckSubGroup(cm.xyzgcheck,1,#matg,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg = matg:SelectSubGroup(tp,cm.xyzgcheck,false,1,#matg,e,tp)
	local mg2 = mg:Clone()
	local sg = Group.CreateGroup()
	for tc in aux.Next(mg) do 
		local tg = Group.FromCards(tc)
		Duel.HintSelection(tg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc = Duel.SelectMatchingCard(tp,cm.xyzfilter,tp,LOCATION_EXTRA,0,1,1,sg,tc,e,tp,mg2,sg):GetFirst()
		mg2:RemoveCard(tc)
		sg:AddCard(sc)   
		local og=tc:GetOverlayGroup()
		if #og~=0 then
			Duel.Overlay(sc,og)
		end
		sc:SetMaterial(tg)
		Duel.Overlay(sc,tg)
		Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)  
	end
	Duel.SpecialSummonComplete()
end










function cm.nnegcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xf1c,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xf1c,3,REASON_COST)
end
function cm.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.setcon1(e,tp,eg,ep,ev,re,r,rp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or lpz==rpz then return false end
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset) and (not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208)))
end
function cm.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or lpz==rpz then return false end
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset) and Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function cm.pspop(e,tp,eg,ep,ev,re,r,rp,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local tg=nil
	local loc=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
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
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(aux.PConditionFilter,nil,e,tp,lscale,rscale,eset)
	else
		tg=Duel.GetMatchingGroup(aux.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
	end
	local ce=nil
	local b1=PENDULUM_CHECKLIST&(0x1<<tp)==0
	local b2=#eset>0
	if b1 and b2 then
	local options={1163}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
	local op=Duel.SelectOption(tp,table.unpack(options))
	if op>0 then
		ce=eset[op]
	end
	elseif b2 and not b1 then
	local options={}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
	 local op=Duel.SelectOption(tp,table.unpack(options))
			ce=eset[op+1]
	 end
		if ce then
			tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
		end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:SelectSubGroup(tp,aux.PendOperationCheck,true,1,#tg,ft1,ft2,ft)
	if not g then return end
	if ce then
		Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
		ce:Reset()
	end
	Duel.HintSelection(Group.FromCards(lpz))
	Duel.HintSelection(Group.FromCards(rpz))
	for tc in aux.Next(g) do
		local bool=aux.PendulumSummonableBool(tc)
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,bool,bool,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
	for tc in aux.Next(g) do tc:CompleteProcedure() end
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0xf1c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.penfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.reg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re and re:IsHasType(EFFECT_TYPE_ACTIONS) then
		c:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.pcon(e,tp)
	return e:GetHandler():GetFlagEffect(m+100)>0
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x1f1c) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then return end
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=sg:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
	end
end