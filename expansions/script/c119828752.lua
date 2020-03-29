function c119828752.initial_effect(c)
	aux.AddXyzProcedure(c,nil,8,2,c119828752.ovfilter,aux.Stringid(119828752,0),99,c119828752.xyzop)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(119828752,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetHintTiming(TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,119828751)
	e1:SetCondition(c119828752.pccon)
	e1:SetTarget(c119828752.pctg)
	e1:SetOperation(c119828752.pcop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(119828752,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,119828752)
	e2:SetTarget(c119828752.target)
	e2:SetOperation(c119828752.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_PZONE)
	e3:SetOperation(c119828752.cpop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c119828752.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(c119828752.defval)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(119828752,5))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c119828752.cost)
	e6:SetTarget(c119828752.sptg)
	e6:SetOperation(c119828752.spop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(119828752,6))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
	e7:SetCountLimit(1,119828753)
	e7:SetTarget(c119828752.mvtg)
	e7:SetOperation(c119828752.mvop)
	c:RegisterEffect(e7)
end
function c119828752.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c119828752.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,119828752)==0 end
	Duel.RegisterFlagEffect(tp,119828752,RESET_PHASE+PHASE_END,0,1)
end
function c119828752.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFaceup()
end
function c119828752.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c119828752.pcfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c119828752.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if Duel.Destroy(dg,REASON_EFFECT)<dg:GetCount() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c119828752.pcfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local tc=g:GetNext()
		if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
	end
end
function c119828752.pccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return ph==PHASE_STANDBY
	end
end
function c119828752.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c119828752.filter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() 
end
function c119828752.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c119828752.filter1 end
	if chk==0 then return Duel.IsExistingTarget(c119828752.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c119828752.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c119828752.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c119828752.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c119828752.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
		Duel.Overlay(tc,g)
	end
end
function c119828752.cpop(e,tp,eg,ep,ev,re,r,rp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz~=nil and lpz:GetFlagEffect(119828752)<=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(119828752,4))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetRange(LOCATION_PZONE)
		e1:SetCountLimit(1,10000000)
		e1:SetCondition(c119828752.pencon1)
		e1:SetOperation(c119828752.penop1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(SUMMON_TYPE_PENDULUM)
		lpz:RegisterEffect(e1)
		lpz:RegisterFlagEffect(119828752,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c119828752.eftg(e,c)
	return c==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0)
end
function c119828752.penfilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsFaceup() and c:IsType(TYPE_PENDULUM))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden()
end
function c119828752.pencon1(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or c==rpz or not (c:IsCode(119828752) or rpz:IsCode(119828752)) or Duel.IsExistingMatchingCard(aux.NOT(Card.IsSetCard),tp,LOCATION_EXTRA,0,1,nil,0xe0) then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND+LOCATION_DECK else return end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(c119828752.penfilter,1,nil,e,tp,lscale,rscale)
end
function c119828752.penop1(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	Duel.Hint(HINT_CARD,0,119828752)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND+LOCATION_DECK end
	if ft2>0 then loc=loc+LOCATION_EXTRA end
	local tg=nil
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(c119828752.penfilter,nil,e,tp,lscale,rscale)
	else
		tg=Duel.GetMatchingGroup(c119828752.penfilter,tp,loc,0,nil,e,tp,lscale,rscale)
	end
	ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK))
	ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	while true do
		local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		local ct=ft
		if ct1>ft1 then ct=math.min(ct,ft1) end
		if ct2>ft2 then ct=math.min(ct,ft2) end
		if ct<=0 then break end
		if sg:GetCount()>0 and ct1+ct2>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
		local ac
		if ft1>0 and Duel.SelectYesNo(tp,aux.Stringid(119828752,3)) then
			local ag=tg:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_DECK)
			sg:Merge(ag)
			ac=ag:GetFirst()
			ft=ft-1
			ft1=ft1-1
		end
		if sg:GetCount()>0 and ct1+ct2>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
		tg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_EXTRA)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=tg:Select(tp,1,ct,ac)
		tg:Sub(g)
		sg:Merge(g)
		if g:GetCount()<ct then ft=0 break end
		ft=ft-g:GetCount()
		ft1=ft1-g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		ft2=ft2-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	end
	if ft>0 then
		local tg1=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		local tg2=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		if ft1>0 and ft2==0 and tg1:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
			local ct=math.min(ft1,ft)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg1:Select(tp,1,ct,ac)
			sg:Merge(g)
		end
		if ft1==0 and ft2>0 and tg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
			local ct=math.min(ft2,ft)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg2:Select(tp,1,ct,ac)
			sg:Merge(g)
		end
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
	Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_EXTRA,0))
end
function c119828752.atkfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:GetAttack()>=0
end
function c119828752.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c119828752.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c119828752.deffilter(c)
	return c:IsType(TYPE_PENDULUM) and c:GetDefense()>=0
end
function c119828752.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c119828752.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c119828752.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c119828752.spfilter(c)
	return c:IsSetCard(0xe0) and c:IsAbleToHand()
end
function c119828752.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c119828752.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c119828752.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c119828752.spfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c119828752.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c119828752.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end