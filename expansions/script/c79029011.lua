--罗德岛·据点-明日の方舟
function c79029011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c79029011.actar)
	e1:SetOperation(c79029011.activate)
	c:RegisterEffect(e1)
	--Activate from deck
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetRange(LOCATION_DECK)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(c79029011.oper)
	e2:SetCountLimit(1,79029011+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e2)   
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c79029011.indestg)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--special summon (GY)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(712559,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,79029011)
	e4:SetCondition(c79029011.spcon)
	e4:SetTarget(c79029011.sptg2)
	e4:SetOperation(c79029011.spop2)
	c:RegisterEffect(e4)
	--place
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(2521011,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetTarget(c79029011.target)
	e5:SetOperation(c79029011.operation)
	c:RegisterEffect(e5) 
	--back to deck
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c79029011.mtcon)
	e6:SetOperation(c79029011.mtop)
	c:RegisterEffect(e6)
	--self destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c79029011.sdcon)
	c:RegisterEffect(e7)
end
function c79029011.spfilter(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029011.xfilter(e,c)
	return c:IsSetCard(0xa90f)
end
function c79029011.indestg(e,c)
	return c:IsSetCard(0x1901) or c:IsSetCard(0xa900)
end
function c79029011.oper(e,tp,eg,ep,ev,re,r,rp)
	c=e:GetHandler()
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
	Duel.SendtoGrave(fc,REASON_RULE)
	Duel.BreakEffect()
	end
	Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(1353770,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029011.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	local e4=Effect.CreateEffect(tc)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetValue(c79029011.efilter)
	tc:RegisterEffect(e4)
end
end
end
function c79029011.filter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsSetCard(0x1901) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029011.actar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029011.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c79029011.activate(e,tp,eg,ep,ev,re,r,rp)
	c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(1353770,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029011.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	local e4=Effect.CreateEffect(tc)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetValue(c79029011.efilter)
	tc:RegisterEffect(e4)
end
end
end
function c79029011.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c79029011.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029011.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c79029011.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local g=Duel.GetMatchingGroup(c79029011.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<1 or ct<1 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		ft=ft-1
		ct=ct-1
		while ft>0 and ct>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11,2)) do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=g:Select(tp,1,1,nil)
			sg:AddCard(sg2:GetFirst())
			g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
			ft=ft-1
			ct=ct-1
		end
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c79029011.xfilter(c)
	return c:IsSetCard(0xa90f) and not c:IsForbidden() and not c:IsCode(79029011) and c:IsType(TYPE_EQUIP)
end
function c79029011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029011.xfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c79029011.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c79029011.xfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
		tc:RegisterEffect(e1)
	end
end
function c79029011.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function c79029011.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()~=0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end
end
function c79029011.sdcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_END and ph<=PHASE_END
	and not Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end