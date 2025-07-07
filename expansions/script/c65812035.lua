--风起 天衢引
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	aux.AddCodeList(c,65812000)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.setcon)
	e1:SetCost(s.cost)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
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
end

function s.lfilter(c)
	return aux.IsCodeListed(c,65812000)
end
function s.lcheck(g)
	return g:IsExists(s.lfilter,1,nil)
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



function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.tffilter1(c,tp)
	return c:IsCode(65812000) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:IsType(TYPE_FIELD)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.tffilter1),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tffilter1),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
	if tc then 
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.Destroy(fc,REASON_RULE)
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) 
	end
end
function s.tgfilter(c)
	return (aux.IsCodeListed(c,65812000) or c:IsCode(65812000)) and c:IsAbleToGrave()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spfilter(c,e,tp)
	return aux.IsCodeListed(c,65812000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.shfilter(c)
	return c:GetFlagEffect(65812010)>0
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(s.shfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end