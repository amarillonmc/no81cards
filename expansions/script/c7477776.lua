--王家长眠之谷的金殿
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MSET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.spcon1)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCondition(s.spcon2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(s.spcon2)
	c:RegisterEffect(e4)
	--summon proc
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SUMMON_PROC)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e5:SetCondition(s.sumcon)
	e5:SetOperation(s.sumop)
	e5:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e5)
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1,id)
	e7:SetCondition(s.spcon)
	e7:SetTarget(s.sptg2)
	e7:SetOperation(s.spop2)
	c:RegisterEffect(e7)
	
end
function s.exfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsSetCard(0x2e) and c:IsReleasable(REASON_SUMMON)
end
function s.sumcon(e,c,minc)
	if c==nil then return true end
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	return ma>0 and Duel.GetMatchingGroupCount(s.exfilter,c:GetControler(),LOCATION_DECK,0,nil)>=mi and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	local tp=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mg=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_DECK,0,mi,ma,nil)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_SUMMON+REASON_MATERIAL)
end
function s.cfilter1(c,tp)
	return c:IsSetCard(0x2e) and c:IsControler(tp)
end
function s.cfilter2(c,tp)
	return c:IsSetCard(0x2e) and c:IsFacedown() and c:IsControler(tp)
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil,tp)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter2,1,nil,tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(s.cfilter2,nil,tp)
		--Debug.Message("0")
	if #g>0 then
		--Debug.Message("1")
		for tc in aux.Next(g) do
			tc:SetStatus(STATUS_SUMMON_TURN,false)
			tc:SetStatus(STATUS_SPSUMMON_TURN,false)
		end
	end
end
function s.cfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsLocation(LOCATION_GRAVE)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e,tp)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg and eg:FilterCount(s.cfilter,nil,e,tp)>0 end
	local g=eg:Filter(s.cfilter,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetTargetCard(g)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local tg=eg:Filter(aux.NecroValleyFilter(s.spfilter),nil,e,tp)
	local g=nil
	if tg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else
		g=tg
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
