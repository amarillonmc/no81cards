--不再有梦
local m=150013
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,15000351)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,115015)
	e1:SetCost(cm.drcost)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not KDlobal then
		KDlobal={}
		KDlobal["Effects"]={}
	end
	KDlobal["Effects"]["c150013"]={}
end
function cm.drcfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable() and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.drcfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.drcfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return aux.IsCodeListed(c,15000351) and c:IsType(TYPE_MONSTER) and (c:IsAbleToGrave() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMatchingGroupCount(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)>0 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		  and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,aux.Stringid(m,0),1152)==1) then
		  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
		   if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			   local te=KDlobal["Effects"]["c"..tc:GetOriginalCode()]
			   if not te then return end
			   local op=te:GetOperation()
			   if op then op(e,tp,eg,ep,ev,re,r,rp) end
		   end
		end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_INSECT) 
end