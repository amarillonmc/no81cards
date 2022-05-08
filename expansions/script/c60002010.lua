--时光酒桌 花月
local m=60002010
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60002009") end) then require("script/c60002009") end
function cm.initial_effect(c)
	local e1=timeTable.set(c,m,cm.extraMove)
	local e2=timeTable.spsummon(c,m,cm.extra3,cm.extra5)
	timeTable.globle(c)
end
--e1
function cm.stfil(c)
	return not c:IsCode(60002010) and c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.extraMove(e,tp)
	local c=e:GetHandler()
	local ssg=Group.FromCards(c)
	if Duel.IsExistingMatchingCard(cm.stfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		local tc=Duel.SelectMatchingCard(tp,cm.stfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		Duel.ConfirmCards(1-tp,tc)
		timeTable.getCounter(tc)
		ssg:AddCard(tc)
	end
	Duel.RaiseEvent(ssg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end
--e2
function cm.extra3(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x629))
	e1:SetValue(1000)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.extra5(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	e1:SetCondition(cm.disscon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.disscon(e)
	return Duel.GetCurrentPhase()~=PHASE_MAIN2 
end