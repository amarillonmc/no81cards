--漆黑的片翼 - 暗之堕落大天使 - 神崎兰子
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.target2)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.prop3)
	c:RegisterEffect(e3)
end

function s.splimit(e,se,sp,st)
	return st&SUMMON_TYPE_RITUAL~=SUMMON_TYPE_RITUAL or (se and se:GetHandler():IsSetCard(0x619))
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.thfilter(c)
	return c:IsSetCard(0x619) and c:IsAbleToHand() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)

	if tc:IsCode(ac) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		
		Duel.BreakEffect()
		
		if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then
			local result = Duel.SelectYesNo(tp,aux.Stringid(id,4))
			if not result then return end

			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g1=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)>0 then
				Duel.ConfirmCards(1-tp,g1)
				Duel.ShuffleDeck(tp)
				Duel.ShuffleHand(tp)

				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
				if sg:GetCount()>0 then
					Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
				end
			end
		end
	elseif tc:IsAbleToRemove(tp) then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REVEAL)
	end
end


function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetDecktopGroup(tp,5)
		return g:FilterCount(Card.IsAbleToHand,nil)>0 
	end
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac1=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac2=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac3=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac4=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac5=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	e:SetOperation(s.retop(ac1,ac2,ac3,ac4,ac5))
end

function s.hfilter(c,code1,code2,code3,code4,code5)
	return c:IsCode(code1,code2,code3,code4,code5)
end
function s.retop(code1,code2,code3,code4,code5)
	return
		function (e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			Duel.ConfirmDecktop(tp,5)
			local g=Duel.GetDecktopGroup(tp,5)
			local hg=g:Filter(s.hfilter,nil,code1,code2,code3,code4,code5)
			if hg:GetCount()==g:GetCount() then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tc=hg:Select(tp,1,1,nil):GetFirst()
				if tc:IsAbleToHand() then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
					Duel.ShuffleHand(tp)
					
					Duel.BreakEffect()
					
					if not Duel.IsPlayerCanDraw(tp,2) then return end
					local result = Duel.SelectYesNo(tp,aux.Stringid(id,5))
					if not result then return end
					Duel.Draw(tp,2,REASON_EFFECT)
				end
			else
				Duel.ShuffleDeck(tp)
				if e:GetHandler():IsAbleToRemove() then 
					Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
				end
				local removeg = Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
				if removeg:GetCount()>0 then
					local removeg2=Duel.GetFieldGroup(tp,LOCATION_HAND,0):RandomSelect(1-tp,2)
					Duel.Remove(removeg2,POS_FACEDOWN,REASON_EFFECT)
				end
			end
		end
end


function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function s.prop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<=0 then return end
	local off=1
	local ops={}
	local opval={}
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		ops[off]=aux.Stringid(id,6)
		opval[off]=0
		off=off+1
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		ops[off]=aux.Stringid(id,7)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(1-tp,table.unpack(ops))+1
	local sel=opval[op]
	if sel==0 then
		local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if sg:GetCount()>0 then
			Duel.ConfirmCards(tp,sg)

			Duel.BreakEffect()
		
			if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>4 then
				Duel.SortDecktop(tp,1-tp,5)
			end
			Duel.ShuffleHand(1-tp)
		end
	elseif sel==1 then
		local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if sg:GetCount()>0 then
			Duel.ConfirmCards(1-tp,sg)

			Duel.BreakEffect()
		
			if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 then
				local g=Duel.GetDecktopGroup(tp,5)
				if g:GetCount()>0 then
					Duel.ConfirmCards(tp,g)
					Duel.SortDecktop(1-tp,tp,5)
				end
			end
			Duel.ShuffleHand(tp)
		end
	end
end