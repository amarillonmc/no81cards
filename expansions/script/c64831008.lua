--终末旅者指挥 士官长
function c64831008.initial_effect(c)
	c:SetUniqueOnField(LOCATION_MZONE,0,64831008)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64831008,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c64831008.damcon)
	e1:SetTarget(c64831008.damtg)
	e1:SetOperation(c64831008.damop)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64831008,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,64831008)
	e2:SetCondition(c64831008.spcon)
	e2:SetTarget(c64831008.sptg)
	e2:SetOperation(c64831008.spop)
	c:RegisterEffect(e2)
	--synchro level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c64831008.slevel)
	c:RegisterEffect(e3)
end
function c64831008.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 4*65536+lv
end
function c64831008.damfil(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c64831008.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c64831008.damfil,1,nil,tp)
end
function c64831008.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=eg:FilterCount(c64831008.damfil,nil,tp)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*400)
end
function c64831008.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c64831008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 
end
function c64831008.filter(tc,c,tp)
	if not tc:IsFaceup() or not tc:IsCanBeSynchroMaterial() or not tc:IsSetCard(0x5410) then return false end
	c:RegisterFlagEffect(64831008,0,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
	tc:RegisterEffect(e1)
	local mg=Group.FromCards(c,tc)
	local res=Duel.IsExistingMatchingCard(c64831008.synfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	c:ResetFlagEffect(64831008)
	e1:Reset()
	return res and Duel.GetLocationCountFromEx(tp,tp,tc)>0 
end
function c64831008.synfilter(c,mg)
	return c:IsSynchroSummonable(nil,mg)
end
function c64831008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,e:GetHandler())
	local check=0
	local mc=mg:GetFirst()
	while mc do
		if c64831008.filter(mc,e:GetHandler(),tp) then check=1 end
		mc=mg:GetNext()
	end
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0 and check==1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c64831008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c64831008.filter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler(),tp):GetFirst()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		c:RegisterFlagEffect(64831008,0,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e1)
		local mg=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c64831008.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		local sc=g:GetFirst()
		if sc then
			Duel.SynchroSummon(tp,sc,nil,mg)
		end
		c:ResetFlagEffect(64831008)
		e1:Reset()
	end
end