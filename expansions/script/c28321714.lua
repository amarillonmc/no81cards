--放课后时间胶囊！
function c28321714.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c28321714.target)
	e1:SetOperation(c28321714.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28321714,4))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28321714.tgcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c28321714.tgtg)
	e2:SetOperation(c28321714.tgop)
	c:RegisterEffect(e2)
end
function c28321714.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return false end
		return Duel.GetDecktopGroup(tp,2) and Duel.IsPlayerCanRemove(tp)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c28321714.thfilter(c)
	return c:IsSetCard(0x286) and c:IsAbleToHand()
end
function c28321714.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=2
	if aux.GetAttributeCount(Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil))>=3 and Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>=3 and Duel.SelectOption(p,aux.Stringid(28321714,0),aux.Stringid(28321714,1))==1 then
		ct=3
	end
	Duel.ConfirmDecktop(p,ct)
	local g=Duel.GetDecktopGroup(p,ct)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(p,c28321714.thfilter,0,#g,nil)
		if #sg>0 then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
			g:Sub(sg)
		end
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		local ct=Duel.GetTurnPlayer()==p and 2 or 1
		local fid=e:GetHandler():GetFieldID()
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(28321714,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,ct,fid,aux.Stringid(28321714,3))
		end
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid,Duel.GetTurnCount()+ct)
		e1:SetLabelObject(g)
		e1:SetCondition(c28321714.thcon)
		e1:SetOperation(c28321714.thop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,ct)
		Duel.RegisterEffect(e1,p)
	end
end
function c28321714.cfilter(c,fid)
	return c:GetFlagEffectLabel(28321714)==fid and c:IsAbleToHand()
end
function c28321714.thcon(e,tp,eg,ep,ev,re,r,rp)
	local fid,ct=e:GetLabel()
	if Duel.GetTurnCount()<ct then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c28321714.cfilter,1,nil,fid) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c28321714.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,28321714)
	local fid,ct=e:GetLabel()
	local g=e:GetLabelObject()
	local sg=g:Filter(c28321714.cfilter,nil,fid)
	--g:DeleteGroup()
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	--e:Reset()
end
function c28321714.chkfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
end
function c28321714.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_MZONE)
end
function c28321714.tgfilter(c)
	return c:IsSetCard(0x286) and c:IsAbleToGrave()
end
function c28321714.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28321714.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c28321714.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28321714.tgfilter,tp,LOCATION_DECK,0,1,2,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
