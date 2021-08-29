--方舟骑士·破碎执法者 苦艾
function c82567798.initial_effect(c)
	 --atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c82567798.atkcon)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	
	e2:SetCountLimit(2,82567798+EFFECT_COUNT_CODE_OATH)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c82567798.spcon)
	c:RegisterEffect(e2)
	--level change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c82567798.target)
	e3:SetOperation(c82567798.operation)
	c:RegisterEffect(e3)
end
function c82567798.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(1-tp)<4000
end
function c82567798.spcon(e,c,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	return Duel.GetCounter(c:GetControler(),LOCATION_ONFIELD,0,0x5825)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		   and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c82567798.lvfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x825) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK)
end
function c82567798.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE)  and chkc:IsFaceup() and chkc:IsSetCard(0x825) and not chkc:IsType(TYPE_XYZ) and not chkc:IsType(TYPE_LINK) end
	if chk==0 then return Duel.IsExistingMatchingCard(c82567798.lvfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler()==re:GetHandler()  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82567798.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local op=0
	if g:GetFirst():IsLevel(1) then op=Duel.SelectOption(tp,aux.Stringid(82567798,1))
	else op=Duel.SelectOption(tp,aux.Stringid(82567798,1),aux.Stringid(82567798,2)) end
	e:SetLabel(op)
end
function c82567798.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end