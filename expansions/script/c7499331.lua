--艺形虫 超现实X-S-24
local s,id,o=GetID()
--string
s.named_with_ArtlienWorm=1
--string check
function s.ArtlienWorm(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ArtlienWorm
end
--
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.rmfilter(c)
	return s.ArtlienWorm(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:IsExists(s.rmfilter,1,nil) end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local g=og:Filter(s.rmfilter,nil)
	if g:GetCount()==0 or not c:IsRelateToEffect(e) then return end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local rg=Duel.GetOperatedGroup()
		for tc in aux.Next(rg) do
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		rg:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(rg)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e0:SetTargetRange(LOCATION_REMOVED,0)
		e0:SetCode(EFFECT_SEND_REPLACE)
		e0:SetLabelObject(rg)
		e0:SetTarget(s.reptg)
		e0:SetValue(s.repval)
		Duel.RegisterEffect(e0,tp)
	end
end
function s.retfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local g=e:GetLabelObject()
	local og=g:Filter(s.retfilter,nil,e:GetLabel())
	if c:GetFlagEffectLabel(id)==e:GetLabel() then return
		Duel.Overlay(c,og)
	else
		Duel.SendtoGrave(og,REASON_EFFECT+REASON_RETURN)
	end
	g:DeleteGroup()
end
--replace
function s.repfilter(c,rg)
	return rg:IsContains(c) and c:IsLocation(LOCATION_REMOVED) and 
	bit.band(c:GetDestination(),LOCATION_GRAVE+LOCATION_DECK)~=0 
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=e:GetLabelObject()
	if not rg then e:Reset() end
	if chk==0 then return rg and eg:IsExists(s.repfilter,1,nil,rg) end
	local reg=eg:Filter(s.repfilter,nil,rg)
	local tg=Group.CreateGroup()
	if #reg>0 then
		local tc=reg:GetFirst()
		while tc do
			if tc:GetDestination()==LOCATION_DECK then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TO_DECK_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(LOCATION_HAND)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				tc:RegisterFlagEffect(id+1,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
			elseif tc:GetDestination()==LOCATION_GRAVE then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(LOCATION_HAND)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				tc:RegisterFlagEffect(id+1,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
			end
			tc=reg:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCountLimit(1)
		e1:SetCondition(s.thcon)
		e1:SetOperation(s.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if (#reg)==0 then return false end
	return true
end
function s.repval(e,c)
	return false
end
function s.thfilter(c)
	return c:GetFlagEffect(id+1)~=0
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.thfilter,1,nil)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
--
function s.chkfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsReason(REASON_DRAW) 
	and (c:IsPublic() or (not c:IsStatus(STATUS_TO_HAND_WITHOUT_CONFIRM) and (c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousPosition(POS_FACEUP))))
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.chkfilter,1,nil)
end
function s.spfilter(c,e,tp)
	return s.ArtlienWorm(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) and Duel.GetMZoneCount(tp)>0 and c:IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,aux.ExceptThisCard(e),e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		if e:GetHandler():IsRelateToEffect(e) then
			Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end
