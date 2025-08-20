--归零纪元 伊瑟琳
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,99,s.lcheck)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--The Key
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(s.keycon)
	e3:SetOperation(s.keyop)
	c:RegisterEffect(e3)
	--The Key+500
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(s.kcon)
	e4:SetOperation(s.kop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
	e5:SetCost(s.spcost)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(s.con)
	c:RegisterEffect(e6)
	--tohand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,1))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetTarget(s.thtg)
	e7:SetOperation(s.thop)
	c:RegisterEffect(e7)
end
function s.lcheck(g)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_CYBERSE)
end
function s.atkval(e,c)
	local ct=Duel.GetFlagEffectLabel(tp,75646600-o)
	local atk=500
	if ct>0 then atk=500+ct*500 end
	return atk
end
function s.keycon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),75646600)==0
end
function s.keyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,75646600,RESET_EVENT+RESET_PHASE+RESET_CHAIN,0,1)
end
function s.kcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x92c1)
end
function s.kop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x7f,0,nil,75646600)
	if rg:GetCount()>0 then
		local rc=rg:GetFirst()
		while rc do
			if rc:GetFlagEffect(5646600)<15 then
				rc:RegisterFlagEffect(5646600,0,0,0)
			end
			rc:ResetFlagEffect(646600)
			rc:RegisterFlagEffect(646600,0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(75646600,rc:GetFlagEffect(5646600)))	
			rc=rg:GetNext()
		end
	end
end
function s.con(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),75646600)~=0
end
function s.cfilter(c,g,e,tp)
	return g:IsContains(c) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.cfilter,1,nil,lg,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,s.cfilter,1,1,nil,lg,e,tp)
	Duel.Release(g,REASON_COST)
end
function s.spfilter(c,e,tp,mc)
	return (c:IsRace(RACE_CYBERSE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsLocation(LOCATION_DECK+LOCATION_GRAVE) and Duel.GetMZoneCount(tp,mc)>0) 
		or (c:IsSetCard(0xc2c3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.thfilter(c,chk)
	return (c:IsCode(75646600) or (chk>0 and aux.IsCodeListed(c,75646600))) and c:IsAbleToHand() and c:IsFaceupEx() 
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetFlagEffect(tp,75646600)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ct1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x7f,0,nil,75646600)
	if rg:GetCount()>0 then
		local rc=rg:GetFirst()
		while rc do
			if rc:GetFlagEffect(5646600)<15 then
				rc:RegisterFlagEffect(5646600,0,0,0)
			end
			rc:ResetFlagEffect(646600)
			rc:RegisterFlagEffect(646600,0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(75646600,rc:GetFlagEffect(5646600)))
			rc=rg:GetNext()
		end
	end
	local ct1=Duel.GetFlagEffect(tp,75646600)
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ct1) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,ct1)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end