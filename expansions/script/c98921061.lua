--月舞的巫女
function c98921061.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921061,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98921061)
	e1:SetCost(c98921061.spcost)
	e1:SetTarget(c98921061.sptg)
	e1:SetOperation(c98921061.spop)
	c:RegisterEffect(e1)	
	Duel.AddCustomActivityCounter(98921061,ACTIVITY_SPSUMMON,c98921061.counterfilter)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98931061)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c98921061.eqtg)
	e2:SetOperation(c98921061.eqop)
	c:RegisterEffect(e2)
end
function c98921061.counterfilter(c)
	return c:IsType(TYPE_XYZ)
end
function c98921061.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(98921061,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98921061.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c98921061.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_XYZ)
end
function c98921061.filter(c,e,tp)
	return c:IsRank(3) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_WINDBEAST)
end
function c98921061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921061.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c98921061.xfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98921061.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98921061.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsCanOverlay() then
			Duel.Overlay(tc,Group.FromCards(c))
			local sg=Duel.GetMatchingGroup(c98921061.xfilter,tp,LOCATION_DECK,0,nil)
			if sg:GetCount()>0 then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			   local ssg=sg:Select(tp,1,1,nil)
			   Duel.Overlay(tc,ssg)
		   end
		end
	end
end
function c98921061.xfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevel(3)
end
function c98921061.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98921061.zfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():CheckUniqueOnField(tp)
		and Duel.IsExistingTarget(c98921061.zfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c98921061.zfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function c98921061.zfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0 and c:IsAttribute(ATTRIBUTE_WIND)
end
function c98921061.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsControler(1-tp) or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
	   	c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		--cannot be target
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
	   	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e2:SetValue(aux.indoval)
		c:RegisterEffect(e2)
		--destroy
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetCondition(c98921061.descon)
		e3:SetOperation(c98921061.desop)
	   	e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e3)
		--Xmaterial
	   	local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(98921061,0))
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetRange(LOCATION_SZONE)
		e4:SetCountLimit(1)
		e4:SetOperation(c98921061.matop)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
	end
end
function c98921061.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if tc then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c98921061.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c98921061.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local label=e:GetLabel()
	local tc
	if label==3 then
		tc=e:GetLabelObject():GetLabelObject()
	else
		tc=e:GetLabelObject()
	end
	return tc and tc==te:GetHandler()
end
function c98921061.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c98921061.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end