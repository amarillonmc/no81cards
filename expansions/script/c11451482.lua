--魔人★双子 菈·赛泽尔
local cm,m=GetID()
function cm.initial_effect(c)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(cm.ngcon)
	e1:SetTarget(cm.ngtg)
	e1:SetOperation(cm.ngop)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e4)
	--setname
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetRange(0xff)
	e5:SetValue(0x151)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetValue(0x6d)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.filter(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local num0=eg:FilterCount(cm.filter,nil,1)
	local num1=eg:FilterCount(cm.filter,nil,0)
	if Duel.GetCurrentChain()~=0 and num0>0 then
		local ct=Duel.GetFlagEffectLabel(0,11451480)
		if not ct then
			Duel.RegisterFlagEffect(0,11451480,RESET_CHAIN,0,1,num0)
		else
			Duel.SetFlagEffectLabel(0,11451480,ct+num0)
		end
	end
	if Duel.GetCurrentChain()~=0 and num1>0 then
		local ct=Duel.GetFlagEffectLabel(1,11451480)
		if not ct then
			Duel.RegisterFlagEffect(1,11451480,RESET_CHAIN,0,1,num1)
		else
			Duel.SetFlagEffectLabel(1,11451480,ct+num1)
		end
	end
end
function cm.ngcon(e,tp,eg,ep,ev,re,r,rp)
	if ev<2 then return false end
	local a,b=0,0
	for i=1,ev do
		local tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp then
			a=a+1
			if Duel.IsChainNegatable(i) then b=b+1 end
		end
	end
	return ((a>=1 and Duel.IsPlayerAffectedByEffect(tp,11451482)) or a>=2) and b>0
end
function cm.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and e:GetHandler():GetFlagEffect(m)==0 and Duel.GetFlagEffect(tp,m)<2+(Duel.GetFlagEffect(tp,11451926)>0 and 1 or 0) end
	local op=0
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local a,b=0,0
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp then
			a=a+1
			if Duel.IsChainNegatable(i) and te:GetHandler():IsDestructable() and te:GetHandler():IsRelateToEffect(te) then b=1 end
		end
	end
	if Duel.IsPlayerAffectedByEffect(tp,11451482) then
		if a>=2 then
			local op=Duel.SelectOption(tp,aux.Stringid(11451483,2),aux.Stringid(11451483,3))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451483,op+2))
			if op==1 then
				Duel.RegisterFlagEffect(tp,11451482,0,0,1)
				Duel.ResetFlagEffect(tp,11451481)
			end
		else
			op=1
			Duel.RegisterFlagEffect(tp,11451482,0,0,1)
			Duel.ResetFlagEffect(tp,11451481)
		end
	end
	if Duel.GetFlagEffect(tp,m)>2 or (op==1 and Duel.GetFlagEffect(tp,11451482)>1) then
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451926)}
		local g=Group.CreateGroup()
		for _,te in pairs(eset) do g:AddCard(te:GetHandler()) end
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			g=g:Select(tp,1,1,nil)
		end
		Duel.RaiseSingleEvent(g:GetFirst(),EVENT_CUSTOM+11451926,e,0,tp,tp,0)
	end
	if b==1 then Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,0) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,1,0,0)
end
function cm.ngop(e,tp,eg,ep,ev,re,r,rp)
	--if not e:GetHandler():IsRelateToEffect(e) then return end
	local list={}
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and Duel.IsChainNegatable(i) then table.insert(list,i) end
	end
	if #list==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local num=Duel.AnnounceNumber(tp,table.unpack(list))
	local te=Duel.GetChainInfo(num,CHAININFO_TRIGGERING_EFFECT)
	if Duel.NegateActivation(num) and te:GetHandler():IsRelateToEffect(te) and te:GetHandler():IsDestructable() and e:GetHandler():IsRelateToEffect(e) then
		local dg=Group.FromCards(e:GetHandler(),te:GetHandler())
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetFlagEffectLabel(tp,11451480)
	if not num then return false end
	e:SetLabel(num)
	return num>=1 and Duel.GetCurrentChain()==1
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_FAIRY)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local num=e:GetLabel()
	if chk==0 then return (num>=2 or (Duel.IsPlayerAffectedByEffect(tp,11451482) and num>=1)) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(m)==0 and Duel.GetFlagEffect(tp,m)<2+(Duel.GetFlagEffect(tp,11451926)>0 and 1 or 0) end
	local op=0
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) --and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	if Duel.IsPlayerAffectedByEffect(tp,11451482) then
		if num>=2 then
			op=Duel.SelectOption(tp,aux.Stringid(11451483,2),aux.Stringid(11451483,3))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451483,op+2))
			if op==1 then
				Duel.RegisterFlagEffect(tp,11451482,0,0,1)
				Duel.ResetFlagEffect(tp,11451481)
			end
		else
			op=1
			Duel.RegisterFlagEffect(tp,11451482,0,0,1)
			Duel.ResetFlagEffect(tp,11451481)
		end
	end
	if Duel.GetFlagEffect(tp,m)>2 or (op==1 and Duel.GetFlagEffect(tp,11451482)>1) then
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451926)}
		local g=Group.CreateGroup()
		for _,te in pairs(eset) do g:AddCard(te:GetHandler()) end
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			g=g:Select(tp,1,1,nil)
		end
		Duel.RaiseSingleEvent(g:GetFirst(),EVENT_CUSTOM+11451926,e,0,tp,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),2,PLAYER_ALL,LOCATION_ONFIELD+c:GetLocation())
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local rg=Group.FromCards(c,tc)
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
	--[[local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end--]]
end