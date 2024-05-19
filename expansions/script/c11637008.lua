--香料料理食材
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Gain effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return c:IsSetCard(0x9221)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsSetCard(0x9221)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x9221) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function s.setfilter(c,tp)
	return c:IsSetCard(0xa221) and c:CheckUniqueOnField(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local flag=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if not c:IsOnField() then
		flag=Duel.GetLocationCount(tp,LOCATION_SZONE)>1
	end
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,tp) and flag end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(s.tgop)
	e1:SetLabelObject(tc)
	Duel.RegisterEffect(e1,tp)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	tc:RegisterEffect(e2)
	if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,true,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)~=0 then
		Duel.SendtoGrave(tc,nil,REASON_EFFECT)
	end
	e:Reset()
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsSetCard(0x9221) and tc:IsFaceup() then
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,3))
			e1:SetCategory(CATEGORY_TODECK)
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e1:SetCountLimit(1)
			e1:SetCost(s.cpcost)
			e1:SetTarget(s.cptg)
			e1:SetOperation(s.cpop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			tc:RegisterEffect(e1)
		end
	end
end

function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function s.cpfilter(c,code)
	return c:IsSetCard(0xa221) and c:IsAbleToDeck() and c:CheckActivateEffect(true,true,false) and not c:IsCode(code)
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local code=c:GetCode()
	if chkc then return s.cpfilter(chkc,code) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then 
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(s.cpfilter,tp,LOCATION_GRAVE,0,1,nil,code) end
	e:SetLabel(0)
	local g=Duel.GetMatchingGroup(s.cpfilter,tp,LOCATION_GRAVE,0,nil,code)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectTarget(tp,s.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil,code):GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(tc:GetCode())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	c:RegisterEffect(e1,true)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not aux.NecroValleyFilter()(tc) then return end
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)==0 then return end
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end