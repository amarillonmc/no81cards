--Lycoris-LycoReco
function c12852009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa75))
	e2:SetValue(500)
	c:RegisterEffect(e2)	
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,12852009)
	e3:SetTarget(c12852009.eqtg)
	e3:SetOperation(c12852009.eqop)
	c:RegisterEffect(e3)
end
function c12852009.tgfilter(c,e,tp,chk)
	return c:IsSetCard(0xa75)
		and c:IsPreviousLocation(LOCATION_MZONE) 
		and c:IsLocation(LOCATION_MZONE)
		and c:GetPreviousSequence()~=c:GetSequence()
		and c:IsFaceup() and c:IsControler(tp) and c:IsCanBeEffectTarget(e)
		and (chk or Duel.IsExistingMatchingCard(c12852009.cfilter,tp,LOCATION_DECK,0,1,nil,c,tp))
end
function c12852009.cfilter(c,ec,tp)
	return c:IsSetCard(0xa75) and c:IsType(TYPE_EQUIP)
end
function c12852009.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c12852009.tgfilter(chkc,e,tp,true) end
	local g=eg:Filter(c12852009.tgfilter,nil,e,tp,false)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g:GetFirst())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:Select(tp,1,1,nil)
		Duel.SetTargetCard(tc)
	end
end
function c12852009.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,c12852009.cfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp)
		local ec=sg:GetFirst()
		Duel.Equip(tp,ec,tc)
	end
end