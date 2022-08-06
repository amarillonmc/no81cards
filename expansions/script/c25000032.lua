local m=25000032
local cm=_G["c"..m]
cm.name="铠武龙 什锦将军"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),aux.NonTuner(Card.IsType,TYPE_PENDULUM),1)
	c:EnableReviveLimit()   
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)  
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000) 
	e2:SetTarget(cm.psptg)
	e2:SetOperation(cm.pspop)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,m+20000)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.ctfil(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ctfil,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cm.ctfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoExtraP(g,tp,REASON_COST)
end
function cm.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_PENDULUM)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end 
end
function cm.spfil(c,e,tp,ft1,ft2)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and ((c:IsLocation(LOCATION_HAND) and ft2>0) or (c:IsLocation(LOCATION_EXTRA) and ft1>0))
end
function cm.psptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local ft1=Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),TYPE_PENDULUM)
	local ft2=Duel.GetMZoneCount(tp,e:GetHandler())
	local g=Duel.GetMatchingGroup(cm.spfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,ft1,ft2)
	if chk==0 then return #g>0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
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
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local code1=Duel.AnnounceCard(tp,table.unpack(afilter))
	Duel.SetTargetParam(code1)
	local code2=0
	local sg=g:Filter(Card.IsCode,nil,code1)
	local codes2={}
	for tc in aux.Next(sg) do
		local g2=Group.CreateGroup()
		if tc:IsLocation(LOCATION_HAND) then g2=Duel.GetMatchingGroup(cm.spfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,ft1,ft2-1):Filter(aux.NOT(Card.IsCode),nil,code1) else g2=Duel.GetMatchingGroup(cm.spfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,ft1-1,ft2):Filter(aux.NOT(Card.IsCode),nil,code1) end
		local ag2=Group.CreateGroup()
		for xc in aux.Next(g2) do
			local code=xc:GetCode()
			if not ag2:IsExists(Card.IsCode,1,nil,code) then
				ag2:AddCard(xc)
				table.insert(codes2,code)
			end
		end
	end
	if #codes2>0 and Duel.SelectYesNo(tp,210) then
		table.sort(codes2)
		local afilter2={codes2[1],OPCODE_ISCODE}
		if #codes2>1 then
			for i=2,#codes2 do
				table.insert(afilter2,codes2[i])
				table.insert(afilter2,OPCODE_ISCODE)
				table.insert(afilter2,OPCODE_OR)
			end
		end
		code2=Duel.AnnounceCard(tp,table.unpack(afilter2))
	end
	e:SetLabel(code2)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function cm.spfil2(c,e,tp,ft1,ft2,code1,code2)
	return cm.spfil(c,e,tp,ft1,ft2) and c:IsCode(code1,code2)
end
function cm.sgck(g,ft1,ft2)
	return ft1>=g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA) and ft2>=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND) and aux.dncheck(g)
end
function cm.fselect(g,ft1,ft2)
	return aux.dncheck(g) and (g:GetClassCount(Card.GetLocation)==2 or (not g:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) and ft2>1) or (not g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and ft1>1))
end
function cm.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then 
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true) 
		local code1,code2=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM),e:GetLabel()
		local ft1=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
		local ft2=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local g=Duel.GetMatchingGroup(cm.spfil2,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,ft1,ft2,code1,code2)
		local ct=g:GetClassCount(Card.GetCode)
		if ct==0 then return end
		if not g:CheckSubGroup(cm.fselect,2,2,ft1,ft2) then ct=1 end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,cm.sgck,false,ct,ct,ft1,ft2)
		if #sg>0 then Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP) end
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(cm.desfil,tp,LOCATION_PZONE,0,1,e:GetHandler()) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectTarget(tp,cm.desfil,tp,LOCATION_PZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
