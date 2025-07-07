--风起 沙漫道
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65812000)
	--移动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_MOVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
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
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,id+1+EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	if not PNFL_LOCATION_CHECK then
		PNFL_LOCATION_CHECK=true
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_MOVE)
		ge6:SetCondition(s.condition2)
		ge6:SetOperation(s.checkop6)
		Duel.RegisterEffect(ge6,true)
	end
end


function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_ONFIELD)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler() or c:GetPreviousLocation()~=c:GetLocation())
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
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


function s.cfilter1(c,se)
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	local code1,code2=c:GetPreviousCodeOnField()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and (code1==65812000 or code2==65812000)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil,se) and not eg:IsContains(e:GetHandler())
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.shfilter(c)
	return c:GetFlagEffect(65812010)>0 
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


function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.locfilter,1,nil)
end
function s.checkop6(e,tp,eg,ep,ev,re,r,rp)
	eg:IsExists(s.locfilter,1,nil)
	local tg=Duel.GetMatchingGroup(s.locfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(65812010,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65812010,3))
		end
	end
end
function s.locfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_ONFIELD)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler() or c:GetPreviousLocation()~=c:GetLocation()) 
		and c:GetFlagEffect(65812010)==0
end