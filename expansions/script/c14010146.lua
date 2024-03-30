--恶鬼切目
local m=14010146
local cm=_G["c"..m]
function cm.initial_effect(c)
	--handeffect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0x3c0)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return not Duel.CheckEvent(EVENT_CHAINING)
	end)
	e1:SetCost(cm.ForbiddenCost(cm.DescriptionCost()))
	e1:SetTarget(cm.CopyTarget)
	e1:SetOperation(cm.CopyOperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(aux.TRUE)
	c:RegisterEffect(e2)
	--graveeffect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0x3c0)
	e3:SetCountLimit(1,m+1000)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0x3c0)
	e4:SetCountLimit(1,m+1000)
	e4:SetCost(cm.spcost)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.ForbiddenCost(costf)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		e:SetLabel(1)
		if not costf then return true end
		return costf(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function cm.DescriptionCost(costf)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return (not costf or costf(e,tp,eg,ep,ev,re,r,rp,0)) end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		if costf then costf(e,tp,eg,ep,ev,re,r,rp,1) end		
	end
end
--[[function cm.IgnoreActionCheck(f,...)
	Duel.DisableActionCheck(true)
	local cr=coroutine.create(f)
	local ret={}
	while coroutine.status(cr)~="dead" do
		local sret={coroutine.resume(cr,...)}
		for i=2,#sret do
			table.insert(ret,sret[i])
		end
	end
	Duel.DisableActionCheck(false)
	return table.unpack(ret)
end--]]
function cm.ProtectedRun(f,...)
	if not f then return true end
	local params={...}
	local ret={}
	local res_test=pcall(function()
		ret={f(table.unpack(params))}
	end)
	if not res_test then return false end
	return table.unpack(ret)
end
function cm.GetHandEffect(c,tc)
	cm.dis_cache=cm.dis_cache or {}
	cm.urara_cache=cm.urara_cache or {}
	local code=c:GetOriginalCode()
	if cm.urara_cache[code] then return cm.urara_cache[code] end
	local eset={}
	local temp=Card.RegisterEffect
	local _SetRange=Effect.SetRange
	function Effect.SetRange(e,r,...)
		table_range=table_range or {}
		table_range[e]=r
		return _SetRange(e,r,...)
	end
	if not Effect.GetRange then
		function Effect.GetRange(e)
			if table_range and table_range[e] then
				return table_range[e]
			end
			return 0
		end
	end
	Card.RegisterEffect=function(tc,e,f)
		if (e:GetRange()&LOCATION_HAND)>0 and e:IsHasType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O) then
			local found=false
			local cost=e:GetCost()
			local temp_=Effect.GetHandler
			local IsDiscardable_=Card.IsDiscardable
			Effect.GetHandler=function(e2)
				if e==e2 then return tc end
				return temp_(e2)
			end
			Card.IsDiscardable=function(tc2,...)
				if tc2==tc then found=true end
				return IsDiscardable_(tc2,...)
			end
			pcall(function()
				cost(e,tp,eg,ep,ev,re,r,rp,0)
			end)
			Card.IsDiscardable=IsDiscardable_
			Effect.GetHandler=temp_
			if found then table.insert(eset,e:Clone()) end
		end
		return true --temp(tc,e,f)
	end
	--local tempc=cm.IgnoreActionCheck(Duel.CreateToken,c:GetControler(),code)
	if not _G["c"..code] then return false end
	local ini=_G["c"..code].initial_effect
	local tempc=tc
	if ini then c.initial_effect(tc) end
	Card.RegisterEffect=temp
	local found=false
	for _,te in ipairs(eset) do
		local cost=te:GetCost()
		if cost then
			local mt=getmetatable(tempc)
			local temp_=Effect.GetHandler
			Effect.GetHandler=function(e)
				if e==te then return tempc end
				return temp_(e)
			end
			mt.IsDiscardable=function(tc,...)
				if tempc==tc then found=true end
				return Card.IsDiscardable(tc,...)
			end
			pcall(function()
				cost(te,tp,eg,ep,ev,re,r,rp,0)
			end)
			mt.IsDiscardable=nil
			Effect.GetHandler=temp_
		end
	end
	cm.urara_cache[code]=eset
	cm.dis_cache[code]=(found and 1 or 0)
	if found and found==false then return false end
	return eset
