--电晶星的奏弦晶
function c72410080.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72410080+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c72410080.spcon)
	e1:SetValue(c72410080.spval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCountLimit(1,72410081)
	e2:SetCondition(c72410080.condition2)
	e2:SetOperation(c72410080.operation2)
	c:RegisterEffect(e2)
end
function c72410080.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9729) and c:IsType(TYPE_LINK)
end
function c72410080.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c72410080.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function c72410080.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c72410080.checkzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c72410080.spval(e,c)
	local tp=c:GetControler()
	local zone=c72410080.checkzone(tp)
	return 0,zone
end

function c72410080.condition2(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and e:GetHandler():GetReasonCard():IsRace(RACE_CYBERSE)
end
function c72410080.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=c:GetReasonCard()
	local e1=Effect.CreateEffect(tg)
	e1:SetDescription(aux.Stringid(72410080,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c72410080.thcon)
	e1:SetTarget(c72410080.thtg)
	e1:SetOperation(c72410080.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tg:RegisterEffect(e1,true)
	tg:RegisterFlagEffect(72410080,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(72410080,0))
	if not tg:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(tg)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e2,true)
	end
end
function c72410080.thcon(e)
	return (e:GetHandler():GetFlagEffect(72410082)==0 or (e:GetHandler():GetFlagEffect(72410082)==1 and e:GetHandler():GetFlagEffect(72410230)~=0))
end
function c72410080.spfilter(c,e,tp,zonesf)
	return c:IsRace(RACE_CYBERSE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zonesf)
end
function c72410080.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zonesf=Card.GetLinkedZone(e:GetOwner(),e:GetOwner():GetControler())
	if chk==0 then return zonesf~=0
		and Duel.IsExistingMatchingCard(c72410080.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,zonesf) end
	Card.RegisterFlagEffect(e:GetHandler(),72410082,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c72410080.thop(e,tp,eg,ep,ev,re,r,rp)
	local zonesf=Card.GetLinkedZone(e:GetOwner(),e:GetOwner():GetControler())
	if zonesf==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72410080.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zonesf)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zonesf)
	end
end