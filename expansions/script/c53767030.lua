local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroMixProcedure(c,aux.NonTuner(s.sfilter),nil,nil,aux.Tuner(nil),1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.indcon)
	e1:SetOperation(s.indop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
s.material_type=TYPE_FUSION
function s.sfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsType(TYPE_FUSION)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local l1,l2,l3=0,0,0
	if g:IsExists(function(c)return c:IsLevel(8) and c:IsType(TYPE_FUSION)end,1,nil) then l1=1 end
	local mg=g:Filter(Card.IsNotTuner,nil,c)
	local tc=mg:GetFirst()
	if not tc then
		e:SetLabel(l1,0,0)
		return
	end
	if #mg>1 then
		local tg=g-(g:Filter(Card.IsTuner,nil,c))
		if #tg>0 then
			tc=tg:GetFirst()
		end
	end
	local lv=tc:GetSynchroLevel(c)
	local lv2=lv>>16
	lv=lv&0xffff
	if lv2>0 and not g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),#g,#g,c) then
		lv=lv2
	end
	if tc:IsHasEffect(89818984) and not g:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),#g,#g,c) then
		lv=2
	end
	e:SetLabel(l1,g:FilterCount(Card.IsType,nil,TYPE_TUNER),lv-5)
end
function s.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local l1,l2,l3=e:GetLabelObject():GetLabel()
	if l1>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(s.efilter)
		e1:SetOwnerPlayer(tp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	if l2>0 or l3>0 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,1))
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_CHAINING)
		e2:SetRange(LOCATION_MZONE)
		e2:SetLabel(l2,l3)
		e2:SetCondition(s.con)
		e2:SetTarget(s.tg)
		e2:SetOperation(s.op)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local res
	for i=1,ev do
		local te,p=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if te and te==e then return false end
		if te and p~=tp then res=true end
	end
	return res
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_INSECT) and c:IsFaceup()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1,ct2=e:GetLabel()
	local c=e:GetHandler()
	local b1
	for i=1,ev do
		local te,p=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if te and p~=tp and Duel.IsChainDisablable(i) then b1=true end
	end
	b1=c:GetFlagEffect(id)<ct1
	local b2=c:GetFlagEffect(id+50)<ct2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3),aux.Stringid(id,4)) elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(id,2)) else op=Duel.SelectOption(tp,aux.Stringid(id,3))+1 end
	e:SetLabel(ct1,ct2,op)
	if op~=0 then
		if op==1 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		else
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
		end
		c:RegisterFlagEffect(id+50,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
	else
		e:SetCategory(CATEGORY_DISABLE)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local _,_,op=e:GetLabel()
	if op~=1 then
		local t={}
		local i=1
		for i=1,ev do
			local te,p=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if te and p~=tp and Duel.IsChainDisablable(i) then t[i]=i end
		end
		if #t>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
			local ct=Duel.AnnounceNumber(tp,table.unpack(t))
			Duel.NegateEffect(ct)
		end
	end
	if op~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
end
