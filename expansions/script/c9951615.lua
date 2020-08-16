--深海电脑乐土·迷宫之BB
function c9951615.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9951615.spcon)
	e1:SetOperation(c9951615.spop)
	c:RegisterEffect(e1)
 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951615,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9951615)
	e1:SetCost(c9951615.spcost)
	e1:SetTarget(c9951615.sptg)
	e1:SetOperation(c9951615.spop2)
	c:RegisterEffect(e1)
	 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951615.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951615.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951615,0))
end
function c9951615.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9951615.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(0x5ba8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951615.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9951615.filter,tp,LOCATION_DECK,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c9951615.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9951615.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>=2 then
		local fid=e:GetHandler():GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(9951615,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			tc=sg:GetNext()
		end
		sg:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(sg)
		e3:SetCondition(c9951615.descon)
		e3:SetOperation(c9951615.desop)
		Duel.RegisterEffect(e3,tp)
	end
end
function c9951615.desfilter(c,fid)
	return c:GetFlagEffectLabel(9951615)==fid
end
function c9951615.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c9951615.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c9951615.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c9951615.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
function c9951615.spfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c9951615.cfilter(c)
	return not c:GetRace(RACE_CYBERSE) and c:IsSetCard(0xba5)
end
function c9951615.check(tp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	return g:GetCount()~=0 and not g:IsExists(c9951615.cfilter,1,nil)
end
function c9951615.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9951615.spfilter,c:GetControler(),0,LOCATION_MZONE,2,nil)
		and c9951615.check(c:GetControler())
end
function c9951615.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9951615.spfilter,tp,0,LOCATION_MZONE,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