end
function cm.CheckHandEffect(c,sec,e,tp,eg,ep,ev,re,r,rp)
	local eset=cm.GetHandEffect(c,e:GetHandler())
	if eset==false then return false end
	if #eset==0 then return false end
	local ee,teg,tep,tev,tre,tr,trp
	for _,te in ipairs(eset) do
		local tres=false
		local types=te:GetType()
		local code=te:GetCode()
		if code and code~=EVENT_CHAINING and code~=EVENT_FREE_CHAIN then
			tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(code,true)
		elseif sec or code==EVENT_FREE_CHAIN then
			tres=true
			teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
		end
		if types==EFFECT_TYPE_IGNITION then
			tres=true
			teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
		end
		if tres then
			local con=te:GetCondition()
			local tg=te:GetTarget()
			if cm.ProtectedRun(con,e,tp,teg,tep,tev,tre,tr,trp) and cm.ProtectedRun(tg,e,tp,teg,tep,tev,tre,tr,trp,0) then
				ee=te
				break
			end
		end
	end
	if ee then
		return true,ee,teg,tep,tev,tre,tr,trp
	else
		return false
	end
end
function cm.CopyFilter(c,sec,e,tp,eg,ep,ev,re,r,rp)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(m)
		and c:IsAbleToGraveAsCost() and cm.CheckHandEffect(c,sec,e,tp,eg,ep,ev,re,r,rp)
end
function cm.CopyTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and cm.ProtectedRun(tg,e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	local c=e:GetHandler()
	local og=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local sec=(e:GetCode()==EVENT_CHAINING)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return og:IsExists(cm.CopyFilter,1,nil,sec,e,tp,eg,ep,ev,re,r,rp) and c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=og:FilterSelect(tp,cm.CopyFilter,1,1,nil,sec,e,tp,eg,ep,ev,re,r,rp)
	local _,te,ceg,cep,cev,cre,cr,crp=cm.CheckHandEffect(g:GetFirst(),sec,e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	local tg=te:GetTarget()
	cm.ProtectedRun(tg,e,tp,ceg,cep,cev,cre,cr,crp,1)
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	local ex=Effect.GlobalEffect()
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_CHAIN_END)
	ex:SetLabelObject(e)
	ex:SetOperation(function(e)
		e:GetLabelObject():SetLabel(0)
		ex:Reset()
	end)
	Duel.RegisterEffect(ex,tp)
end
function cm.CopyOperation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if te:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:GetHandler():ReleaseEffectRelation(e)
	end
	cm.ProtectedRun(op,e,tp,eg,ep,ev,re,r,rp)
end
function cm.thfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsAttack(0) and c:IsDefense(1800) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.filter(c)
	return c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsAttack(0) and c:IsDefense(1800) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local b1=Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
			local b2=Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
			local b3=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil)
			if b1 or b2 or b3 then
				if not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end
			else
				return
			end
			local off=1
			local ops,opval={},{}
			if b1 then
				ops[off]=aux.Stringid(m,4)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(m,5)
				opval[off-1]=2
				off=off+1
			end
			if b3 then
				ops[off]=aux.Stringid(m,6)
				opval[off-1]=3
				off=off+1
			end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			local sel=opval[op]
			if sel==1 then
				local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
				if g:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=g:Select(tp,1,1,nil)
					Duel.SynchroSummon(tp,sg:GetFirst(),nil)
				end
			elseif sel==2 then
				local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil)
				if g:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=g:Select(tp,1,1,nil)
					Duel.XyzSummon(tp,tg:GetFirst(),nil)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
				end
			end
		end
	end
end