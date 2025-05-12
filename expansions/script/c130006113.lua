--不义的护卫 迪妮莎
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
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	if not s.global_flag then
		s.global_flag=true
		s[0]={}
		s[1]={}
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
function s.lvfilter(e,c)
	local p=c:GetControler()
	local ccode=c:GetCode()
	local ct=0
	for _,fcode in ipairs(s[p]) do
		if fcode==ccode then
			ct=ct+1
		end
	end
	return ct>0
end
function s.lvval(e,c)
	local p=c:GetControler()
	local ccode=c:GetCode()
	local ct=0
	for _,fcode in ipairs(s[p]) do
		if fcode==ccode then
			ct=ct+1
		end
	end
	return ct*2
end
function s.atkval(e,c)
	local p=c:GetControler()
	local ccode=c:GetCode()
	local ct=0
	for _,fcode in ipairs(s[p]) do
		if fcode==ccode then
			ct=ct+1
		end
	end
	return ct*500
end
function s.otfilter(c)
	return c:IsAbleToHandAsCost()
end
function s.ttcon(e,c,minc)
	if c==nil then return true end
	if c:IsLevelBelow(4) then return end
	local tp=c:GetControler()
	local ct=2 
	local res=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=2
		or Duel.CheckTribute(c,1) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=1
		or Duel.CheckTribute(c,2))
	if c:IsLevelBelow(6) then 
		ct=1 
		res=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=1
		or Duel.CheckTribute(c,1))
	end
	return minc<=ct and res
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Group.CreateGroup()
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local ct=2 
	if c:IsLevelBelow(6) then ct=1 end
	local mg=Duel.GetDecktopGroup(1-tp,ct)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	while mg:GetCount()>0 and (ct>1 and Duel.CheckTribute(c,ct-1) or ct>0 and ft>0)
		and (not Duel.CheckTribute(c,ct) or Duel.SelectYesNo(tp,aux.Stringid(id,0))) do
		local tg=mg:GetFirst()
		g1:AddCard(tg)
		mg:RemoveCard(tg)
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
		Duel.SendtoHand(g1,tp,REASON_SUMMON+REASON_MATERIAL)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)
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
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(130006112,2)) then
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
function s.thfilter(c)
	return c.UnJustice==1 and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		local lv=c:GetLevel()
		local ct=math.floor(lv/2)
	return Duel.IsPlayerCanDiscardDeck(tp,ct) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local ct=math.floor(lv/2)
	if Duel.IsPlayerCanDiscardDeck(tp,ct) then
		Duel.ConfirmDecktop(tp,ct)
		local g=Duel.GetDecktopGroup(tp,ct)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			local sg=g:Filter(s.thfilter,nil)
			if #sg>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
			end
			Duel.ShuffleDeck(tp)
		end
	end
end