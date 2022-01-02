--天空尊者 莫提乌斯
function c94380880.initial_effect(c)
	aux.AddCodeList(c,56433456)
	aux.EnableChangeCode(c,56433456,LOCATION_MZONE)
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c94380880.XyzCondition)
	e1:SetTarget(c94380880.XyzTarget)
	e1:SetOperation(c94380880.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCode(EVENT_ADJUST)
	e0:SetCondition(c94380880.xyzcon)
	e0:SetOperation(c94380880.xyzop)
	c:RegisterEffect(e0)
	local e01=e0:Clone()
	e01:SetCondition(c94380880.xyzcon2)
	e01:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e01)
	local e02=e01:Clone()
	e02:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e02)
	local e03=e01:Clone()
	e03:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e03)
	
	--activate from hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_COUNTER))
	e4:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e4)
	--effect gain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c94380880.effop)
	c:RegisterEffect(e5)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(94380880)
	ex:SetRange(LOCATION_MZONE)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ex)
	--effect gain
--  local e5=Effect.CreateEffect(c)
--  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
--  e5:SetCode(EVENT_ADJUST)
--  e5:SetRange(LOCATION_MZONE)
--  e5:SetLabel({})
--  e5:SetOperation(c94380880.effop)
--  c:RegisterEffect(e5)
	--search
--  local e6=Effect.CreateEffect(c)
--  e6:SetDescription(aux.Stringid(94380880,1))
--  e6:SetCategory(CATEGORY_SEARCH)
--  e6:SetType(EFFECT_TYPE_QUICK_O)
--  e6:SetRange(LOCATION_MZONE)
--  e6:SetCode(EVENT_FREE_CHAIN)
--  e6:SetCountLimit(1)
--  e6:SetCost(c94380880.cost)
--  e6:SetTarget(c94380880.target)
--  e6:SetOperation(c94380880.activate)
--  c:RegisterEffect(e6)
end
	--workaround
	--if not aux.angle_counter_check then
	--	aux.angle_counter_check=true
	--	c94380880.table={}
	--	_RegisterEffect=Card.RegisterEffect
	--	function Card.RegisterEffect(c,e)
	--		return _RegisterEffect(c,e)
	--	end
	--end
--Xyz Summon(normal)
function c94380880.Xyzfilter2(c,sc)
	return c:IsRace(RACE_FAIRY) and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,4)
end
function c94380880.Xyzfilter(c,sc)
	return c:IsRace(RACE_FAIRY) and c:IsFaceup() and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,4)
end
function c94380880.XyzCondition(e,c,og)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if og then return Duel.CheckXyzMaterial(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),4,2,2,og)
	else
		local mg=Duel.GetMatchingGroup(c94380880.Xyzfilter,tp,LOCATION_MZONE,0,nil,c)
		local og=Duel.GetMatchingGroup(c94380880.Xyzfilter2,tp,LOCATION_HAND,0,nil,c)
		og:Merge(mg)
		return Duel.CheckXyzMaterial(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),4,2,2,og)
	end
	
