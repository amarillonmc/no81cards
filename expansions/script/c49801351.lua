--水眷号 阿佛洛狄忒卜
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddXyzProcedure(c,nil,5,2,s.mfilter,aux.Stringid(id,0),2,s.altop)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.ovcon)
	e2:SetTarget(s.ovtg)
	e2:SetOperation(s.ovop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.mfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetMaxGroup(Card.GetDefense)
	return g and #g>0 and g:IsContains(c)
end
function s.gettype(c)
	if c:IsFacedown() then return -1 end
	return c:GetRace()*0x80+c:GetAttribute()
end
function s.altop(e,tp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if chk==0 then return g:GetCount()>=3 and g:GetClassCount(s.gettype)==1 and Duel.GetFlagEffect(tp,id+10000)==0 end
	Duel.RegisterFlagEffect(tp,id+10000,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.GetRaceCount(g)
	if #g==0 then return 0 end
	local race=0
	for tc in aux.Next(g) do
		race=race|tc:GetRace()
	end
	local ct=0
	while race~=0 do
		if race&0x1~=0 then ct=ct+1 end
		race=race>>1
	end
	return ct
end
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(Card.IsSummonPlayer,nil,1-tp)~=1 then return false end
	local ec=eg:Filter(Card.IsSummonPlayer,nil,1-tp):GetFirst()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,ec)
	return g:FilterCount(aux.TRUE,ec)>0 and aux.GetAttributeCount(g:__add(ec))>aux.GetAttributeCount(g) and s.GetRaceCount(g:__add(ec))>s.GetRaceCount(g)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,1)
	if c:IsRelateToEffect(e) and g:GetCount()==1 then
		local tc=g:GetFirst()
		Duel.DisableShuffleCheck()
		if tc:IsCanOverlay() then
			Duel.Overlay(c,g)
		else
			Duel.SendtoGrave(g,REASON_RULE)
		end
	end
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup():Filter(Card.IsType,nil,TYPE_MONSTER)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,og,#og,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,c,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup():Filter(Card.IsType,nil,TYPE_MONSTER)
	if c:IsRelateToEffect(e) and Duel.SendtoHand(og,nil,REASON_EFFECT)>0 then
		Duel.Release(c,REASON_EFFECT)
	end
end