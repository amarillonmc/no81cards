--精神寰宇 心语之谜
local m=33502152
local cm=_G["c"..m]
Duel.LoadScript("c33502151.lua")
function cm.initial_effect(c)
	local e0,e1=su_y.hdtograve(c,m,1)
	local e2=su_y.sel(c,m,1)
	local e3=su_y.seltu(c)
	local e4=su_y.chai(c,m,1,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetLabelObject(e)
	e1:SetTarget(su_y.splimitcost)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.cop)
end
function cm.cop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(cm.stfile,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)<=0 then return end
	local c=e:GetHandler()
	if Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x3a81)<=0 or Duel.GetMatchingGroupCount(cm.thfilter1,1-tp,LOCATION_MZONE,0,nil)<=0 then return end
	local xg=Duel.SelectMatchingCard(tp,su_y.stfile,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
  if #xg>0 then
	Duel.SendtoHand(xg,tp,REASON_EFFECT) 
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,1-tp,LOCATION_MZONE,0,1,1,nil)
	local zc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x3a81)
	local sc=sg:GetFirst()
	if zc:IsImmuneToEffect(e) then return end
	if zc and sc and then
		Duel.Overlay(zc,sc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_XMATERIAL)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		sc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_UNRELEASABLE_SUM)
		e3:SetValue(1)
		sc:RegisterEffect(e3,true)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		sc:RegisterEffect(e4,true)
	end
 end
end
function cm.stfile(c)
	return c:IsSetCard(0x3a81) and  c:IsAbleToHand()
end
function cm.thfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) 
end