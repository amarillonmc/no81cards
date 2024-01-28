--人生如逆旅
local s,id,o=GetID()
function c13000747.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon condition
   
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	e2:SetCondition(s.sprcon)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.lvcon)
	e3:SetOperation(s.lvop)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	e6:SetCountLimit(1)
	e6:SetTarget(s.target)
	e6:SetOperation(s.operation)
	c:RegisterEffect(e6)
	--effect gain
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BE_MATERIAL)
	e7:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e7:SetCondition(s.effcon)
	e7:SetOperation(s.effop)
	c:RegisterEffect(e7)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK+REASON_RITUAL)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function s.thfilter(c)
	return (c:IsRace(RACE_BEAST) or c:IsRace(RACE_BEASTWARRIOR)) and c:IsAbleToHand() and c:IsLevelAbove(7)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local aa=g:GetFirst():GetAttribute()
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if tg:IsExists(s.filter9,1,nil,tp,aa) then
		   if Duel.SelectYesNo(tp,aux.Stringid(13000747,0)) then
		   local ta=tg:SelectSubGroup(tp,s.filter9,true,1,1,tp,aa)
		   Duel.Destroy(ta,REASON_EFFECT)
	end
end
end
end
function s.filter9(c,tp,aa)
	return Card.IsPublic(c) and Card.IsAttribute(c,aa) 
end
function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffectLabel(tp,s)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local level=Duel.GetFlagEffectLabel(tp,s)
	Duel.ResetFlagEffect(tp,s)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(level)
	c:RegisterEffect(e1)
end
function s.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and (c:IsAbleToHandAsCost() or c:IsAbleToExtraAsCost())
end
function s.fselect(g,tp,sc)
	return g:GetCount()==2 and g:GetClassCount(Card.GetLevel)>=2
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(s.fselect,2,2)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,s.fselect,false,2,2,tp,c)
	local ta=tg:GetFirst()
	local tb=tg:GetNext()
	local aa=ta:GetLevel()
	local bb=tb:GetLevel()
	Duel.SendtoHand(tg,1-tp,REASON_COST+REASON_MATERIAL)
	local cc=math.abs(aa-bb)
	e:GetHandler():SetMaterial(tg)
   Duel.RegisterFlagEffect(tp,s,0,0,1,cc)
		if ta:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(66)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			ta:RegisterEffect(e1)
		end
		if tb:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(66)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tb:RegisterEffect(e1)
		
	end
end




