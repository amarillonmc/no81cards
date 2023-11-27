--『星光歌剧』台本-嫉妒Revue
local m=33405006
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
   e2:SetCategory(CATEGORY_SUMMON)
   e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
   e2:SetProperty(EFFECT_FLAG_DELAY)
   e2:SetCode(EVENT_TO_HAND)
   e2:SetRange(LOCATION_GRAVE)
   e2:SetCountLimit(1,m+10000)
   e2:SetCondition(cm.condition)
   e2:SetCost(aux.bfgcost)
   e2:SetTarget(cm.smtg)
   e2:SetOperation(cm.smop)
	c:RegisterEffect(e2)
end

function cm.refilter(c)
	return c:IsReleasableByEffect() and c:IsSetCard(0x6410)   and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.CheckReleaseGroup(tp,cm.refilter,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6410) and c:IsLevel(6)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.CheckReleaseGroup(tp,cm.refilter,1,nil) then return end 
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
   local rg=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_MZONE,0,1,1,nil)
   if  Duel.Release(rg,REASON_EFFECT)~=0 then  
   local tc=rg:GetFirst()
	   if tc:GetLevel()>=6 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,e:GetHandler())
		Duel.Destroy(g,REASON_EFFECT)
	   end
		if tc:GetLevel()>=8 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1))  then 
		 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		 local sg=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	   end
   end
end

function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x6410)  and not c:IsReason(REASON_DRAW)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) 
end
function cm.filter2(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function cm.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.smop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
