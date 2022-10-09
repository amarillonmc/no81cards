--蛊 惑
local m=22348027
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348027,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22348027.tg)
	e1:SetOperation(c22348027.op)
	c:RegisterEffect(e1)
end

function c22348027.filter(c)
	return c:IsAbleToGrave()
end
function c22348027.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348027.filter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c22348027.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	e:SetLabel(ac)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c22348027.filter1(c)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	return c:IsCode(ac)
end
function c22348027.op(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.SelectYesNo(1-tp,aux.Stringid(22348027,1)) then
	   if Duel.IsExistingMatchingCard(c22348027.filter1,tp,LOCATION_HAND,0,1,nil) then
		  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
		  local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		  if g:GetCount()>0 then
			  Duel.ConfirmCards(tp,g2)
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			  local sg=g:Select(tp,1,1,nil)
			  Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
			  Duel.ShuffleHand(1-tp)
		  end
	   else
		  local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		  local dg=sg:RandomSelect(tp,1)
		  Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	   end
	else 
	   local g1=Duel.CreateToken(tp,ac)
	   Duel.SendtoHand(g1,tp,REASON_EFFECT)
	end
end