--深空之行者 伊塔库亚化身
function c72101216.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,72101216+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c72101216.spcon)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)

	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72101216,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,72101217)
	e2:SetCondition(c72101216.epcon)
	e2:SetTarget(c72101216.eqtg)
	e2:SetOperation(c72101216.eqop)
	c:RegisterEffect(e2)

		--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72101216,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c72101216.retcon)
	e3:SetTarget(c72101216.rettg)
	e3:SetOperation(c72101216.retop)
	c:RegisterEffect(e3)
	
end

--spsummon proc
function c72101216.sppfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not (c:IsType(TYPE_LINK) or c:IsType(TYPE_XYZ))
end
function c72101216.spcon(e,c)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c72101216.sppfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetAttribute)==#g 
		and g:GetClassCount(Card.GetRace)==#g 
		and g:GetClassCount(Card.GetLevel)==#g 
		and #g>1 and Duel.GetMZoneCount(tp)>0
end

--equip
function c72101216.epcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c72101216.cfilter(c,tp)
	return c:IsFaceup()
		and Duel.IsExistingMatchingCard(c72101216.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetOriginalAttribute(),c:GetOriginalRace(),tp)
end
function c72101216.eqfilter(c,att,race,level,tp)
	return c:IsType(TYPE_MONSTER) and c:GetOriginalAttribute()~=att and c:GetOriginalRace()~=race and c:GetOriginalLevel()~=level
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c72101216.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c72101216.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c72101216.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c72101216.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c72101216.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c72101216.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc:GetOriginalAttribute(),tc:GetOriginalRace(),tp)
		local sc=g:GetFirst()
		if not sc then return end
		local res=sc:IsLocation(LOCATION_DECK)
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(c72101216.eqlimit)
		sc:RegisterEffect(e1)
		--atk up
		local e2=Effect.CreateEffect(sc)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
		--send to grave
		local fid=e:GetHandler():GetFieldID()
		sc:RegisterFlagEffect(72101216,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetLabel(fid)
		e3:SetLabelObject(sc)
		e3:SetCondition(c72101216.sgcon)
		e3:SetOperation(c72101216.sgop)
		Duel.RegisterEffect(e3,tp)
		--zisu
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetCode(EFFECT_CANNOT_ACTIVATE)
		e4:SetTargetRange(1,0)
		e4:SetValue(c72101216.sklimit)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function c72101216.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c72101216.sgcon(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	if sc:GetFlagEffectLabel(72101216)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c72101216.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
function c72101216.sklimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0xcea)
end

--to deck
function c72101216.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetReasonPlayer()==1-tp
		and e:GetHandler():IsPreviousControler(tp)
end
function c72101216.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c72101216.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end