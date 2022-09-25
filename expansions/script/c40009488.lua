--银刺龙使 露姬雅
local m=40009488
local cm=_G["c"..m]
cm.named_with_SilverThorn=1
function cm.SilverThorn(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_SilverThorn
end
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	 --xyz summon
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,2)  
	c:EnableReviveLimit()
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.mttg)
	e1:SetOperation(cm.mtop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--Pen
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(cm.ptg)
	e3:SetOperation(cm.pop)
	c:RegisterEffect(e3)
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk == 0 then return Duel.IsExistingTarget(Card.IsCanOverlay,tp,LOCATION_PZONE,0,2,nil) and e:GetHandler():IsType(TYPE_XYZ) end
	local g = Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetTargetCard(g)
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local g = Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg = g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg ~= 2 or not c:IsType(TYPE_XYZ) then return end
	local tc1 = sg:GetFirst()
	local tc2 = sg:GetNext()
	local lc = tc1:GetSequence() == 0 and tc1 or tc2
	local rc = tc1:GetSequence() == 4 and tc1 or tc2
	local lp = tc1:GetLeftScale()
	local rp = tc2:GetRightScale()
	Duel.Overlay(c,sg)
	if sg:FilterCount(Card.IsLocation,nil,LOCATION_OVERLAY) ~= 2 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.pendcon)
	e1:SetOperation(cm.pendop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetLabel(lp,rp)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
end
function cm.Pfilter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetOriginalLevel()
	end
	local bool=Auxiliary.PendulumSummonableBool(c)
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)) or (c:IsLocation(LOCATION_OVERLAY) and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
		and (Auxiliary.PendulumChecklist&(0x1<<tp)==0 or Auxiliary.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
end
function cm.gofilter(c)
	return c:GetOverlayCount() > 0
end
function cm.GetOveraly(tp)
	local og = Group.CreateGroup()
	local g = Duel.GetMatchingGroup(cm.gofilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		og:Merge(tc:GetOverlayGroup())
	end
	return og
end
function cm.pendcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	if Auxiliary.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
	local lscale,rscale = e:GetLabel()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	local exg = Group.CreateGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		loc=loc+LOCATION_HAND 
		exg = cm.GetOveraly(tp)
	end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0) + exg
	end
	return g:IsExists(cm.Pfilter,1,nil,e,tp,lscale,rscale,eset)
end
function  cm.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local lscale,rscale = e:GetLabel()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
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

	local exg = Group.CreateGroup()
	if ft1>0 then
		exg = cm.GetOveraly(tp)
		loc=loc|LOCATION_HAND
	end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(cm.Pfilter,nil,e,tp,lscale,rscale,eset)
	else
		tg=Duel.GetMatchingGroup(cm.Pfilter,tp,loc,0,nil,e,tp,lscale,rscale,eset) + exg:Filter(cm.Pfilter,nil,e,tp,lscale,rscale,eset)
	end
	local ce=nil
	local b1=Auxiliary.PendulumChecklist&(0x1<<tp)==0
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
		tg=tg:Filter(Auxiliary.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Auxiliary.GCheckAdditional=Auxiliary.PendOperationCheck(ft1,ft2,ft)
	local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
	Auxiliary.GCheckAdditional=nil
	if not g then return end
	if ce then
		Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
		ce:UseCountLimit(tp)
	else
		Auxiliary.PendulumChecklist=Auxiliary.PendulumChecklist|(0x1<<tp)
	end
	sg:Merge(g)
	Duel.Hint(HINT_CARD,0,m)
end

function cm.mfilter(c,xyzc)
	return cm.SilverThorn(c) and c:IsLevelAbove(1)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function cm.mcfilter(c)
	return not c:IsLevel(6)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:GetCount()>0 and not g:IsExists(cm.mcfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()>0  
end  
function cm.mtfilter(c)
	return c:IsType(TYPE_MONSTER) and cm.SilverThorn(c) and c:IsCanOverlay()
end
function cm.thfilter(c)
	return cm.SilverThorn(c) and c:IsAbleToHand()
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

