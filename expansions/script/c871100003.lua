--スクラップ・ゴーレム
function c871100003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(871100003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c871100003.sptg)
	e1:SetOperation(c871100003.spop)
	c:RegisterEffect(e1)
--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(871100003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,871101003)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c871100003.spcost)
	e2:SetTarget(c871100003.sptg)
	e2:SetOperation(c871100003.spop)
	c:RegisterEffect(e2)
end
function c871100003.filter(c,e,tp)
	return c:IsLevelBelow(8) and c:IsSetCard(0xfec1) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp))
end
function c871100003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c871100003.filter(chkc,e,tp) end
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0)
		and Duel.IsExistingTarget(c871100003.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c871100003.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c871100003.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local s2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(871100003,1),aux.Stringid(871100003,2))
	elseif s1 then op=Duel.SelectOption(tp,aux.Stringid(871100003,1))
	elseif s2 then op=Duel.SelectOption(tp,aux.Stringid(871100003,2))+1
	else return end
	if op==0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP) end
end
-----
function c871100003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c871100003.cfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost()
end
function c871100003.spfilter(c,e,tp,lv)
	return c:IsRace(RACE_DRAGON) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c871100003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local cg=Duel.GetMatchingGroup(c871100003.cfilter,tp,LOCATION_GRAVE,0,nil)
		return c:IsAbleToRemoveAsCost()
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c871100003.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,cg:GetCount())
	end
	local cg=Duel.GetMatchingGroup(c871100003.cfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(c871100003.spfilter,tp,LOCATION_DECK,0,nil,e,tp,cg:GetCount())
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=0
		tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(871100003,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	local rg1=Group.CreateGroup()
	if lv>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg2=cg:Select(tp,lv-1,lv-1,c)
		rg1:Merge(rg2)
	end
	rg1:AddCard(c)
	Duel.Remove(rg1,POS_FACEUP,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c871100003.sfilter(c,e,tp,lv)
	return c:IsRace(RACE_DRAGON) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c871100003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c871100003.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(38572779,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c871100003.descon)
		e1:SetOperation(c871100003.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c871100003.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(871100003)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c871100003.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
