--多元春化精的花盛
function c98941000.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--山と雪解の春化精
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98941000,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c98941000.drcost)
	e2:SetTarget(c98941000.drtg1)
	e2:SetOperation(c98941000.drop1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(c98941000.eftg1)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--丘と芽吹の春化精
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98941000,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c98941000.drcost)
	e4:SetTarget(c98941000.thtg)
	e4:SetOperation(c98941000.thop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetTarget(c98941000.eftg2)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--森と目覚の春化精
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98941000,0))
	e6:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_HAND)
	e6:SetCost(c98941000.drcost)
	e6:SetTarget(c98941000.tgtg)
	e6:SetOperation(c98941000.tgop)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e7:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e7:SetTargetRange(LOCATION_HAND,0)
	e7:SetTarget(c98941000.eftg3)
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7)
	--花と野原の春化精
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(98941000,0))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_HAND)
	e8:SetCost(c98941000.drcost)
	e8:SetTarget(c98941000.thtg1)
	e8:SetOperation(c98941000.thop1)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e9:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e9:SetTargetRange(LOCATION_HAND,0)
	e9:SetTarget(c98941000.eftg4)
	e9:SetLabelObject(e8)
	c:RegisterEffect(e9)
	--苗と霞の春化精
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(98941000,0))
	e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_HAND)
	e10:SetCost(c98941000.drcost)
	e10:SetTarget(c98941000.thtg2)
	e10:SetOperation(c98941000.thop2)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e11:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e11:SetTargetRange(LOCATION_HAND,0)
	e11:SetTarget(c98941000.eftg5)
	e11:SetLabelObject(e10)
	c:RegisterEffect(e11)
	--to hand
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(98941000,1))
	e12:SetCategory(CATEGORY_TOHAND)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e12:SetRange(LOCATION_FZONE)
	e12:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e12:SetCondition(c98941000.thcon)
	e12:SetTarget(c98941000.thtg0)
	e12:SetOperation(c98941000.thop0)
	c:RegisterEffect(e12)
	--adjust
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e13:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e13:SetCode(EVENT_ADJUST)
	e13:SetRange(0xff)
	e13:SetOperation(c98941000.adjustop)
	c:RegisterEffect(e13)
	--change effect type
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetCode(98941000)
	e14:SetRange(LOCATION_FZONE)
	e14:SetTargetRange(1,0)
	c:RegisterEffect(e14)
	--special summon
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e15:SetCode(EVENT_SPSUMMON_SUCCESS)
	e15:SetRange(LOCATION_FZONE)
	e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e15:SetOperation(c98941000.regop)
	c:RegisterEffect(e15)
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e16:SetCode(EVENT_CHAIN_SOLVED)
	e16:SetRange(LOCATION_FZONE)
	e16:SetCondition(c98941000.recon)
	e16:SetOperation(c98941000.reop)
	c:RegisterEffect(e16)
	--add setcode
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetRange(LOCATION_SZONE)
	e17:SetTargetRange(LOCATION_MZONE,0)
	e17:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH))
	e17:SetCode(EFFECT_ADD_SETCODE)
	e17:SetValue(0x182)
	c:RegisterEffect(e17)
	--atk up
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetCode(EFFECT_UPDATE_ATTACK)
	e18:SetRange(LOCATION_FZONE)
	e18:SetTargetRange(LOCATION_MZONE,0)
	e18:SetValue(1000)
	e18:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH))
	c:RegisterEffect(e18)
	if not c98941000.global_activate_check then
		c98941000.global_activate_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c98941000.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c98941000.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:GetValue()~=60969918 then return end
	if rc:IsLocation(LOCATION_MZONE) and rc:GetFlagEffect(98941000)==0 then
		rc:RegisterFlagEffect(98941000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c98941000.costfilter(c)
	return (c:IsType(TYPE_MONSTER) or c:IsSetCard(0x182)) and c:IsDiscardable()
end
function c98941000.stfilter(c,tp)
	return c:IsCode(98941000) and c:IsType(TYPE_FIELD) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c98941000.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b2=Duel.IsExistingMatchingCard(c98941000.costfilter,tp,LOCATION_HAND,0,1,c)
	local b1=Duel.IsExistingMatchingCard(c98941000.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	if chk==0 then return c:IsDiscardable() and b2 and b1 and Duel.GetFieldCard(tp,LOCATION_FZONE,0)==nil end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c98941000.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c98941000.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function c98941000.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98941000.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98941000.drop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98941000.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(98941000,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c98941000.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98941000.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsNonAttribute(ATTRIBUTE_EARTH)
end
function c98941000.thfilter(c)
	return c:IsSetCard(0x182) and not c:IsCode(9350312) and c:IsAbleToHand()
end
function c98941000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98941000.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98941000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98941000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98941000.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(98941000,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c98941000.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98941000.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsSummonableCard() and c:IsAbleToGrave()
end
function c98941000.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98941000.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98941000.spfilter1(c,e,tp,code)
	return c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98941000.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98941000.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98941000.spfilter1),tp,LOCATION_GRAVE,0,nil,e,tp,tc:GetCode())
		if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(98941000,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c98941000.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98941000.thfilter1(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsCode(62133026) and c:IsAbleToHand()
end
function c98941000.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98941000.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c98941000.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98941000.thfilter1),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98941000.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(98941000,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c98941000.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98941000.thfilter2(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand() and not c:IsCode(81519836)
end
function c98941000.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98941000.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98941000.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98941000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98941000.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(98941000,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c98941000.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98941000.eftg1(e,c)
	return c:IsOriginalCodeRule(9238125)
end
function c98941000.eftg2(e,c)
	return c:IsOriginalCodeRule(9350312)
end
function c98941000.eftg3(e,c)
	return c:IsOriginalCodeRule(36745317)
end
function c98941000.eftg4(e,c)
	return c:IsOriginalCodeRule(62133026)
end
function c98941000.eftg5(e,c)
	return c:IsOriginalCodeRule(81519836)
end
function c98941000.cfilter(c,tp)
   return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp)
end
function c98941000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98941000.cfilter,1,nil,tp)
end
function c98941000.thfilter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98941000.thtg0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and c98941000.thfilter0(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98941000.thfilter0,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c98941000.thfilter0,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98941000.thop0(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c98941000.ufilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c98941000.actarget(e,te,tp)
	--prevent activating
	local tc=te:GetHandler()
	return ((te:GetValue()==60965917 or te:GetValue()==60965919) and not Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),60965917))  
	--prevent normal activating beside S&T on field
	or (te:GetValue()==60965918 and Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),60965917) and not (te:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsLocation(LOCATION_SZONE))) 
	--prevent quick activating on field
	or (te:GetValue()==60965919 and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_SZONE))
end
function c98941000.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not c98941000.globle_check then
		c98941000.globle_check=true
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(c98941000.actarget)
		Duel.RegisterEffect(ge0,0)
		--Activate to field
		local ge1=Effect.CreateEffect(e:GetHandler())
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(c98941000.actarget2)
		ge1:SetOperation(c98941000.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local g=Duel.GetMatchingGroup(c98941000.ufilter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		esetcountLimit=Effect.SetCountLimit
		table_effect={}
		table_countlimit_flag=0
		table_countlimit_count=0
		Effect.SetCountLimit=function(effect,count,flag)
			table_countlimit_flag=flag
			table_countlimit_count=count
			return esetcountLimit(effect,count,flag)
		end
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				if (table_countlimit_flag~=0 and table_countlimit_count==1) or (effect:IsHasType(EFFECT_TYPE_IGNITION) and not card:IsType(TYPE_SPELL)) or 
				(effect:IsHasType(EFFECT_TYPE_ACTIVATE) and not card:IsType(TYPE_TRAP) and not card:IsType(TYPE_QUICKPLAY)) and not card:IsType(TYPE_SPELL) then
					eff:SetValue(60969918)
					--effect edit
					local eff2=effect:Clone()
					--id remove
					if table_countlimit_flag~=0 and table_countlimit_count==1 and not card:IsType(TYPE_SPELL) then
						esetcountLimit(eff2,1,table_countlimit_flag)
					end
					--spell speed 2
					if eff2:IsHasType(EFFECT_TYPE_IGNITION) then
						eff2:SetDescription(aux.Stringid(98941000,4))
						eff2:SetCondition(c98941000.condition)
						eff2:SetType(EFFECT_TYPE_QUICK_O)
						eff2:SetCode(EVENT_FREE_CHAIN)
						eff2:SetHintTiming(TIMING_END_PHASE,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
					end
					eff2:SetValue(98941000)
					--spell activate in hand
					if eff2:IsHasType(EFFECT_TYPE_ACTIVATE) and not card:IsType(TYPE_TRAP) and not card:IsType(TYPE_SPELL) and not card:IsType(TYPE_MONSTER) then
						eff2:SetDescription(aux.Stringid(98941000,6))
						eff2:SetType(EFFECT_TYPE_QUICK_O)
						eff2:SetCode(EVENT_FREE_CHAIN)
						eff2:SetRange(LOCATION_HAND)
						eff2:SetValue(60969919)
						eff2:SetHintTiming(TIMING_END_PHASE,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
					end
					table.insert(table_effect,eff2)
				end
				table.insert(table_effect,eff)
			end
			table_countlimit_flag=0
			table_countlimit_count=0
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			tc:ReplaceEffect(98941000,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
		end
		Card.RegisterEffect=cregister
		Effect.SetCountLimit=esetcountLimit
	end
	e:Reset()
end
function c98941000.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(98941000,tp,LOCATION_FZONE) and (e:GetHandler():IsLocation(LOCATION_MZONE) or e:GetHandler():IsSetCard(0x182))
end
function c98941000.actarget2(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc:IsSetCard(0x182) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_HAND) and tc:IsType(TYPE_SPELL)
end
function c98941000.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	te:SetType(EFFECT_TYPE_ACTIVATE)
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	local ge3=Effect.CreateEffect(tc)
	ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ge3:SetCode(EVENT_CHAIN_SOLVED)
	ge3:SetLabelObject(te)
	ge3:SetReset(RESET_PHASE+PHASE_END)
	ge3:SetOperation(c98941000.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)
end
function c98941000.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		re:SetType(EFFECT_TYPE_QUICK_O)
		e:Reset()
	end
end
function c98941000.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetOperation(c98941000.sop)
	e3:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e3,tp)
end
function c98941000.sop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then e:GetHandler():RegisterFlagEffect(98941000,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1) end
end
function c98941000.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function c98941000.tg(e,tp,eg,ep,ev,re,r,rp,chk)	
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x11b)
	if chk==0 then return Duel.IsExistingMatchingCard(c98941000.filter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98941000.lkfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLinkSummonable(nil)
end
function c98941000.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsXyzSummonable(nil)
end
function c98941000.syfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsSynchroSummonable(nil)
end
function c98941000.sssfilter(c,e,tp)
	return c:IsCode(55125728) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98941000.sumfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsSummonable(true,nil)
end
function c98941000.reop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c98941000.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
	local g2=Duel.GetMatchingGroup(c98941000.syfilter,tp,LOCATION_EXTRA,0,nil,nil)
	local g3=Duel.GetMatchingGroup(c98941000.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	local g4=Duel.GetMatchingGroup(c98941000.sumfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g5=Duel.GetMatchingGroup(c98941000.sssfilter,tp,LOCATION_DECK,0,nil,e)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c98941000.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c98941000.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c98941000.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	local b1=g1:GetCount()>0
	local b2=g2:GetCount()>0
	local b3=g3:GetCount()>0
	local b4=g4:GetCount()>0
	local b5=g5:GetCount()>0
	local b6=(sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0))
	local b7=b1 or b2 or b3 or b4
	if (b7 or b6 or b5) and Duel.SelectYesNo(tp,aux.Stringid(98941000,11)) then 
	   local op1=aux.SelectFromOptions(tp,
			{b7,aux.Stringid(98941000,8)},
			{b6,aux.Stringid(98941000,9)},
			{b5,aux.Stringid(98941000,10)},
			{true,aux.Stringid(197042,2)})
		if op1==1 then
			local op2=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(98941000,5)},
			{b2,aux.Stringid(98941000,6)},
			{b3,aux.Stringid(98941000,7)},
			{b4,aux.Stringid(98941000,3)},
			{true,aux.Stringid(197042,2)})
			if op2==3 then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			   local sg1=g3:Select(tp,1,1,nil)
			   Duel.XyzSummon(tp,sg1:GetFirst(),nil)
			elseif op2==1 then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			   local sgk2=g1:Select(tp,1,1,nil)
			   Duel.LinkSummon(tp,sgk2:GetFirst(),nil)
			elseif op2==2 then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			   local sgk=g2:Select(tp,1,1,nil)
			   Duel.SynchroSummon(tp,sgk:GetFirst(),nil)
			elseif op2==4 then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			   local gec=Duel.SelectMatchingCard(tp,c98941000.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			   local tc=gec:GetFirst()
			   if tc then
				   Duel.Summon(tp,tc,true,nil)
			   end
			end
		elseif op1==2 then
			local msg=sg1:Clone()
			if sg2 then msg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=msg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		 elseif op1==3 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c98941000.sssfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
			   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
   end
end
function c98941000.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c98941000.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_EARTH) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end