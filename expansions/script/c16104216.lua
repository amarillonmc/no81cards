if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104216,"DAIOU")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	c:SetUniqueOnField(1,1,m) 
	aux.AddFusionProcFunRep2(c,cm.fusion,2,2,true)
	--spsummon and get control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)   
	local e2=rkch.PenAdd(c,{m,1},{1,m+1},{cm.cost,nil,cm.addtarget,cm.addop},false)
	local e3=rkch.MonzToPen(c,m,EVENT_RELEASE,nil)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetValue(cm.val)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	e6:SetValue(cm.actlimit)
	c:RegisterEffect(e6)
	--Get control
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,3))
	e7:SetCategory(CATEGORY_CONTROL)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e7:SetCountLimit(1)
	e7:SetTarget(cm.target)
	e7:SetOperation(cm.operation)
	c:RegisterEffect(e7)
end
function cm.fusion(c)
	return c:IsFusionSetCard(0x3ccd) and c:IsFusionType(TYPE_MONSTER)
end
function cm.copyfilter(c)
	return c:IsControlerCanBeChanged() 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.copyfilter(chkc) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and chkc:IsControler(1-tp) end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(cm.copyfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetMZoneCount(tp)>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.copyfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,tp,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControlerCanBeChanged()  then
				Duel.GetControl(tc,tp)
			end
		end
	end
end
function cm.cost(e)
	e:SetLabel(1)
	return true
end
function cm.addfilter(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0xccd)
end
function cm.addtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()==1 then
			return Duel.IsExistingMatchingCard(cm.addfilter,tp,LOCATION_EXTRA,0,1,nil) 
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,cm.addfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.ConfirmCards(1-tp,sg)
	local tc=sg:GetFirst()
	Duel.SetTargetCard(tc)
	e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function cm.thfilter(c)
	return (c:IsSetCard(0xccd) or rk.check(c,"DAIOU")) and c:IsAbleToHand()
end
function cm.addop(e,tp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	Debug.Message(tc:GetCode())
	if not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) or not tc:IsAbleToHand() then return end
	if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT,nil)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,tp,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end
function cm.cnfilter(c,rc)
	return c:IsFaceup() and c:IsRace(rc:GetOriginalRace())
end
function cm.val(e,c)
	return Duel.IsExistingMatchingCard(cm.cnfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,c)
end
function cm.actlimit(e,re,tp)
	return Duel.IsExistingMatchingCard(cm.cnfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,re:GetHandler())
end
function cm.locfilter(c)
	return c:IsLocation(LOCATION_SZONE) and not c:IsLocation(LOCATION_FZONE)
end
function cm.filter(g,ct,ct1)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<=ct and g:FilterCount(cm.locfilter,nil)<=ct1
end
function cm.filter2(c,ct,ct1)
	return c:IsAbleToChangeControler() and ((c:IsLocation(LOCATION_MZONE) and ct>0) or (c:IsLocation(LOCATION_SZONE) and not c:IsLocation(LOCATION_FZONE) and ct1>0) or c:IsLocation(LOCATION_FZONE))
end
function cm.ctlfilter(c,ct,ct1)
	return c:IsAbleToChangeControler()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct2=Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)
	local g=Duel.GetMatchingGroup(cm.ctlfilter,tp,0,LOCATION_ONFIELD,nil)
	if chkc then return cm.filter(chkc,ct1,ct2) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter2,tp,0,LOCATION_ONFIELD,1,nil,ct1,ct2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local sg=g:SelectSubGroup(tp,cm.filter,false,1,2,ct1,ct2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc,tc1=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsLocation(LOCATION_MZONE) then
			Duel.GetControl(tc,tp)
		elseif tc:IsLocation(LOCATION_FZONE) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			local pos=tc:GetPosition()
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,pos,true)
		else
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				local pos=tc:GetPosition()
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,pos,true)
			else
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		end
	end
	if tc1 and tc1:IsRelateToEffect(e) then
		if tc1:IsLocation(LOCATION_MZONE) then
			Duel.GetControl(tc1,tp)
		elseif tc1:IsLocation(LOCATION_FZONE) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			local pos=tc1:GetPosition()
			Duel.MoveToField(tc1,tp,tp,LOCATION_FZONE,pos,true)
		else
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				local pos=tc1:GetPosition()
				Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,pos,true)
			else
				Duel.SendtoGrave(tc1,REASON_RULE)
			end
		end
	end
end