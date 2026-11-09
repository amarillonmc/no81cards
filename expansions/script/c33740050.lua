--构图
function c33740050.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33740050+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33740050.target)
	e1:SetOperation(c33740050.activate)
	c:RegisterEffect(e1)
	--check
	if not c33740050.global_check then
		c33740050.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(c33740050.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33740050.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(tc:GetControler(),33740050,RESET_PHASE+PHASE_END,0,1)
	end
end
function c33740050.gcheck(sg)
	return sg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and sg:IsExists(Card.IsType,1,nil,TYPE_SPELL) and sg:IsExists(Card.IsType,1,nil,TYPE_TRAP)
end
function c33740050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil,tp,POS_FACEDOWN)
	if chk==0 then return g:CheckSubGroup(c33740050.gcheck,3,3) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,3,0,0)
end
function c33740050.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(1-tp,33740050)>=7 and Duel.GetFlagEffect(1-tp,33740050)+3 or 3
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil,tp,POS_FACEDOWN)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c33740050.gcheck,false,3,ct)
	if not sg or #sg==0 or Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	local fid=e:GetHandler():GetFieldID()
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(33740050,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(33740050,0))
	end
	og:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(c33740050.reptg)
	e1:SetValue(c33740050.repval)
	e1:SetLabel(fid)
	e1:SetLabelObject(og)
	Duel.RegisterEffect(e1,tp)
end
function c33740050.repfilter(c)
	return c:GetDestination()==LOCATION_HAND and c:IsLocation(LOCATION_DECK)
end
function c33740050.retfilter(c,fid)
	return c:GetFlagEffectLabel(33740050)==fid and c:IsAbleToHand()
end
function c33740050.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c33740050.repfilter,nil)
	local rg=e:GetLabelObject():Filter(c33740050.retfilter,nil,e:GetLabel())
	if chk==0 then return ep==tp and bit.band(r,REASON_EFFECT)~=0 and #g>0 and #rg>0 end
	if Duel.SelectYesNo(tp,aux.Stringid(33740050,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=rg:Select(tp,1,1,nil):GetFirst()
		Duel.RegisterFlagEffect(tp,33740050+1,RESET_CHAIN,0,1)
		Duel.HintSelection(Group.FromCards(tc))
		local tg=eg:Filter(aux.TRUE,g)
		tg:AddCard(tc)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		return true
	else
	return false end
end
function c33740050.thlimit(e,c,tp,re)
	return re==e:GetLabelObject()
end
function c33740050.repval(e,c)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),33740050+1)~=0
end
