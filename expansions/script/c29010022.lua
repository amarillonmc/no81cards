--荒败之城 盐风
function c29010022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c29010022.activate)
	c:RegisterEffect(e1)
	--change code
	aux.EnableChangeCode(c,22702055)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,29010022)
	e2:SetCost(c29010022.tkcost)
	e2:SetTarget(c29010022.tktg)
	e2:SetOperation(c29010022.tkop)
	c:RegisterEffect(e2)
end
function c29010022.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c29010022.xyzlv)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetValue(TYPE_EFFECT)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e4:SetLabelObject(e3)
	e4:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e4,tp)
end
function c29010022.xyzlv(e,c,rc)
	return 0x80000+e:GetHandler():GetLevel()
end
function c29010022.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c29010022.thfilter(c)
	return c:IsSetCard(0x77af) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c29010022.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29010023,0,TYPES_TOKEN_MONSTER,1500,1500,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP,1-tp)
		and Duel.IsExistingMatchingCard(c29010022.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c29010022.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,29010023,0,TYPES_TOKEN_MONSTER,1500,1500,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,29010023)
		if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)~=0
			and Duel.IsExistingMatchingCard(c29010022.thfilter,tp,LOCATION_DECK,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,c29010022.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				if tc and tc:IsAbleToHand()
					and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				else
					Duel.SendtoGrave(tc,REASON_EFFECT)
				end
			end
		end
	end
end
