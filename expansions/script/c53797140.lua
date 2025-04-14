if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	aux.EnablePendulumAttribute(c)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_MOVE)
		ge2:SetOperation(s.resetname)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_SOLVING)
		ge3:SetCondition(s.chcon)
		ge3:SetOperation(s.chop)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		Duel.RegisterEffect(ge4,1)
		local f1=Card.IsCode
		Card.IsCode=function(sc,...)
			if f1(sc,id) and SNNM.Intersection(SNNM.Merged({Duel.GetFlagEffectLabel(sc:GetControler(),id)},{sc:GetFlagEffectLabel(id)}),{...}) then return true else return f1(sc,...) end
		end
		local f2=Card.GetCode
		Card.GetCode=function(sc)
			local codes={f2(sc)}
			if SNNM.IsInTable(id,codes) then
				SNNM.Merge(codes,{Duel.GetFlagEffectLabel(sc:GetControler(),id)})
				SNNM.Merge(codes,{sc:GetFlagEffectLabel(id)})
			end
			return table.unpack(codes)
		end
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetFieldGroup(0,0xff,0xff):IsExists(function(c)return c:GetOriginalCode()==id end,1,nil) then return end
	Duel.RegisterFlagEffect(rp,id+500,RESET_CHAIN,0,1,Duel.GetCurrentChain())
	if not Duel.GetFieldGroup(1-rp,0xff,0):IsExists(function(c)return c:GetOriginalCode()==id end,1,nil) or Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),1-rp,LOCATION_EXTRA,0,1,nil,id) then return end
	local g=Group.__sub(Duel.GetFieldGroup(rp,0xff,0),re:GetHandler())
	if #g<3 then return end
	local roll1=SNNM.roll(1,#g)
	local roll2=roll1
	while roll2==roll1 do roll2=SNNM.roll(1,#g) end
	local sg=Group.CreateGroup()
	local sc=g:GetFirst()
	local ct=1
	while sc do
		if ct==roll1 or ct==roll2 then sg:AddCard(sc) end
		sc=g:GetNext()
		ct=ct+1
	end
	sg:AddCard(re:GetHandler())
	for tc in aux.Next(sg) do
		Duel.Hint(HINT_CODE,rp,tc:GetCode())
		Duel.RegisterFlagEffect(1-rp,id,0,0,0,tc:GetCode())
	end
end
function s.resetname(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsCode,nil,id):Filter(Card.IsPreviousLocation,nil,LOCATION_EXTRA)
	for tc in aux.Next(g) do Duel.ResetFlagEffect(tc:GetPreviousControler(),id) end
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local checks={Duel.GetFlagEffectLabel(tp,id+500)}
	return SNNM.IsInTable(Duel.GetCurrentChain(),checks) and Duel.GetFieldGroup(tp,0xff,0):IsExists(function(c)return c:GetOriginalCode()==id end,1,nil)
end
function s.spfilter(c,e,tp,g,chk)
	return aux.IsCodeListed(c,id) and (not chk or (g:IsExists(Card.IsType,1,nil,c:GetType()&0x4802040) and g:IsExists(aux.NOT(Card.IsCode),1,nil,c:GetCode()))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsAbleToExtra),tp,LOCATION_MZONE,0,nil)
	local b1=Duel.IsExistingMatchingCard(aux.AND(Card.IsAbleToExtra,Card.IsCode),tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,id) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,true)
	local b2=Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_EXTRA,0,1,nil,id)
	if not b1 and not b2 then return end
	local sel=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2},
			{true,aux.Stringid(id,3),3})
	if sel==3 then return end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	if sel==1 then Duel.ChangeChainOperation(ev,s.rep_op_1) else Duel.ChangeChainOperation(ev,s.rep_op_2) end
end
function s.fcheck(g,e,tp)
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,true)
end
function s.exfilter1(c)
	return c:IsFacedown() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function s.exfilter2(c)
	return c:IsType(TYPE_LINK) or c:IsFaceup()
end
function s.gcheck(g,ft1,ft2,ect,ft,types,names)
	return aux.dncheck(g)
		and not g:IsExists(aux.NOT(Card.IsType),1,nil,types)
		and not g:IsExists(Card.IsCode,1,nil,table.unpack(names))
		and #g<=ect and #g<=ft
		and g:FilterCount(s.exfilter1,nil)<=ft1
		and g:FilterCount(s.exfilter2,nil)<=ft2
end
function s.rep_op_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,0))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
	local tc=Duel.SelectMatchingCard(tp,aux.AND(Card.IsAbleToExtra,Card.IsCode),tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,id):GetFirst()
	if Duel.SendtoExtraP(tc,tp,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_EXTRA) then return end
	local codes={tc:GetCode()}
	for i=1,#codes do Duel.Hint(HINT_CODE,1-tp,codes[i]) end
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsAbleToExtra),tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=g:SelectSubGroup(tp,s.fcheck,false,1,#g,e,tp)
	local types,names=0,{}
	for sc in aux.Next(dg) do types=types|(sc:GetType()&0x4802040) end
	for sc in aux.Next(dg) do SNNM.Merge(names,{sc:GetCode()}) end
	if Duel.SendtoDeck(dg,nil,0,REASON_EFFECT)>0 and dg:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) then
		local ft1=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
		local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_LINK)
		local ft=Duel.GetUsableMZoneCount(tp)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
			if ft1>0 then ft1=1 end
			if ft2>0 then ft2=1 end
			ft=1
		end
		local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
		local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=sg:SelectSubGroup(tp,s.gcheck,false,1,#sg,ft1,ft2,ect,ft,types,names)
		local rg1=rg:Filter(s.exfilter1,nil)
		local rg2=rg:Filter(s.exfilter2,nil)
		for rc2 in aux.Next(rg2) do Duel.SpecialSummonStep(rc2,0,tp,tp,false,false,POS_FACEUP) end
		for rc1 in aux.Next(rg1) do Duel.SpecialSummonStep(rc1,0,tp,tp,false,false,POS_FACEUP) end
		Duel.SpecialSummonComplete()
	end
end
function s.rep_op_2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_EXTRA,0,nil,id)
	local sel=aux.SelectFromOptions(tp,
			{g:IsExists(Card.IsAbleToDeck,1,nil),aux.Stringid(id,4),1},
			{true,aux.Stringid(id,5),2})
	if sel==1 then Duel.SendtoDeck(g:Filter(Card.IsAbleToDeck,nil),tp,2,REASON_EFFECT) else
		local codes={}
		for tc in aux.Next(g) do SNNM.Merge(codes,{tc:GetCode()}) end
		table.sort(codes)
		local afilter={codes[1],OPCODE_ISCODE,OPCODE_NOT}
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_NOT)
			table.insert(afilter,OPCODE_AND)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
		g:ForEach(Card.RegisterFlagEffect,id,RESET_EVENT+RESETS_STANDARD,0,1,ac)
		Duel.Hint(HINT_CODE,tp,ac)
	end
end
