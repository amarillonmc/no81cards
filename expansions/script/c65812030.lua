--风起 星天外
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65812000)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
	if not PNFL_LOCATION_CHECK then
		PNFL_LOCATION_CHECK=true
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_MOVE)
		ge6:SetCondition(s.condition)
		ge6:SetOperation(s.checkop6)
		Duel.RegisterEffect(ge6,true)
	end
	--炸卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end


function s.condition(e,tp,eg,ep,ev,re,r,rp)
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

function s.shfilter(c)
	return c:GetFlagEffect(65812010)>0
end
function s.tffilter(c,e,tp)
	return c:IsFaceupEx() and (c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD) or (c:IsLocation(LOCATION_DECK) and Duel.IsExistingMatchingCard(s.shfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) and (aux.IsCodeListed(c,65812000) or c:IsCode(65812000)) and Duel.GetFlagEffect(tp,id)==0)) and Duel.GetMZoneCount(tp,c)>0
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,c,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,c,tp) then return end
	local tc=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,1,c,tp):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
	if Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end