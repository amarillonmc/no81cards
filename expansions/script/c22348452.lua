--惧质花园 西巴尔巴
local m=22348452
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Trap activate in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348452,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c22348452.acttg)
	e2:SetTargetRange(LOCATION_SZONE,0)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348452,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetTarget(c22348452.sttg)
	e3:SetOperation(c22348452.stop)
	c:RegisterEffect(e3)
	
end
function c22348452.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (sumpos&POS_FACEUP)>0
end
function c22348452.acttg(e,c)
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x3702)
end
function c22348452.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function c22348452.setfilter(c)
	return c:IsSetCard(0x3702) and c:IsType(TYPE_MONSTER)
end
function c22348452.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(c22348452.setfilter,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(22348452,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:FilterSelect(tp,c22348452.setfilter,1,1,nil)
		local tc1=sg:GetFirst()
		Duel.DisableShuffleCheck()
			 if tc1 then
			  Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetCode(EFFECT_CHANGE_TYPE)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			  e1:SetValue(TYPE_TRAP)
			  tc1:RegisterEffect(e1)
			 end
		Duel.ConfirmCards(1-tp,tc1)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_EFFECT)
	else Duel.SendtoGrave(g,REASON_EFFECT) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c22348452.splimit)
	Duel.RegisterEffect(e1,tp)
end