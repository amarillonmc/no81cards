--绘梦少女
function c10113080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113080,0))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10113080.tktg)
	e2:SetOperation(c10113080.tkop)
	c:RegisterEffect(e2)   
end
function c10113080.refilter(c,e,tp,ft)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect(e) and not c:IsType(TYPE_TOKEN) and (ft>0 or c:IsLocation(LOCATION_MZONE)) and Duel.IsPlayerCanSpecialSummonMonster(tp,10113081,0,0x4011,c:GetBaseAttack(),c:GetBaseDefense(), c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute())
end
function c10113080.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c10113080.refilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp,ft) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10113080.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local ec=Duel.SelectMatchingCard(tp,c10113080.refilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp,ft):GetFirst()
	if ec and Duel.Release(ec,REASON_EFFECT)~=0 and Duel.IsPlayerCanSpecialSummonMonster(tp,10113081,0,0x4011,ec:GetBaseAttack(),ec:GetBaseDefense(),ec:GetOriginalLevel(),ec:GetOriginalRace(),ec:GetOriginalAttribute()) then 
	   Duel.BreakEffect()
	   local token=Duel.CreateToken(tp,10113081)
	   if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_SET_BASE_ATTACK)
	   e1:SetValue(ec:GetBaseAttack())
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   token:RegisterEffect(e1)
	   local e2=e1:Clone()
	   e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	   e2:SetValue(ec:GetBaseDefense())
	   token:RegisterEffect(e2)
	   local e3=e1:Clone()
	   e3:SetCode(EFFECT_CHANGE_LEVEL)
	   e3:SetValue(ec:GetOriginalLevel())
	   token:RegisterEffect(e3)
	   local e4=e1:Clone()
	   e4:SetCode(EFFECT_CHANGE_RACE)
	   e4:SetValue(ec:GetOriginalRace())
	   token:RegisterEffect(e4)
	   local e5=e1:Clone()
	   e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	   e5:SetValue(ec:GetOriginalAttribute())
	   token:RegisterEffect(e5)
	   local e6=e1:Clone()
	   e6:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	   token:RegisterEffect(e6)
	end
end