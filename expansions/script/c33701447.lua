--翱翔的老鹰引领着梦想
local m=33701447
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e02=Effect.CreateEffect(c)
	e02:SetDescription(aux.Stringid(m,3))
	e02:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e02:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e02:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e02:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e02:SetCountLimit(1)
	e02:SetCondition(cm.spcon)
	e02:SetTarget(cm.sptg)
	e02:SetOperation(cm.spop)
	c:RegisterEffect(e02)
	--Effect 2 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	c:RegisterEffect(e1)
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DRAW_COUNT)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(1,0)
	e12:SetValue(2)
	c:RegisterEffect(e12)
end
--Effect 1
function cm.spcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function cm.sto(c,tp)
	if not c:IsCode(m+1) then return false end
	local b1=c:IsAbleToHand()
	local b2=c:IsType(TYPE_FIELD) 
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
	return b1 or b2
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) 
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.sto),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.sto),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if tc then
			local b1=tc:IsType(TYPE_FIELD) and tc:CheckUniqueOnField(tp) and not tc:IsForbidden()
			if b1 and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,aux.Stringid(m,1))==1) then
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end
--Effect 2
function cm.splimit(e,c,tp,sumtp,sumpos)
	return c:IsLocation(LOCATION_EXTRA)
end