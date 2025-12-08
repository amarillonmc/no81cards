--黎明之手 信
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	MTC.StrinovaPUS(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)

	MTC.StrinovaChangeZone(c,cm.czop)
end
function cm.fil(c)
	return c:IsSetCard(0x9623) and not c:IsCode(m) and c:IsType(TYPE_MONSTER)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		--atk
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE+LOCATION_SZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetTarget(cm.atktg)
		e1:SetValue(800)
		g:GetFirst():RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		g:GetFirst():RegisterEffect(e2)
	end
end
function cm.atktg(e,c)
	return c:IsSetCard(0x9623)
end
function cm.czfil(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.czop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	if not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end
	local b1=false
	local b2=false
	if Duel.GetFlagEffect(tp,m)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.czfil,tp,LOCATION_MZONE,0,1,nil) then b1=true end
	if Duel.GetFlagEffect(tp,m+10000000)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.czfil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	
	local op=aux.SelectFromOptions(tp,
				{b1,aux.Stringid(m,4)},
				{b2,aux.Stringid(m,5)})
	local pzone1=LOCATION_MZONE
	local pzone2=LOCATION_SZONE
	if op==2 then 
		pzone1=LOCATION_SZONE
		pzone2=LOCATION_MZONE
		Duel.RegisterFlagEffect(tp,m+10000000,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,cm.czfil,tp,pzone1,0,1,1,nil):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,pzone2,POS_FACEUP,true) end
end









