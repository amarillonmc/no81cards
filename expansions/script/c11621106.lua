--双型镜·虚妄之影
local m=11621106
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
	--change code
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cdcost)
	e2:SetOperation(cm.cdop)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op1=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
	local op2=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
	local tc1=Duel.CreateToken(tp,m+1+op1)
	local tc2=Duel.CreateToken(tp,m+1+op2)
	local g=Group.FromCards(tc1,tc2)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
end

-----------------------------------------------------------------------

function cm.cdfilter(c,typ)
	return c:IsType(typ) and not c:IsSetCard(0x9220)
end
function cm.cdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.cdfilter,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
	local g2=Duel.GetMatchingGroup(cm.cdfilter,tp,LOCATION_HAND,0,nil,TYPE_SPELL)
	local g3=Duel.GetMatchingGroup(cm.cdfilter,tp,LOCATION_HAND,0,nil,TYPE_TRAP)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and #g1+#g2+#g3>0 end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	local sg=Group.CreateGroup()
	if #g1>0 and ((#g2==0 and #g3==0) or Duel.SelectYesNo(tp,aux.Stringid(m,5))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g1:Select(tp,1,1,nil)
		sg:Merge(sg1)
	end
	if #g2>0 and ((#sg==0 and #g3==0) or Duel.SelectYesNo(tp,aux.Stringid(m,6))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg2=g2:Select(tp,1,1,nil)
		sg:Merge(sg2)
	end
	if #g3>0 and (#sg==0 or Duel.SelectYesNo(tp,aux.Stringid(m,7))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg3=g3:Select(tp,1,1,nil)
		sg:Merge(sg3)
	end
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	sg:KeepAlive()
	e:SetLabelObject(sg)
end
function cm.cdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local tc1=g:Filter(Card.IsType,nil,TYPE_MONSTER):GetFirst()
	local tc2=g:Filter(Card.IsType,nil,TYPE_SPELL):GetFirst()
	local tc3=g:Filter(Card.IsType,nil,TYPE_TRAP):GetFirst()
	if tc1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(0xff,0xff)
		e1:SetTarget(cm.cdtg)
		e1:SetLabel(m+1)
		e1:SetValue(tc1:GetAttribute())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(tc1:GetRace())
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(tc1:GetLevel())
		Duel.RegisterEffect(e3,tp)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_CODE)
		e4:SetValue(tc1:GetCode())
		Duel.RegisterEffect(e4,tp)
	end
	if tc2 then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CHANGE_CODE)
		e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e5:SetTargetRange(0xff,0xff)
		e5:SetTarget(cm.cdtg)
		e5:SetLabel(m+2)
		e5:SetValue(tc2:GetCode())
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_CHANGE_TYPE)
		e6:SetValue(tc2:GetType())
		Duel.RegisterEffect(e6,tp)
	end
	if tc3 then
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_CHANGE_CODE)
		e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e7:SetTargetRange(0xff,0xff)
		e7:SetTarget(cm.cdtg)
		e7:SetLabel(m+3)
		e7:SetValue(tc3:GetCode())
		e7:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e7,tp)
		local e8=e7:Clone()
		e8:SetCode(EFFECT_CHANGE_TYPE)
		e8:SetValue(tc3:GetType())
		Duel.RegisterEffect(e8,tp)
	end
	g:DeleteGroup()
end
function cm.cdtg(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end