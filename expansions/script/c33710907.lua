--砂之星的采集
function c33710907.initial_effect(c)
--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--deck check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33710907,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33710907.tg)
	e1:SetOperation(c33710907.op)
	c:RegisterEffect(e1) 
end
function c33710907.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	local code=e:GetHandler():GetCode()
	getmetatable(e:GetHandler()).announce_filter={0x442,OPCODE_ISSETCARD,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c33710907.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c33710907.tgfilter(c,code)
	return c:IsCode(code) and c:IsAbleToGrave()
end
function c33710907.op(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>9
	local op=0
	local flag=0
	local flag1=1
	local num=5
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(33710907,1),aux.Stringid(33710907,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(33710907,1))
	end
	if op==0 then
		num=5
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if g:GetClassCount(Card.GetCode)~=g:GetCount() then flag1=0 end
		if g:GetCount()>0 then
			if g:IsExists(Card.IsCode,1,nil,ac) then 
				local thg=g:Filter(c33710907.thfilter,nil,ac)
				if thg:GetCount()>0 then
					local tc=thg:Select(tp,1,1,nil)
					Duel.SendtoHand(tc,tp,REASON_EFFECT)
					flag=1
				end
			end
		end
	else
		num=10
		Duel.ConfirmDecktop(tp,10)
		local g=Duel.GetDecktopGroup(tp,10)
		if g:GetClassCount(Card.GetCode)~=g:GetCount() then flag1=0 end
		if g:GetCount()>0 then
			if g:IsExists(Card.IsCode,1,nil,ac) then 
				local thg=g:Filter(c33710907.thfilter,nil,ac)
				if thg:GetCount()>0 then
					local tc=thg:Select(tp,1,1,nil)
					Duel.SendtoHand(tc,tp,REASON_EFFECT)
					flag=1
				end
			end
		end
	end
	if num==5 and Duel.IsExistingMatchingCard(c33710907.tgfilter,tp,LOCATION_DECK,0,1,nil,ac) and flag==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tgg=Duel.SelectMatchingCard(tp,c33710907.tgfilter,tp,LOCATION_DECK,0,1,1,nil,ac)
		Duel.SendtoGrave(tgg,REASON_EFFECT)
	end
	if num==10 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,ac) and flag==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33710907,3))
		local tgg=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,ac)
		if tgg:GetCount()>0 then
			Duel.MoveSequence(tgg:GetFirst(),0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
	if flag1==0 then Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT) end
end