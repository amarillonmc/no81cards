--故国龙裔的扩张
function c88480129.initial_effect(c)
	c:SetUniqueOnField(1,0,88480129)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c88480129.spcon)
	e1:SetTarget(c88480129.sptg)
	e1:SetOperation(c88480129.spop)
	c:RegisterEffect(e1)
end
function c88480129.cfilter(c,tp)
	return c:IsType(TYPE_TOKEN) and c:IsControler(tp)
end
function c88480129.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c88480129.cfilter,1,nil,tp)
end
function c88480129.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c88480129.cfilter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#g,0,0)
end
function c88480129.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct<1 then return end
		if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<ct then return end
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,88480150,0x410,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,4,RACE_WYRM,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp) then return end
		for i=1,ct do
			local token=Duel.CreateToken(tp,88480150)
			Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
		end		
	end
end