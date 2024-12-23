--方舟骑士团-远山
function c29003614.initial_effect(c)
	aux.AddCodeList(c,29003615)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29003614,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,29003614)
	e1:SetTarget(c29003614.sptg)
	e1:SetOperation(c29003614.spop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29003614,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COIN+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,29003615)
	e2:SetTarget(c29003614.target)
	e2:SetOperation(c29003614.activate)
	c:RegisterEffect(e2)
c29003614.toss_coin=true
c29003614.kinkuaoi_Akscsst=true
end
function c29003614.rfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasableByEffect()
end
function c29003614.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29003614.rfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29003614.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c29003614.rfilter,tp,LOCATION_MZONE,0,1,1,aux.ExceptThisCard(e),tp,c)
	if Duel.Release(g,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,29003615,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.SelectYesNo(tp,aux.Stringid(29003614,0)) then 
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,29003615)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c29003614.thfilter1(c)
	return c:IsSetCard(0x57af) and c:IsAbleToHand()
end
function c29003614.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29003614.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c29003614.activate(e,tp,eg,ep,ev,re,r,rp)
	local res
	if Duel.GetFlagEffect(tp,29088383)==1 then
		local off=1
		local ops={}
		local opval={}
		if Duel.IsExistingMatchingCard(c29003614.thfilter1,tp,LOCATION_DECK,0,1,nil) then
			ops[off]=aux.Stringid(29003614,2)
			opval[off-1]=0
			off=off+1
		end
		if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c) then
			ops[off]=aux.Stringid(29003614,3)
			opval[off-1]=1
			off=off+1
		end
		if off==1 then return end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		res=opval[op]
	else
		res=1-Duel.TossCoin(tp,1)
	end
	if res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c29003614.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end