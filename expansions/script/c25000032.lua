--铠武龙 什锦将军
function c25000032.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),aux.NonTuner(Card.IsType,TYPE_PENDULUM),1)
	c:EnableReviveLimit()   
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25000032,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,25000032)  
	e1:SetCost(c25000032.thcost)
	e1:SetTarget(c25000032.thtg)
	e1:SetOperation(c25000032.thop)
	c:RegisterEffect(e1)
	--p set and SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25000032,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,15000032) 
	e1:SetTarget(c25000032.psptg)
	e1:SetOperation(c25000032.pspop)
	c:RegisterEffect(e1) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25000032,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,35000032)
	e1:SetTarget(c25000032.sptg)
	e1:SetOperation(c25000032.spop)
	c:RegisterEffect(e1)
end
function c25000032.ctfil(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end
function c25000032.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25000032.ctfil,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c25000032.ctfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoExtraP(g,tp,REASON_COST)
end
function c25000032.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_PENDULUM)
end
function c25000032.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25000032.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c25000032.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c25000032.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	end 
end
function c25000032.spfil(c,e,tp)
	if c:IsLocation(LOCATION_EXTRA) and not c:IsFaceup() then return false end 
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) 
end
function c25000032.sgck(g)
	local sg1=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local sg2=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
	local ft1=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft2=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetClassCount(Card.GetCode)~=2 then return false end 
	return ft2>=sg1:GetCount() and ft1>=sg2:GetCount()
end
function c25000032.psptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c25000032.spfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
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
	--c:IsCode(codes[1])
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local code1=Duel.AnnounceCard(tp,table.unpack(afilter))  
	getmetatable(e:GetHandler()).announce_filter={code1,OPCODE_ISCODE,OPCODE_NOT}
	local code2=Duel.AnnounceCard(tp,table.unpack(afilter))  
	e:SetLabel(code1,code2)
end
function c25000032.sgck1(g,code1,code2)
	local sg1=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local sg2=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
	local ft1=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft2=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft2>=sg1:GetCount() and ft1>=sg2:GetCount() and g:IsExists(Card.IsCode,1,nil,code1) and g:IsExists(Card.IsCode,1,nil,code2) and (#g==1 or g:GetClassCount(Card.GetCode)==2)
end
function c25000032.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then 
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) 
	local code1,code2=e:GetLabel()
	local g=Duel.GetMatchingGroup(c25000032.spfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
	local ct=2
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	ct=math.min(ct,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if g:CheckSubGroup(c25000032.sgck1,ct,ct,code1,code2) then 
	local sg=g:SelectSubGroup(tp,c25000032.sgck1,false,ct,ct,code1,code2)  
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
	end
	end
end 
function c25000032.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c25000032.desfil,tp,LOCATION_PZONE,0,1,e:GetHandler()) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectTarget(tp,c25000032.desfil,tp,LOCATION_PZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c25000032.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then 
	Duel.Destroy(tc,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end



