--霸王眷龙 异色眼
function c40008827.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40008827)
	e1:SetCost(c40008827.spcost)
	e1:SetTarget(c40008827.sptg)
	e1:SetOperation(c40008827.spop)
	c:RegisterEffect(e1)   
	--double damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c40008827.damcon)
	e2:SetTarget(c40008827.damtg)
	e2:SetOperation(c40008827.damop)
	e2:SetDescription(aux.Stringid(40008827,3))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	c:RegisterEffect(e2) 
	--tuner (banish)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,40008828)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c40008827.target2)
	e3:SetOperation(c40008827.operation2)
	c:RegisterEffect(e3)
end
function c40008827.cfilter(c)
	return (c:IsSetCard(0x20f8) or c:IsSetCard(0x10f8)) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtraAsCost()
end
function c40008827.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008827.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c40008827.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoExtraP(g,tp,REASON_COST)
end
function c40008827.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=c:IsAbleToGrave()
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(40008827,0))
	elseif not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(40008827,1))+1
	elseif b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(40008827,0),aux.Stringid(40008827,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
	end
end
function c40008827.thfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x20f8) or c:IsSetCard(0x10f8)) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c40008827.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:GetLabel()==1 and c:IsRelateToEffect(e)
		and Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsLocation(LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(c40008827.thfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(40008827,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c40008827.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c40008827.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:IsRelateToBattle() and tc:IsType(TYPE_EFFECT) and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c40008827.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=eg:GetFirst():GetBattleTarget():GetAttack()/2
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c40008827.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c40008827.filter1(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c40008827.filter2(c)
	return c40008827.filter1(c) and c:IsRace(RACE_DRAGON) and c:GetLevel()>0
end
function c40008827.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40008827.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008827.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40008827.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c40008827.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(4)
		tc:RegisterEffect(e2)
	end
end
