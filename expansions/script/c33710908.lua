--虚拟YouTuber 饼叽v
function c33710908.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1) 
	c:EnableReviveLimit()
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33710908,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33710908.seqtg)
	e2:SetOperation(c33710908.seqop)
	c:RegisterEffect(e2)
end
function c33710908.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and e:GetHandler():IsLocation(LOCATION_MZONE) end
end
function c33710908.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local seq=0
	if c:IsControlerCanBeChanged() then
		seq=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0xe000e0)
	else
		seq=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0xe000e0)
	end
	if seq==nil then return end
	local nseq=math.log(seq,2)
	if nseq<16 then Duel.MoveSequence(c,nseq) end
	if nseq>15 then 
		local dis=bit.lshift(0x1,nseq-16)
		Duel.GetControl(c,1-tp,0,0,dis)
	end
	local seq=c:GetSequence()
	local dg=Group.CreateGroup()
	if seq<5 then dg=Duel.GetMatchingGroup(c33710908.desfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,seq,c:GetControler()) end
	if dg:GetCount()>0 then
		local b1=dg:IsExists(Card.IsAbleToGrave,1,nil) and Duel.IsExistingMatchingCard(c33710908.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,dg:GetSum(Card.GetLevel))
		local b2=dg:IsExists(c33710908.filtt,1,nil,c:GetControler()) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c33710908.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		local op=0
		if not (b1 or b2) then return end
		if not Duel.SelectYesNo(tp,aux.Stringid(33710908,1)) then return end
		if b1 and b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(33710908,2),aux.Stringid(33710908,3)) 
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(33710908,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(33710908,3))+1
		end
		if op==0 then
			if Duel.SendtoGrave(dg,REASON_EFFECT)~=0 then
				local og=Duel.GetOperatedGroup()
				local lv=og:GetSum(Card.GetLevel)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,c33710908.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,dg:GetSum(Card.GetLevel))
				if tg:GetCount()>0 then
					Duel.SpecialSummon(tg,0,tp,tp,true,false,POS_FACEUP)
				end
			end
		else
			if Duel.Release(dg:Filter(c33710908.filtt,nil,c:GetControler()),REASON_EFFECT)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33710908.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
				if tg:GetCount()>0 then
					Duel.SpecialSummon(tg,0,tp,tp,true,false,POS_FACEUP)
				end
			end
		end
	end
end
function c33710908.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x445) and not c:IsCode(33710908) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:GetLevel()<=lv and c:GetLevel()>0
end
function c33710908.spfilter2(c,e,tp)
	return c:IsSetCard(0x445,0x344c) and not c:IsCode(33710908) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c33710908.filtt(c,tp)
	return Duel.IsPlayerCanRelease(tp,c)
end
function c33710908.desfilter2(c,s,tp)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-s)==1 and c:IsControler(tp)
end