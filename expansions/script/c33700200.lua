--coded by Lyris
--Heavenly Maid VIVIT
function c33700200.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 1 non-Token Monster, except "Heavenly Maid VIVIT".
	aux.AddLinkProcedure(c,c33700200.lfilter,1,1)
	--When this card is Special Summoned, send all monsters linked to this card to the GY.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.SendtoGrave(e:GetHandler():GetLinkedGroup(),REASON_EFFECT) end)
	c:RegisterEffect(e4)
	--Make your opponent send any non-"Heavenly Maid" monster is summoned or Special Summoned to a Monster Zone this card to the GY.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.SendtoGrave(eg:Filter(function(c,g) return g:IsContains(c) and not c:IsSetCard(0x444) end,nil,e:GetHandler():GetLinkedGroup()),REASON_RULE) end)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Once per turn, you can send 1 other "Heavenly Maid" monster you control to the GY, if you do, Special Summon 1 "Heavenly Maid Token" (Fairy/LIGHT/Level 2/ATK 2000/DEF 1000) on your side of the field.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetCost(c33700200.cost)
	e3:SetTarget(c33700200.target)
	e3:SetOperation(c33700200.spop)
	c:RegisterEffect(e3)
end
function c33700200.lfilter(c)
	return not c:IsType(TYPE_TOKEN) and not c:IsCode(33700200)
end
function c33700200.filter(c,tp)
	return c:IsSetCard(0x444) and c:GetOwner()==tp and c:IsAbleToGraveAsCost()
end
function c33700200.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700200.filter,tp,LOCATION_MZONE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33700200.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c33700200.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33700200.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,33700212,0x444,0x4011,2000,1000,2,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,33700212,0x444,0x4011,2000,1000,2,RACE_FAIRY,ATTRIBUTE_LIGHT)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
