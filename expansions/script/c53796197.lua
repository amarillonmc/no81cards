if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,53796195)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(function(e,se,sp,st)return se==e:GetLabelObject() and Duel.GetFlagEffect(e:GetHandlerPlayer(),id)==0 end)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MSET+TIMING_SSET+TIMING_MAIN_END+TIMING_END_PHASE)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	if not s.global_check then
		s.global_check=true
		if c53796195 and not c53796195[0] then
			c53796195[0]={}
			c53796195[1]={}
		end
	end
end
function s.cfilter(c)
	return c:IsCode(53796195) and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function s.spfilter(c,e,tp,tc)
	return c:IsFaceup() and (aux.IsCodeListed(c,53796195) or c:IsType(0x40)) and c:IsCanBeXyzMaterial(tc) and Duel.GetLocationCountFromEx(tp,tp,c,tc)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter2(c,e,tp,tc)
	return s.spfilter(c,e,tp,tc) and not c:IsImmuneToEffect(e)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c):GetFirst()
	if not tc then return end
	local mg=tc:GetOverlayGroup()
	if mg:GetCount()~=0 then Duel.Overlay(c,mg) end
	Duel.Overlay(c,Group.FromCards(tc))
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	c:CompleteProcedure()
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+SNNM.GetCurrentPhase(),0,1)
end
function s.xyzfilter(c,tc)
	return c:IsCanOverlay() and not c:IsRelateToCard(tc)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and s.xyzfilter(chkc,c) end
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFacedown,Card.IsAbleToDeck),tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return Duel.IsExistingTarget(s.xyzfilter,tp,0,LOCATION_ONFIELD,1,nil,c) and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_REMOVED,5,nil) and Duel.GetOverlayGroup(tp,1,0):IsExists(Card.IsAbleToDeck,1,nil) and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tg=Duel.SelectTarget(tp,s.xyzfilter,tp,0,LOCATION_ONFIELD,1,1,nil,c)
	e:GetLabelObject():Merge(tg)
	tg:GetFirst():CreateRelation(c,RESET_EVENT+0x1fc0000)
	if Duel.GetFlagEffect(tp,id+500)==0 then
		Duel.RegisterFlagEffect(tp,id+500,RESET_PHASE+SNNM.GetCurrentPhase(),0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetLabelObject(e)
		e1:SetOperation(s.reset)
		Duel.RegisterEffect(e1,tp)
		c:CreateEffectRelation(e1)
	end
	local ag=Group.CreateGroup()
	local codes={}
	for c in aux.Next(g) do
		local code=c:GetCode()
		if not ag:IsExists(Card.IsCode,1,nil,code) then
			ag:AddCard(c)
			table.insert(codes,code)
		end
	end
	table.sort(codes)
	local ct=#codes
	local nt={codes[1],OPCODE_ISCODE}
	if ct>1 then
		for i=2,ct do
			table.insert(nt,codes[i])
			table.insert(nt,OPCODE_ISCODE)
			table.insert(nt,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(nt))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local g=e:GetLabelObject():GetLabelObject()
	if not c:IsRelateToEffect(e) or Duel.GetFlagEffect(tp,id+500)==0 then
		g:ForEach(Card.ReleaseRelation,c)
		g:Clear()
		e:Reset()
	end
end
function s.tdfilter(c,ac,g)
	return c:IsFacedown() and c:IsCode(ac) and g:IsExists(Card.IsCode,1,nil,c:GetCode()) and c:IsAbleToDeck()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_REMOVED,nil)
	if #g>4 then
		local sg=g:RandomSelect(tp,5)
		Duel.ConfirmCards(tp,sg)
		local ovg=Duel.GetOverlayGroup(tp,1,0):Filter(Card.IsAbleToDeck,nil)
		local tdg=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,0,nil,ac,sg)
		if #tdg>0 and #ovg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg1=tdg:Select(tp,1,1,nil)
			local tg2=ovg:Select(tp,1,1,nil)
			tg1:Merge(tg2)
			local c=e:GetHandler()
			local tc=Duel.GetFirstTarget()
			if Duel.SendtoDeck(tg1,nil,2,REASON_EFFECT)~=0 and tg1:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then Duel.SendtoGrave(og,REASON_RULE) end
				Duel.Overlay(c,Group.FromCards(tc))
			end
		end
		if sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
		if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(1-tp) end
	end
	if c53796195 and not SNNM.IsInTable(ac,c53796195[tp]) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then table.insert(c53796195[tp],ac) end
end
