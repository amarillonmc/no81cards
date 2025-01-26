--恋雨谐奏
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12823205)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_GRAVE_ACTION+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,500)
end
function s.thfilter(c)
	return c:IsCode(12823205) and c:IsAbleToHand() and c:IsFaceupEx()
end
function s.cfilter(c,tp)
	return c:IsSetCard(0xca70) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.cfilter2(c)
	return c:IsSetCard(0xaa70) and c:IsFaceup()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local cl=Duel.GetCurrentChain()
	local c=e:GetHandler()
	if Duel.Recover(tp,500,REASON_EFFECT)>0 and Duel.Recover(1-tp,500,REASON_EFFECT)>0 then
		local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if cl==2 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local sg=tg:Select(tp,1,1,nil)
			if sg then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			end
		end
		local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_DECK,0,nil,tp)
		if cl==3 and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil) and #g>0 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local ct=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),2)
			local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg2=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
			local sc=sg2:GetFirst()
			if sc then
				local tc=sg1:GetFirst()
				if not Duel.Equip(tp,tc,sc) then return end
				while tc do
				Duel.Equip(tp,tc,sc,true,true)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(s.eqlimit)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetValue(500)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				tc=sg1:GetNext()
				end
				Duel.EquipComplete()
			end
		end
	end
end
function s.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer()
end