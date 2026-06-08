local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id-4)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(s.pcost)
	e1:SetTarget(s.ptg)
	e1:SetOperation(s.pop)
	c:RegisterEffect(e1)
	--monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.rmcfilter(c)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function s.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmcfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.rmcfilter,tp,LOCATION_EXTRA,0,nil)
	local ct=math.min(9,#g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,ct,nil)
	local ct2=Duel.Remove(sg,POS_FACEDOWN,REASON_COST+REASON_TEMPORARY)
	e:SetLabel(ct2)
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	local c=e:GetHandler()
	local tc=og:GetFirst()
	while tc do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		tc=og:GetNext()
	end
	og:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(og)
	e1:SetCountLimit(1)
	e1:SetCondition(s.retcon)
	e1:SetOperation(s.retop)
	Duel.RegisterEffect(e1,tp)
end
function s.retfilter(c)
	return c:GetFlagEffect(id)~=0
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(s.retfilter,1,nil)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(s.retfilter,nil)
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	g:DeleteGroup()
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_PLANT,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.thfilter(c)
	return c:GetType()==0x82 and c:IsAbleToHand()
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,0,0,ct,RACE_PLANT,ATTRIBUTE_WATER) then
			local tk=Duel.CreateToken(tp,id+1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e1:SetValue(ct)
			tk:RegisterEffect(e1,true)
			Duel.SpecialSummon(tk,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if #g>0 and g:GetSum(Card.GetLevel)==9 then
		local thg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		if #thg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=thg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.tgfilter(c)
	return c:IsFacedown()
end
function s.has_value(tab,val)
	for index, value in ipairs(tab) do
		if value == val then return true end
	end
	return false
end
function s.subset_sum(t, target)
	local dp={}
	dp[0]=true
	for i=1,#t do
		for j=target,t[i],-1 do
			if dp[j-t[i]] then dp[j]=true end
		end
	end
	return dp[target]==true
end
function s.can_sum(target, declared, current)
	if target==0 then return true end
	local t={}
	for i=1,12 do
		if i~=current and not s.has_value(declared,i) then
			table.insert(t,i)
		end
	end
	return s.subset_sum(t, target)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_REMOVED,0,nil)
	local max_ct=math.min(#cg,78)
	if chk==0 then return max_ct>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=cg:Select(tp,1,max_ct,nil)
	local ct=#sg
	Duel.SendtoGrave(sg,REASON_COST+REASON_RETURN)
	local sum=0
	local declared={}
	while sum<ct do
		local avail={}
		for i=1,12 do
			if not s.has_value(declared,i) and sum+i<=ct then
				if s.can_sum(ct-(sum+i), declared, i) then
					table.insert(avail,i)
				end
			end
		end
		if #avail==0 then break end
		local lv=Duel.AnnounceNumber(tp,table.unpack(avail))
		table.insert(declared,lv)
		sum=sum+lv
	end
	local mask=0
	for _,v in ipairs(declared) do
		mask=mask|(1<<v)
	end
	e:SetLabel(mask)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mask=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,1)
		e1:SetTarget(s.splimit)
		e1:SetLabel(mask)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function s.splimit(e,c,sp,st,spos,tp,se)
	local mask=e:GetLabel()
	local lv=c:GetLevel()
	return lv>0 and (mask&(1<<lv))~=0
end

