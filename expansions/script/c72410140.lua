--电晶星的尖冰晶
function c72410140.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),2,4,c72410140.lcheck)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,72410140)
	e1:SetCondition(c72410140.con)
	e1:SetTarget(c72410140.tg)
	e1:SetOperation(c72410140.operation)
	c:RegisterEffect(e1)
end
function c72410140.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x9729)
end
function c72410140.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetLinkedGroup()~=0
end
function c72410140.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroupCount()
	if chk==0 then return lg~=0 end
end
function c72410140.operation(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	local tg=Group.GetFirst(lg)
	while tg do
	if tg:GetFlagEffect(72410140)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(72410140,0))
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c72410140.thcon)
		e1:SetTarget(c72410140.thtg)
		e1:SetOperation(c72410140.thop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e1) 
		tg:RegisterFlagEffect(72410140,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(72410140,0))
		if not tg:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e3)
		end
	end
	tg=lg:GetNext()
	end
end

function c72410140.thcon(e)
	return (e:GetHandler():GetFlagEffect(72410142)==0 or (e:GetHandler():GetFlagEffect(72410142)==1 and e:GetHandler():GetFlagEffect(72410230)~=0))
end
function c72410140.filter(c,e,tp)
	return c:IsSetCard(0x9729) and c:IsType(TYPE_MONSTER)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72410140.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c72410140.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c72410140.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Card.RegisterFlagEffect(e:GetHandler(),72410142,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1,0) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c72410140.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c72410140.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)

	end
end