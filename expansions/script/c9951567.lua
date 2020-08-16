--艾斯杀手
function c9951567.initial_effect(c)
	 --equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c9951567.eqtg)
	e1:SetOperation(c9951567.eqop)
	c:RegisterEffect(e1)
	local e2=Effect.Clone(e1)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951567.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951567.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951567,0))
end
function c9951567.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9bd1) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c9951567.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9951567.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c9951567.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c9951567.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,tp)
		local tc=g:GetFirst()
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if not Duel.Equip(tp,tc,c) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(c)
		e1:SetValue(c9951567.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
		--atk up
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c9951567.eqlimit(e,c)
	return c==e:GetLabelObject()
end