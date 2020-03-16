--机空援护 苍天降临
function c40009040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009040,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,40009040)
	e2:SetCondition(c40009040.thcon)
	e2:SetTarget(c40009040.thtg)
	e2:SetOperation(c40009040.thop)
	c:RegisterEffect(e2) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e1:SetOperation(c40009040.activate)
	c:RegisterEffect(e1)   
end
function c40009040.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xf22) and c:IsControler(tp) and bit.band(c:GetSummonLocation(),LOCATION_EXTRA)~=0 and c:IsType(TYPE_LINK)
end
function c40009040.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40009040.cfilter,1,nil,tp)
end
function c40009040.tgfilter(c,e,tp,eg)
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	return eg:IsContains(c) and zone>0 and Duel.IsExistingMatchingCard(c40009040.thfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,zone)
end
function c40009040.thfilter(c,e,tp,zone)
	return c:IsSetCard(0xf22) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c40009040.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009040.tgfilter(chkc,tp,eg) end
	if chk==0 then return Duel.IsExistingTarget(c40009040.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,eg)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c40009040.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,eg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c40009040.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local zone=bit.band(tc:GetLinkedZone(tp),0x1f)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40009040.thfilter),tp,LOCATION_GRAVE,0,1,1,c,e,tp,zone)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c40009040.confilter(c)
	return c:GetMutualLinkedGroupCount()
end
function c40009040.activate(e,tp,eg,ep,ev,re,r,rp)
   local ct=Duel.GetMatchingGroup(c40009040.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	if ct>=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetValue(-1000)
		e1:SetTarget(c40009040.atktg)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(40009040,3))
	end
	if ct>=3 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c40009040.indtg)
		e2:SetValue(1)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(40009040,4))
	end
	if ct>=4 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_ACTIVATE)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetRange(LOCATION_SZONE)
		e4:SetTargetRange(1,1)
		e4:SetValue(c40009040.aclimit)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(40009040,5))
	end
end
function c40009040.atktg(e,c)
	return c:GetMutualLinkedGroupCount()==0
end
function c40009040.indtg(e,c)
	return c:GetMutualLinkedGroupCount()>0
end
function c40009040.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and not tc:IsLinkState() and re:IsActiveType(TYPE_MONSTER)
end



