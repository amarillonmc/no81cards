--光铸之圣域-天界城
local m=11451544
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPSUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.adcon)
	e1:SetCost(cm.adcost)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--opspsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPSUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(cm.adcon2)
	e2:SetTarget(cm.adtg2)
	e2:SetOperation(cm.adop2)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--release replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetTarget(cm.reptg)
	e3:SetValue(function(e,c) return c:GetFlagEffect(m)>0 end)
	c:RegisterEffect(e3)
end
function cm.filter(c,tp)
	return c:IsControler(tp)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsPublic,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g>0 end
	local sc=g:Select(tp,1,1,nil):GetFirst()
	sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	local eset={sc:IsHasEffect(EFFECT_PUBLIC)}
	if #eset>0 then
		for _,ae in pairs(eset) do
			if ae:IsHasType(EFFECT_TYPE_SINGLE) then
				ae:Reset()
			else
				local tg=ae:GetTarget() or aux.TRUE
				ae:SetTarget(function(e,c,...) return tg(e,c,...) and c:GetFlagEffect(m)==0 end)
			end
		end
	end
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x52)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
end
function cm.adcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
end
function cm.adtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and (Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 or Duel.IsExistingMatchingCard(cm.spfilter2,tp,0,LOCATION_GRAVE,1,nil,e,1-tp)) and Duel.IsPlayerCanSpecialSummon(1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local aat=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	e:SetLabel(aat)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND)
end
function cm.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.adop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local att=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(cm.spfilter2,tp,0,LOCATION_HAND,nil,e,1-tp)
	if #g==0 then g=Duel.GetMatchingGroup(cm.spfilter2,tp,0,LOCATION_GRAVE,nil,e,1-tp) end
	local sg=g:Select(1-tp,1,1,nil)
	if #sg>0 and Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sg:GetFirst():RegisterEffect(e1)
	end
end
function cm.filter2(c,re,tp,r)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and re:IsActivated() and bit.band(r,REASON_COST)~=0 and re:GetHandler()==c
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.filter2,1,nil,re,tp,r) end
	if e:GetHandler():IsReleasable() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local g=eg:Filter(cm.filter2,nil,re,tp,r)
		g:ForEach(Card.RegisterFlagEffect,m,RESET_CHAIN,0,1)
		Duel.Release(e:GetHandler(),REASON_COST)
		return true
	else return false end
end