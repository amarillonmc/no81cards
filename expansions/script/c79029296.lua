--罗德岛·行动-干员寻访
function c79029296.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029296+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c79029296.target)
	e1:SetOperation(c79029296.operation)
	c:RegisterEffect(e1) 
end
function c79029296.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then return dcount~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local ag=Group.CreateGroup()
	local codes={}
	for c in aux.Next(g) do
		local code=c:GetCode()
		if not ag:IsExists(Card.IsCode,1,nil,code) then
			ag:AddCard(c)
			table.insert(codes,code)
		end
	end
	table.sort(codes)
	--c:IsCode(codes[1])
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
			table.insert(afilter,TYPE_MONSTER)
			table.insert(afilter,OPCODE_ISTYPE)
			table.insert(afilter,OPCODE_AND)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	table.insert(getmetatable(e:GetHandler()).announce_filter,0xa900)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_ISSETCARD)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_AND)   
	e:SetLabel(ac)
end
function c79029296.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,ac)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
	Duel.SetLP(tp,Duel.GetLP(tp)-dcount*600)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	Duel.SpecialSummon(spcard,0,tp,tp,true,false,POS_FACEUP)
	Duel.SetLP(tp,Duel.GetLP(tp)-(dcount-seq)*600)
end








