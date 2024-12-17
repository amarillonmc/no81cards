--承岚 FR-0036A
local cm,m,o=GetID()
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
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
function cm.drfil1(c)
	return c:IsPublic() and c:IsAbleToGrave()
end
function cm.drfil2(c)
	return c:IsSetCard(0x3623) and c:IsAbleToRemove()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) 
	and (Duel.IsExistingMatchingCard(cm.drfil1,tp,LOCATION_HAND,LOCATION_HAND,1,nil) 
		or (Duel.IsExistingMatchingCard(cm.drfil2,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,m)==0)) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local wt=0
	if Duel.IsExistingMatchingCard(cm.drfil1,tp,LOCATION_HAND,LOCATION_HAND,1,nil)
		and Duel.IsExistingMatchingCard(cm.drfil2,tp,LOCATION_GRAVE,0,1,nil) 
		and Duel.GetFlagEffect(tp,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		wt=1
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	if not Duel.IsExistingMatchingCard(cm.drfil1,tp,LOCATION_HAND,LOCATION_HAND,1,nil)
		and Duel.IsExistingMatchingCard(cm.drfil2,tp,LOCATION_GRAVE,0,1,nil) 
		and Duel.GetFlagEffect(tp,m)==0 then
		wt=1
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	local g=nil
	local num=0
	if wt==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=Duel.SelectMatchingCard(tp,cm.drfil2,tp,LOCATION_GRAVE,0,1,1,nil)
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then num=num+1 end
		if Duel.IsExistingMatchingCard(cm.drfil1,tp,LOCATION_HAND,LOCATION_HAND,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			gg=Duel.SelectMatchingCard(tp,cm.drfil1,tp,LOCATION_HAND,LOCATION_HAND,1,1,nil)
			if Duel.SendtoGrave(gg,REASON_EFFECT)~=0 then num=num+1 end
		end
	elseif wt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=Duel.SelectMatchingCard(tp,cm.drfil1,tp,LOCATION_HAND,LOCATION_HAND,1,2,nil)
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then num=#Duel.GetOperatedGroup() end
	end
	Duel.Draw(tp,num,REASON_EFFECT)
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
		Duel.RegisterFlagEffect(tp,m+10000000,0,0,1)
	end
	e:SetLabel(loc)
	return tf
end
function cm.itg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
end
function cm.iop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,Duel.GetFlagEffect(tp,m+10000000),nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end