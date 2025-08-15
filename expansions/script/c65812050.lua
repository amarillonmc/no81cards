--风起 沙漫道
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65812000)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--disable 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetTargetRange(0,LOCATION_ONFIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.condition1)
	e3:SetTarget(s.distg)
	c:RegisterEffect(e3)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	if not PNFL_LOCATION_CHECK1 then
		PNFL_LOCATION_CHECK1=true
		local ge7=Effect.CreateEffect(c)
		ge7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge7:SetCode(EVENT_MOVE)
		ge7:SetOperation(s.checkop7)
		Duel.RegisterEffect(ge7,true)
	end
end


function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_ONFIELD)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler() or c:GetPreviousLocation()~=c:GetLocation())
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,id)==0 end
	local ph=Duel.GetCurrentPhase()
	if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then ph=PHASE_BATTLE end
	Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end

function s.filter(c)
	return c:IsCode(65812000) and c:IsFaceup()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.distg(e,c)
	return (c:IsType(TYPE_EFFECT+TYPE_SPELL+TYPE_TRAP) or c:GetOriginalType()&TYPE_EFFECT~=0) and e:GetHandler():GetColumnGroup():IsContains(c)
end


function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.GetFlagEffect(tp,id+1)==0 end
	local ph=Duel.GetCurrentPhase()
	if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then ph=PHASE_BATTLE end
	Duel.RegisterFlagEffect(tp,id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.shfilter(c)
	return c:GetFlagEffect(65812040)>0 
end
function s.shfilter1(c,e,tp)
	return c:IsControler(1-tp) and c:IsControlerCanBeChanged() and not c:IsImmuneToEffect(e)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(s.shfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) and Duel.IsExistingMatchingCard(s.shfilter1,tp,0,LOCATION_MZONE,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,s.shfilter1,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
		local tc=g:GetFirst()
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetValue(tp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e1)
	end
end



function s.checkop7(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local tc=eg:GetFirst()
		while tc do
			if s.locfilter(tc,p) then
				tc:RegisterFlagEffect(65812040,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65812040,1))
			end
			tc=eg:GetNext()
		end
	end
end
function s.locfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_ONFIELD)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler() or c:GetPreviousLocation()~=c:GetLocation()) 
		and c:GetFlagEffect(65812040)==0
end