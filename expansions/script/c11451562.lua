--诡雷战术 长程破袭
--21.04.22
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--trap
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	--e3:SetCountLimit(1,m)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(cm.con)
	e3:SetCost(cm.trcost)
	e3:SetTarget(cm.trtg)
	e3:SetOperation(cm.trop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(aux.NOT(cm.con))
	c:RegisterEffect(e4)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,11451556)
end
function cm.trcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:GetEquipTarget() end
	if c:IsFacedown() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11451561,3)) then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
		Duel.SetChainLimit(function(e,ep,tp) return tp==ep end)
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.filter(c)
	return c:GetEquipTarget() and c:IsFacedown()
end
function cm.trtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>0 end
end
function cm.sfilter(c,e,tp)
	return c:IsSetCard(0x97e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.trop(e,tp,eg,ep,ev,re,r,rp)
	local spg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if #spg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(11451561,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=spg:Select(tp,1,1,nil)
		if sg and #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	Duel.AdjustAll()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)
	if ft==0 then return end
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_ONFIELD,0,1,ft,nil)
	if not g or #g==0 then return end
	local tg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local rc=tc:GetEquipTarget()
		if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,false) then
			tg:AddCard(tc)
			Duel.Equip(1-tp,tc,rc,false)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESET_MSCHANGE+RESET_CONTROL+RESET_OVERLAY,0,1)
		end
	end
	tg=tg:Filter(Card.GetEquipTarget,nil)
	if #tg==0 then return end
	Duel.ConfirmCards(tp,tg)
	tg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	--[[e1:SetCountLimit(1)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end--]]
	e1:SetCondition(cm.tgcon)
	e1:SetOperation(cm.tgop)
	e1:SetLabelObject(tg)
	Duel.RegisterEffect(e1,tp)
end
function cm.tgfilter(c)
	return c:GetFlagEffect(m)>0 --and c:IsOnField()
end
function cm.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
function cm.xylabel2(c,tp)
	local x=c:GetPreviousSequence()
	local y=0
	if c:GetPreviousControler()==tp then
		if c:IsPreviousLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsPreviousLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsPreviousLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsPreviousLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetPreviousControler()==1-tp then
		if c:IsPreviousLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsPreviousLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsPreviousLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsPreviousLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
function cm.seqfilter(c,tc,tp)
	local x1,y1=cm.xylabel(c,tp)
	local x2,y2=cm.xylabel2(tc,tp)
	return (x1==x2 and math.abs(y1-y2)==1) or (y1==y2 and math.abs(x1-x2)==1)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local tg=e:GetLabelObject()
	return tg and tg:Filter(cm.tgfilter,nil):IsExists(aux.IsInGroup,1,nil,eg) --and (not ct or Duel.GetTurnCount()~=ct)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local tg=e:GetLabelObject():Filter(cm.tgfilter,nil):Filter(aux.IsInGroup,nil,eg)
	local dg=Group.CreateGroup()
	for tc in aux.Next(tg) do
		tc:ResetFlagEffect(m)
		local g=Duel.GetMatchingGroup(cm.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tc,tp)
		dg:Merge(g)
	end
	Duel.SendtoGrave(dg,REASON_EFFECT)
	e:GetLabelObject():Sub(tg)
end