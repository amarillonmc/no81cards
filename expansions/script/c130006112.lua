--不义的姬剑豪 莎缇莱萨
local s,id,o=GetID()
s.UnJustice=1
function s.initial_effect(c)
	--summon & set with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ttcon)
	e1:SetOperation(s.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--give you look look monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(130006112,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(s.cost)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	local e20=e2:Clone()
	e20:SetType(EFFECT_TYPE_QUICK_O)
	e20:SetCode(EVENT_FREE_CHAIN)
	e20:SetHintTiming(0,TIMING_END_PHASE)
	e20:SetCondition(s.thcon)
	c:RegisterEffect(e20)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0xff-LOCATION_OVERLAY,0xff-LOCATION_OVERLAY)
	e4:SetCondition(s.discon)
	e4:SetTarget(s.disable)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetCondition(s.discon)
	e5:SetOperation(s.disop)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,aux.FilterBoolFunction(aux.NOT(Effect.IsActiveType),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP))
	if not s.global_flag then
		s.global_flag=true
		s[0]={}
		s[1]={}
		s[id]={}
		s[id+1]={}
		--level
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge1:SetCode(EFFECT_UPDATE_LEVEL)
		ge1:SetTargetRange(0xff,0xff)
		ge1:SetTarget(s.lvfilter)
		ge1:SetValue(s.lvval)
		Duel.RegisterEffect(ge1,0)
		--atk
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetCode(EFFECT_UPDATE_ATTACK)
		ge2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge2:SetTargetRange(0xff,0xff)
		ge2:SetTarget(s.lvfilter)
		ge2:SetValue(s.atkval)
		Duel.RegisterEffect(ge2,0)
		--send to grave
		local ge3=Effect.CreateEffect(c)
		ge3:SetCategory(CATEGORY_TOGRAVE)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_TO_GRAVE)
		ge3:SetOperation(s.tgop)
		Duel.RegisterEffect(ge3,0)
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if Duel.GetTurnCount()~=s[2] then
			s[id]={}
			s[id+1]={}
			s[2]=Duel.GetTurnCount()
		end
		local p=tc:GetControler()
		local cd=id+p
		if tc:IsReason(REASON_DESTROY) then
			table.insert(s[cd],tc:GetOriginalCode())
			Duel.RegisterFlagEffect(p,id+100,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
		end
	end
end
function s.flagfilter(c,tp)
	return c:GetFlagEffect(130006118)~=0
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.flagfilter,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	local sg=g:GetMinGroup(Card.GetLevel)
	local lc=sg:GetFirst()
	local lv=lc:GetLevel()
	return c:IsLevelAbove(lv) and Duel.GetFlagEffect(tp,130006118)~=0
end
function s.discon(e)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():GetLevel()>7 and Duel.GetFlagEffect(1-tp,id+100)>0
end
function s.disable(e,c)
	local ccode=c:GetCode()
	local tp=e:GetHandlerPlayer()
	local p=1-tp
	local cd=id+p
	local ct=0
	for _,fcode in ipairs(s[cd]) do
		if fcode==ccode then
			ct=ct+1
		end
	end
	return ct>0
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local ccode=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	local p=1-tp
	local cd=id+p
	local ct=0
	for _,fcode in ipairs(s[cd]) do
		if fcode==ccode then
			ct=ct+1
		end
	end
	if ct>0 then
		Duel.NegateEffect(ev)
	end
end
function s.val(e,c)
	local p=c:GetControler()
	local ccode=c:GetCode()
	local ct=0
	for _,fcode in ipairs(s[p]) do
		if fcode==ccode then
			ct=ct+1
		end
	end
	return ct
end
function s.lvfilter(e,c)
	return s.val(e,c)>0
end
function s.lvval(e,c)
	return s.val(e,c)*2
end
function s.atkval(e,c)
	return s.val(e,c)*500
end
function s.otfilter(c)
	return c:IsAbleToHand()
end
function s.ttcon(e,c,minc)
	if c==nil then return true end
	if c:IsLevelBelow(4) then return end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.otfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #mg==1 then mg=Duel.GetMatchingGroup(s.otfilter,tp,LOCATION_ONFIELD-LOCATION_MZONE,LOCATION_ONFIELD,nil) end
	local ct=2 
	local res=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2
		or Duel.CheckTribute(c,1) and mg:GetCount()>=1
		or Duel.CheckTribute(c,2))
	if c:IsLevelBelow(6) then 
		ct=1 
		res=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=1
		or Duel.CheckTribute(c,1))
	end
	return minc<=ct and res
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(s.otfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Group.CreateGroup()
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local ct=2 
	if c:IsLevelBelow(6) then ct=1 end
	while mg:GetCount()>0 and (ct>1 and Duel.CheckTribute(c,ct-1) or ct>0 and ft>0)
		and (not Duel.CheckTribute(c,ct) or Duel.SelectYesNo(tp,aux.Stringid(id,0))) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=mg:Select(tp,1,1,nil)
		if tg:GetFirst():IsType(TYPE_MONSTER) and tg:GetFirst():IsLocation(LOCATION_MZONE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tg:GetFirst():RegisterEffect(e1,true)
		end
		g1:Merge(tg)
		mg:Sub(g1)
		ct=ct-1
	end
	if g:GetCount()<ct then
		local sg=Duel.SelectTribute(tp,c,ct-g:GetCount(),ct-g:GetCount())
		g2:Merge(sg)
	end
	g:Merge(g1)
	g:Merge(g2)
	c:SetMaterial(g)
	if #g1>0 then 
		Duel.SendtoHand(g1,nil,REASON_SUMMON+REASON_MATERIAL)
	end
	if #g2>0 then
		Duel.Release(g2,REASON_SUMMON+REASON_MATERIAL)
	end
end
function s.costfilter1(c)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function s.costfilter2(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(130006119,tp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(s.costfilter1,tp,LOCATION_HAND,0,c)
	local sg2=Duel.GetMatchingGroup(s.costfilter1,tp,LOCATION_HAND,0,nil)
	local rg=Duel.GetMatchingGroup(s.costfilter2,tp,LOCATION_GRAVE,0,nil)
	local res1=e:GetHandler():IsDiscardable() and #sg>0 
	local res2=#sg2>0 and #rg>0 
	if chk==0 then return res1 or res2 end
	local off=1
	local ops={}
	local opval={}
	if res1 then
		ops[off]=1103
		opval[off-1]=1
		off=off+1
	end
	if res2 then
		ops[off]=1192
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=rg:Select(tp,1,1,nil)
		Duel.Remove(rc,POS_FACEUP,REASON_COST)
		sg=Duel.GetMatchingGroup(s.costfilter1,tp,LOCATION_HAND,0,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=sg:Select(tp,1,1,nil)
	local tc=g:GetFirst()
	local code=tc:GetCode()
	e:SetLabel(code)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function s.filter(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function s.summop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=sg:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil,1)
			local s2=tc:IsMSetable(true,nil,1)
			if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
				Duel.Summon(tp,tc,true,nil,1)
			else
				Duel.MSet(tp,tc,true,nil,1)
			end
		end
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	if table.insert(s[tp],code)~=0 then
		s.summop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)==0 then return end
	if e:GetHandler():GetLevel()<6 then return end
	local rc=re:GetHandler()
	if e:GetHandler():GetFlagEffect(id)==0 and not rc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then 
		Duel.Destroy(rc,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end