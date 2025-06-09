--吞噬虚空
local s,id=GetID()
function c13000745.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,id+100+EFFECT_COUNT_CODE_DUEL)   
	e2:SetCost(s.xtkcost)
	e2:SetTarget(s.xtktg)
	e2:SetOperation(s.xtkop)
	c:RegisterEffect(e2) 
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,0,LOCATION_EXTRA,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local extra=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,extra)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,0,LOCATION_EXTRA,1,1,nil,e,tp):GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(13000745,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetCondition(s.tecon)
		e3:SetOperation(s.teop)
		e3:SetCountLimit(1)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.tecon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(13000745)==e:GetLabel() then
		return Duel.GetTurnPlayer()==tp
	else
		e:Reset()
		return false
	end
end
function s.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,SEQ_DECKTOP,REASON_EFFECT)
end
function s.thfilter(c,tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	return c:IsAbleToHandAsCost() and g:IsExists(s.exifilter,1,nil,c)
end
function s.exifilter(c,tc)
	local typec=bit.band(c:GetType(),0x7)
	local typetc=bit.band(tc:GetType(),0x7)
	return bit.band(typec,typetc)~=0
end

function s.xtkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.xtktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:GetHandler():IsAbleToDeckOrExtraAsCost()
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,e:GetHandler(),tp)
	end
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	local sc=g:GetFirst()
	if Duel.SendtoDeck(e:GetHandler(),1-tp,SEQ_DECKTOP,REASON_COST)~=0 and Duel.SendtoHand(sc,1-tp,1,REASON_COST)~=0 then
		e:SetLabelObject(sc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(66)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function s.thfilter2(c,type)
	local typec=bit.band(c:GetType(),0x7)
	local typetc=bit.band(type,0x7)
	return c:IsAbleToHand() and bit.band(typec,typetc)~=0
end
function s.xtkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	local type=tc:GetType()
	local g=Duel.SelectMatchingCard(1-tp,s.thfilter2,tp,0,LOCATION_ONFIELD,1,1,nil,type)
	local sc=g:GetFirst()
	if Duel.SendtoHand(sc,tp,REASON_RULE)~=0 then
		if sc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(66)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1)
		end
		local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil)
		if #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local ka=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
			if #ka>0 then
				Duel.SendtoDeck(ka,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
		if #g2>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local kb=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
			if #kb>0 then
				Duel.SendtoDeck(kb,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end