end
function c94380880.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local g=Group.CreateGroup()
	if og then 
		g=Duel.SelectXyzMaterial(tp,c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),4,2,2,og)
	else
		local mg=Duel.GetMatchingGroup(c94380880.Xyzfilter,tp,LOCATION_MZONE,0,nil,c)
		local og=Duel.GetMatchingGroup(c94380880.Xyzfilter2,tp,LOCATION_HAND,0,nil,c)
		og:Merge(mg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=og:Select(tp,2,2,nil)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c94380880.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
			Duel.SendtoGrave(sg,REASON_RULE)
			c:SetMaterial(og)
			Duel.Overlay(c,og)
	else
		e:SetLabel(0)
		local mg=e:GetLabelObject()
		if mg:Filter(Card.IsLocation,nil,LOCATION_HAND):GetCount()~=0 then 
			e:SetLabel(1)
		end
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		if e:GetLabel()==1 then Duel.ShuffleHand(tp) end
		mg:DeleteGroup()
	end
end
function c94380880.filter(c)
	Duel.RegisterFlagEffect(tp,94380880,RESET_CHAIN+RESET_EVENT+EVENT_CHAINING+EVENT_CHAIN_ACTIVATING+EVENT_CHAIN_NEGATED+EVENT_CHAIN_SOLVED,0,1)
	return c:GetType()==(TYPE_TRAP+TYPE_COUNTER) and c:IsFacedown()
		and c:CheckActivateEffect(false,false,false)~=nil
end
function c94380880.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,94380880)==0 and Duel.IsExistingMatchingCard(c94380880.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and e:GetHandler():IsXyzSummonable(nil,2,2) then
		Duel.RegisterFlagEffect(tp,94380880,RESET_CHAIN+RESET_EVENT+EVENT_CHAINING+EVENT_CHAIN_ACTIVATING+EVENT_CHAIN_NEGATED+EVENT_CHAIN_SOLVED,0,1)
		local cg=Duel.GetMatchingGroup(c94380880.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		cg:KeepAlive()
		e:SetLabelObject(cg)
		return Duel.IsExistingMatchingCard(c94380880.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and e:GetHandler():IsXyzSummonable(nil,2,2)
	end
	return false
end

function c94380880.trapcheck(c,e)
	if not (c:GetType()==(TYPE_TRAP+TYPE_COUNTER) and c:IsFacedown()) then return false end
	if c:GetType()==(TYPE_TRAP+TYPE_COUNTER) and e:GetCode()==EVENT_SUMMON then
		return c:GetFlagEffect(94380882)>0
	elseif c:GetType()==(TYPE_TRAP+TYPE_COUNTER) and e:GetCode()==EVENT_SPSUMMON then
		return c:GetFlagEffect(94380884)>0
	elseif c:GetType()==(TYPE_TRAP+TYPE_COUNTER) and e:GetCode()==EVENT_FLIP_SUMMON then
		return c:GetFlagEffect(94380886)>0
	else return false
	end
end
function c94380880.filter2(c,e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,94380880+1000,RESET_EVENT+EVENT_FLIP_SUMMON_NEGATED+EVENT_FLIP_SUMMON_SUCCESS+EVENT_SUMMON_NEGATED+EVENT_SUMMON_SUCCESS+EVENT_SPSUMMON_NEGATED+EVENT_SPSUMMON_SUCCESS+RESET_CHAIN,0,1)
	if not (c:GetType()==(TYPE_TRAP+TYPE_COUNTER) and c:IsFacedown()) then return false end
	local ceg={c:GetActivateEffect()}
	local ce=Effect.CreateEffect(c)
	for i,ie in pairs(ceg) do
		if ie:GetCode()==e:GetCode() then ce=ie end
	end 
	local condition=ce:GetCondition()
	local cost=ce:GetCost()
	local target=ce:GetTarget()
	return bit.band(ce:GetCode(),e:GetCode())~=0 and not c:IsForbidden()
				and (not condition or condition(ce,tp,eg,ep,ev,re,r,rp))
				and (not cost or cost(ce,tp,eg,ep,ev,re,r,rp,0))
				and (not target or target(ce,tp,eg,ep,ev,re,r,rp,0))
end

function c94380880.xyzcon2(e,tp,eg,ep,ev,re,r,rp)
	if  Duel.GetCurrentChain()==0 and Duel.GetFlagEffect(tp,94380880+1000)==0 and Duel.IsExistingMatchingCard(c94380880.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():IsXyzSummonable(nil,2,2)  then
		Duel.RegisterFlagEffect(tp,94380880+1000,RESET_EVENT+EVENT_FLIP_SUMMON_NEGATED+EVENT_FLIP_SUMMON_SUCCESS+EVENT_SUMMON_NEGATED+EVENT_SUMMON_SUCCESS+EVENT_SPSUMMON_NEGATED+EVENT_SPSUMMON_SUCCESS+RESET_CHAIN,0,1)
		local cg=Duel.GetMatchingGroup(c94380880.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,e,tp,eg,ep,ev,re,r,rp)
		cg:KeepAlive()
		e:SetLabelObject(cg)
		return Duel.IsExistingMatchingCard(c94380880.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():IsXyzSummonable(nil,2,2)
	end
	return false
end
function c94380880.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsXyzSummonable(nil,2,2) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(94380880,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94380880,3))
		local cg=e:GetLabelObject():Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,cg)
		c94380880.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c)
		c94380880.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	end
end
function c94380880.efffilter(c)
	return c:IsLevel(4) and c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
c94380880.check={}
function c94380880.copyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER) and not c:IsHasEffect(94380880) and c:IsLevel(4) and c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c94380880.gfilter(c,g)
	if not g then return true end
	return c94380880.efffilter(c) and not g:IsContains(c)
end
function c94380880.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c94380880.check[c]=c94380880.check[c] or {}
	local exg=Group.CreateGroup()
	for tc,cid in pairs(c94380880.check[c]) do
		if tc and cid then exg:AddCard(tc) end
	end
	local g=c:GetOverlayGroup()
	local dg=exg:Filter(c94380880.gfilter,nil,g)
	for tc in aux.Next(dg) do
		c:ResetEffect(c94380880.check[c][tc],RESET_COPY)
		exg:RemoveCard(tc)
		c94380880.check[c][tc]=nil
	end
	local cg=g:Filter(c94380880.gfilter,nil,exg)
	for tc in aux.Next(cg) do
		local flag=true
		if #c94380880.check[c]==0 then
			c94380880.check[c][tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
		end
		for ac,cid in pairs(c94380880.check[c]) do
			if tc==ac then
				flag=false
			end
		end
		if flag==true then
			c94380880.check[c][tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
		end
	end
end

--c94380880.table={}
--function c94380880.effop(e,tp,eg,ep,ev,re,r,rp)
--  local c=e:GetHandler()
--  local array={e:GetLabel()}
--  local g=c:GetOverlayGroup():Filter(c94380880.efffilter,nil)
--  local cg=Group.CreateGroup()
--  Debug.Message("1")
--  for key,value in pairs(array) do
--	if next(array)~=nil and key and value then
--		cg:AddCard(key)
--		if not g:IsContains(key) then 
--			c:ResetEffect(value,RESET_COPY) 
--			array[key]=nil
--		end
--	end
--  end
--  g:Sub(cg)
--  for tc in aux.Next(g) do
--	local code=tc:GetOriginalCode()
--	if c:IsFaceup() then
--		array[tc]=c:CopyEffect(code,RESETS_STANDARD,1)
--	end 
--  end
--  e:SetLabel(table.unpack(array))
--end
--function c94380880.cost(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
--  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
--end
--function c94380880.actfilter(c,tp)
--  return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true) and c:IsCode(56433456)
--end
--function c94380880.target(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return Duel.IsExistingMatchingCard(c94380880.actfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
--end
--function c94380880.activate(e,tp,eg,ep,ev,re,r,rp)
--  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94380880,4))
--  local tc=Duel.SelectMatchingCard(tp,c94380880.actfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
--  if tc then
--	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
--	if fc then
--		Duel.SendtoGrave(fc,REASON_RULE)
--		Duel.BreakEffect()
--	end
--	Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
--	local te=tc:GetActivateEffect()
--	te:UseCountLimit(tp,1,true)
--	local tep=tc:GetControler()
--	local cost=te:GetCost()
--	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
--	Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
--  end
--end

