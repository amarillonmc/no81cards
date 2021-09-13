--精神寰宇 月触乱影
local m=33502156
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
	if Duel.GetMatchingGroupCount(cm.thfilter1,1-tp,LOCATION_MZONE,LOCATION_MZONE,nil)<=1 then return end
	local xg=Duel.SelectMatchingCard(tp,su_y.stfile,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
  if #xg>0 then
	Duel.SendtoHand(xg,tp,REASON_EFFECT) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,1-tp,LOCATION_MZONE,0,1,1,nil)
	local zc=g:GetFirst()
	local ag=Duel.GetMatchingGroup(cm.thfilter1,1-tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	ag:RemoveCard(zc)
	local sg=ag:RandomSelect(tp,1)
	local sc=sg:GetFirst()
	if zc and sc then
		Duel.CalculateDamage(zc,sc)
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e6:SetCode(EVENT_TO_GRAVE)
			e6:SetReset(RESET_CHAIN)
			e6:SetOperation(cm.disop1)
			Duel.RegisterEffect(e6,tp)
	end
 end
end
function cm.stfile(c)
	return c:IsSetCard(0x3a81) and  c:IsAbleToHand()
end
function cm.thfilter1(c)
	return c:IsFaceup() 
end
function cm.tdfilter3(c,tp)
	return  c:IsAbleToDeck()
end
function cm.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:FilterCount(cm.tdfilter3,nil,tp)>0 then
		local tg=eg:Filter(cm.tdfilter3,nil,tp)
		local tc=tg:GetFirst() 
		while tc do
		if Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)~=0 then
		tc:ReverseInDeck() end
		tc=tg:GetNext()
		end
	 end
end