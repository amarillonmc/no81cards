--踏日鸣霄 - 马后炮
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--move/swap on summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.mvcon)
	e2:SetTarget(s.mvtg)
	e2:SetOperation(s.mvop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.tgfilter(c)
	return c:IsFaceup() and c:IsCode(54520035,54520030)
end
function s.spfilter(c,e,tp,codes)
	if not (c:IsSetCard(0x9f6) and c:IsLevel(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	for _,code in ipairs(codes) do
		if c:IsCode(code) then return false end
	end
	return true
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc) end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local g=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,nil,0x9f6)
		local codes={}
		for tc in aux.Next(g) do table.insert(codes,tc:GetCode()) end
		return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,codes)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,nil,0x9f6)
	local codes={}
	for tc in aux.Next(g) do table.insert(codes,tc:GetCode()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,codes)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.mvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9f6)
end
function s.seqfilter(c,seq)
	return c:GetSequence()==seq
end
function s.canmove(c,tp)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function s.canswap(c,tp)
	local seq=c:GetSequence()
	if seq>4 then return false end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	return (seq>0 and g:IsExists(s.seqfilter,1,c,seq-1))
		or (seq<4 and g:IsExists(s.seqfilter,1,c,seq+1))
end
function s.existfilter(c,tp)
	return s.mvfilter(c) and (s.canmove(c,tp) or s.canswap(c,tp))
end
function s.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.existfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.existfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.existfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e)) then return end
	local b1=s.canmove(tc,tp)
	local b2=s.canswap(tc,tp)
	if not b1 and not b2 then return end
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		opt=0
	else
		opt=1
	end
	local seq=tc:GetSequence()
	if opt==0 then
		local flag=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
		flag=bit.bxor(flag,0xff)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(tc,nseq)
	else
		local g=Group.CreateGroup()
		if seq>0 then
			local sc=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_MZONE,0,tc,seq-1):GetFirst()
			if sc then g:AddCard(sc) end
		end
		if seq<4 then
			local sc=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_MZONE,0,tc,seq+1):GetFirst()
			if sc then g:AddCard(sc) end
		end
		if g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		if sc then
			Duel.SwapSequence(tc,sc)
		end
	end
end
