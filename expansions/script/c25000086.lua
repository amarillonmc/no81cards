--都柏林人
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000086)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m})
	e1:SetOperation(cm.act)
end
function cm.act(e,tp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cm.reptg)
	e1:SetValue(cm.repval)
	e1:SetReset(rsreset.pend)
	Duel.RegisterEffect(e1,tp)
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.SendtoHand(c,1-tp,REASON_EFFECT)
	end
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsOnField() and c:GetDestination()&LOCATION_GRAVE+LOCATION_REMOVED ~=0 and c:GetLeaveFieldDest()==0 and c:GetReasonPlayer()~=tp and c:GetOwner()~=tp
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) end
	local rg=eg:Filter(cm.repfilter,1,nil,tp)
	local exg=rg:Filter(Card.IsType,nil,rscf.extype)
	if #exg>0 then
		Duel.SendtoDeck(rg,tp,2,REASON_EFFECT)
	end
	Duel.SendtoHand(rg-exg,tp,REASON_EFFECT+REASON_REDIRECT)
end
function cm.repval(e,c)
	return true
end