--拉比艾尔的使徒
function c98920745.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920745,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c98920745.target)
	e1:SetOperation(c98920745.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
	--spell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920745,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c98920745.target1)
	e3:SetOperation(c98920745.operation1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)	
	--spell
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920745,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetTarget(c98920745.target2)
	e5:SetOperation(c98920745.operation2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--draw
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(98920745,0))
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_RELEASE)
	e7:SetCountLimit(1,98920745+EFFECT_COUNT_CODE_CHAIN)
	e7:SetCondition(c98920745.drcon1)
	e7:SetTarget(c98920745.drtg)
	e7:SetOperation(c98920745.drop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetCondition(c98920745.drcon2)
	c:RegisterEffect(e8)
end
function c98920745.filter(c,e,tp)
	return c:IsCode(98920745) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920745.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920745.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c98920745.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920745.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
		local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98920745.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c98920745.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c98920745.filter1(c,e,tp)
	return c:IsCode(98920745) and not c:IsForbidden()
end
function c98920745.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c98920745.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
end
function c98920745.operation1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)-1
	if ft<=0 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c98920745.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		g:AddCard(e:GetHandler())
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
function c98920745.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c98920745.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
end
function c98920745.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)-1
	if ft<=0 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c98920745.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		g:AddCard(e:GetHandler())
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
function c98920745.drcon1(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return e:GetHandler():IsReason(REASON_SPSUMMON)
end
function c98920745.drcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_SPSUMMON) and c:IsPreviousLocation(LOCATION_SZONE)
end
function c98920745.tdfilter(c)
	return c:IsCode(98920745) and c:IsAbleToDeck()
end
function c98920745.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c98920745.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98920745.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(c98920745.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 and g:GetCount()>0 then
	   Duel.BreakEffect()
	   Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end