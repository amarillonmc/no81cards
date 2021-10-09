--fate·玉藻小姐
function c9950418.initial_effect(c)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950418,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,9950418)
	e1:SetTarget(c9950418.tftg)
	e1:SetOperation(c9950418.tfop)
	c:RegisterEffect(e1)
 --synchro
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9950418,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c9950418.sctg)
	e4:SetOperation(c9950418.scop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950418.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950418.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950418,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950418,1))
end
function c9950418.tffilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xba5) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c9950418.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9950418.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9950418.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c9950418.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c9950418.scfilter1(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return c:IsSetCard(0xba5) and c:IsCanBeSynchroMaterial() and c:IsCanBeSpecialSummoned(e,182,tp,false,false)
		and Duel.IsExistingMatchingCard(c9950418.scfilter2,tp,LOCATION_EXTRA,0,1,nil,tp,mg)
end
function c9950418.scfilter2(c,tp,mg)
	return c:IsSynchroSummonable(nil,mg) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c9950418.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c9950418.scfilter1(chkc,e,tp,c) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9950418.scfilter1,tp,LOCATION_PZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9950418.scfilter1,tp,LOCATION_PZONE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9950418.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,182,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
	if Duel.SpecialSummonComplete()==0 then return end
	if not c:IsRelateToEffect(e) then return end
	local mg=Group.FromCards(c,tc)
	local g=Duel.GetMatchingGroup(c9950418.scfilter2,tp,LOCATION_EXTRA,0,nil,tp,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
