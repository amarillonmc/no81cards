--方舟骑士-远山
c29003614.named_with_Arknight=1
function c29003614.initial_effect(c)
	aux.AddCodeList(c,29003615)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29003614,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29003614)
	e1:SetTarget(c29003614.tktg)
	e1:SetOperation(c29003614.tkop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29003614,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,29003615)
	e2:SetTarget(c29003614.target)
	e2:SetOperation(c29003614.activate)
	c:RegisterEffect(e2)
c29003614.toss_coin=true
end
function c29003614.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29003615,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c29003614.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,29003615,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,29003615)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c29003614.thfilter1(c)
	return c:IsCode(29065532) and c:IsAbleToHand()
end
function c29003614.thfilter2(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c29003614.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29003614.thfilter1,tp,LOCATION_DECK,0,1,nil)
		or Duel.IsExistingMatchingCard(c29003614.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
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
		if Duel.IsExistingMatchingCard(c29003614.thfilter2,tp,LOCATION_DECK,0,1,nil) then
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
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c29003614.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end