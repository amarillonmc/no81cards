--精神寰宇 虚幻之触
local m=33502153
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
	if Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)<=0 then return end
	local xg=Duel.SelectMatchingCard(tp,su_y.stfile,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	if #xg>0 then
	Duel.SendtoHand(xg,tp,REASON_EFFECT) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local zc=g:GetFirst()
	if zc then
		if Duel.SendtoDeck(zc,tp,2,REASON_EFFECT)~=0 then
		zc:ReverseInDeck()
		local sc=Duel.GetOperatedGroup():GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		end
	end
 end
end
function cm.stfile(c)
	return c:IsSetCard(0x3a81) and  c:IsAbleToHand()
end