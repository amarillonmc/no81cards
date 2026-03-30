--拜布莉丝之虫惑魔
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(s.imcon)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.copycost)
	e2:SetTarget(s.copytg)
	e2:SetOperation(s.copyop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.sccon)
	e3:SetTarget(s.sctg)
	e3:SetOperation(s.scop)
	c:RegisterEffect(e3)
end

function s.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,4) or c:IsRank(4)
end

function s.imcon(e) return e:GetHandler():GetOverlayCount()>0 end

function s.efilter(e,te) return te:IsActiveType(TYPE_TRAP) end

function s.check_91812341_1(tp) return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
function s.check_91812341_2(tp) return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
function s.check_45803070_1(tp,e) return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
function s.check_45803070_2(tp) return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
function s.check_82738277_1(tp) return Duel.IsExistingMatchingCard(s.monfilter,tp,LOCATION_DECK,0,1,nil) end
function s.check_49027020_1(tp) return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,12801833) end
function s.check_49027020_2(tp) return Duel.IsExistingMatchingCard(Card.IsSummonType,tp,0,LOCATION_MZONE,1,nil,SUMMON_TYPE_SPECIAL) end
function s.copyfilter(c,e,tp)
	if not (c:IsSetCard(0x108a) and c:IsLevel(4)) then return false end
	local code=c:GetOriginalCode()
	if code==91812341 then return s.check_91812341_1(tp) or s.check_91812341_2(tp)
	elseif code==45803070 then return s.check_45803070_1(tp,e) or s.check_45803070_2(tp)
	elseif code==82738277 then return s.check_82738277_1(tp)
	elseif code==49027020 then return s.check_49027020_1(tp) or s.check_49027020_2(tp)
	end
	return false
end
function s.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.copyfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.copyfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.copyfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local code=tc:GetOriginalCode()  
	local off=1
	local ops={}
	local opval={}
	if code==91812341 then
		if s.check_91812341_1(tp) then ops[off]=aux.Stringid(id,2); opval[off-1]=0; off=off+1 end
		if s.check_91812341_2(tp) then ops[off]=aux.Stringid(id,3); opval[off-1]=1; off=off+1 end
	elseif code==45803070 then
		if s.check_45803070_1(tp,e) then ops[off]=aux.Stringid(id,2); opval[off-1]=0; off=off+1 end
		if s.check_45803070_2(tp) then ops[off]=aux.Stringid(id,3); opval[off-1]=1; off=off+1 end
	elseif code==82738277 then
		if s.check_82738277_1(tp) then ops[off]=aux.Stringid(id,2); opval[off-1]=0; off=off+1 end
	elseif code==49027020 then
		if s.check_49027020_1(tp) then ops[off]=aux.Stringid(id,2); opval[off-1]=0; off=off+1 end
		if s.check_49027020_2(tp) then ops[off]=aux.Stringid(id,3); opval[off-1]=1; off=off+1 end
	end
	if off==1 then return end
	local op=0
	if off>2 then
		op=Duel.SelectOption(tp,table.unpack(ops))
	end
	local sel=opval[op]
	if code == 91812341 then
		if sel == 0 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then Duel.SendtoHand(g,nil,REASON_EFFECT); Duel.ConfirmCards(1-tp,g) end
		else 
			local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=g:Select(tp,1,1,nil)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	elseif code == 45803070 then
		if sel == 0 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE) end
		else 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			if #g>0 then Duel.SSet(tp,g:GetFirst()) end
		end
	elseif code == 82738277 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.monfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then Duel.SendtoHand(g,nil,REASON_EFFECT); Duel.ConfirmCards(1-tp,g) end
	elseif code == 49027020 then
		if sel == 0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,12801833)
			if #g>0 then Duel.SendtoHand(g,nil,REASON_EFFECT); Duel.ConfirmCards(1-tp,g) end
		else 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsSummonType,tp,0,LOCATION_MZONE,1,1,nil,SUMMON_TYPE_SPECIAL)
			if #g>0 then Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
		end
	end
end
function s.thfilter(c) return c:IsSetCard(0x4c,0x89) and c:IsType(TYPE_TRAP) and c:IsAbleToHand() end
function s.spfilter(c,e,tp) return c:IsSetCard(0x108a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
function s.setfilter(c) return c:IsSetCard(0x4c,0x89) and c:IsType(TYPE_TRAP) and c:IsSSetable() end
function s.monfilter(c) return c:IsSetCard(0x108a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() end
function s.sccon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.scfilter(c) return c:IsType(TYPE_XYZ) and c:IsXyzSummonable(nil) end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.scfilter,tp,LOCATION_EXTRA,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,tc,nil)
	end
end