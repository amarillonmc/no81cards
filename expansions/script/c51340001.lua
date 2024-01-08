--窃时姬 vif
local m=51340001
local cm=_G["c"..m]
xpcall(function() dofile("expansions/script/c51300039.lua") end,function() dofile("script/c51300039.lua") end)
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--SpecialSummon
	local e1=qie.qeffect(c,m)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)	
	--check 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,m+1)
	e2:SetCondition(cm.ckcon)
	e2:SetTarget(cm.cktg)
	e2:SetOperation(cm.ckop)
	c:RegisterEffect(e2)
end
--SpecialSummon
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xa06) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and (c:IsLocation(LOCATION_REMOVED) or Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--check
function cm.ckcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.cktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function cm.ckop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local opt=Duel.AnnounceType(tp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.DisableShuffleCheck()
	Duel.ConfirmDecktop(1-tp,1)
	Duel.DisableShuffleCheck()
	Duel.ConfirmDecktop(tp,1)
	local tc1=Duel.GetDecktopGroup(tp,1):GetFirst()
	local tc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	local count=0
	if (opt==0 and tc1:IsType(TYPE_MONSTER)) or (opt==1 and tc1:IsType(TYPE_SPELL)) or (opt==2 and tc1:IsType(TYPE_TRAP)) then
		count=count+1
	end
	if (opt==0 and tc2:IsType(TYPE_MONSTER)) or (opt==1 and tc2:IsType(TYPE_SPELL)) or (opt==2 and tc2:IsType(TYPE_TRAP)) then
		count=count+1
	end
	Duel.Remove(Group.__add(tc1,tc2),POS_FACEDOWN,REASON_EFFECT)
	local sg=Duel.GetMatchingGroup(cm.setfilter,tp,0,LOCATION_ONFIELD+LOCATION_REMOVED,nil)
	if count==1 and #sg>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local stc=sg:Select(tp,1,1,nil):GetFirst()
		stc:RegisterFlagEffect(m+1,RESET_PHASE+PHASE_END,0,1)
		Duel.MoveToField(stc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		--gain effect 
		local c=e:GetHandler()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetRange(LOCATION_MZONE)
		e3:SetOperation(cm.effop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		c:RegisterEffect(e3)
	end
	local dg=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if count==2 and #dg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dtc=dg:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoDeck(dtc,nil,0,REASON_EFFECT)
	end
end
function cm.setfilter(c)
	return not c:IsForbidden() and not c:IsType(TYPE_TOKEN)
end
function cm.tdfilter(c)
	return c:IsAbleToDeck()
end
--gain EFFECT 
function cm.effilter(c)
	return c:GetFlagEffect(m+1)>0
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.effilter,tp,LOCATION_SZONE,0,nil)
	if g:GetCount()<1 then return end
	local ec=g:GetFirst()
	ec:ResetFlagEffect(m+1)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.HintSelection(g)
		--Negate
		local c=e:GetHandler()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e3:SetProperty(EFFECT_FLAG_DELAY)
		e3:SetCode(EVENT_CHAINING)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCondition(cm.xyzcon)
		e3:SetTarget(cm.xyztg)
		e3:SetOperation(cm.xyzop)
		ec:RegisterEffect(e3)
	end
	e:Reset()
end
function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_XYZ)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	local mg=Group.__add(c,c)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 then
		mg:Merge(Duel.GetDecktopGroup(1-tp,1))
	end
	Duel.Overlay(rc,mg)
end









