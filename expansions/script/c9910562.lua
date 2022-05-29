--甜心机仆 永恒的礼物
require("expansions/script/c9910550")
function c9910562.initial_effect(c)
	--flag
	Txjp.AddTgFlag(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910562.rmcon)
	e1:SetOperation(c9910562.rmop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MOVE)
	e2:SetCountLimit(1,9910562)
	e2:SetCondition(c9910562.thcon)
	e2:SetTarget(c9910562.thtg)
	e2:SetOperation(c9910562.thop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_MOVE)
	e3:SetCountLimit(1,9910563)
	e3:SetCondition(c9910562.drcon)
	e3:SetTarget(c9910562.drtg)
	e3:SetOperation(c9910562.drop)
	c:RegisterEffect(e3)
end
function c9910562.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK 
end
function c9910562.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if c:IsFaceup() and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910562,0)) then
		Duel.Hint(HINT_CARD,0,9910562)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		sg:AddCard(c)
		Duel.HintSelection(sg)
		if sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)~=2 then
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			return
		end
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
		local og=Duel.GetOperatedGroup()
		if og:GetCount()~=2 then return end
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(9910562,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910562.retcon)
		e1:SetOperation(c9910562.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910562.retfilter(c,fid)
	return c:GetFlagEffectLabel(9910562)==fid
end
function c9910562.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:FilterCount(c9910562.retfilter,nil,e:GetLabel())~=2 then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c9910562.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if Duel.SelectYesNo(tp,aux.Stringid(9910562,1)) then
		Duel.ReturnToField(g:GetFirst())
		Duel.ReturnToField(g:GetNext())
		g:DeleteGroup()
		e:Reset()
	end
end
function c9910562.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function c9910562.thfilter(c)
	return c:IsSetCard(0x3951) and c:IsAbleToHand()
end
function c9910562.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910562.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910562.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910562.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910562.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_REMOVED) and c:IsReason(REASON_RETURN)
end
function c9910562.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910562.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
