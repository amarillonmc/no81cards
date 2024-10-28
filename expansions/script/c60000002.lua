--承岚 FR-0026M
local cm,m,o=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(0xff)
	e3:SetCost(cm.icost)
	e3:SetCondition(cm.icon)
	e3:SetTarget(cm.itg)
	e3:SetOperation(cm.iop)
	c:RegisterEffect(e3)
end
function cm.filter1(c)
	return c:IsPublic() and c:IsAbleToGraveAsCost()
end
function cm.filter2(c)
	return c:IsSetCard(0x3623) and not c:IsCode(m) and c:IsAbleToGraveAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND,LOCATION_HAND,1,c) 
		or (Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,m)==0))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local c=e:GetHandler()
	local wt=0
	if Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND,LOCATION_HAND,1,c)
		and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,m)==0 
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		wt=1
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	if not Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND,LOCATION_HAND,1,c)
		and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,m)==0 then
		wt=1
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if wt==1 then
		g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)
	elseif wt==0 then
		g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_HAND,LOCATION_HAND,1,1,c)
	end
	local tc=g:GetFirst()
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3623) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.icost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if not (c:IsPublic() or c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) then Duel.ConfirmCards(1-tp,c) end
end
function cm.icon(e,tp,eg,ep,ev,re,r,rp)
	local tf=false
	local c=e:GetHandler()
	local loc=0
	if c:IsLocation(LOCATION_DECK) then loc=1 
	elseif c:IsLocation(LOCATION_HAND) then loc=2
	elseif c:IsLocation(LOCATION_ONFIELD) then loc=3
	elseif c:IsLocation(LOCATION_GRAVE) then loc=4
	elseif c:IsLocation(LOCATION_REMOVED) then loc=5 end
	if loc==0 then return end
	if e:GetLabel()==0 then
		tf=false
	elseif e:GetLabel()~=loc then
		tf=true
	end
	e:SetLabel(loc)
	return tf
end
function cm.itg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.iop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetLabel(tc:GetCode())
		e1:SetTarget(cm.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se and se:GetHandler():IsCode(m) and c:GetCode()==e:GetLabel()
end