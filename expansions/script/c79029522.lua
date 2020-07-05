--闪刀姬 甜心重锤
function c79029522.initial_effect(c)
	--Summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetDescription(aux.Stringid(79029522,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCondition(c79029522.ttcon2)
	e1:SetOperation(c79029522.ttop2)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)  
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c79029522.val)
	c:RegisterEffect(e2) 
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetTarget(c79029522.tgtg)
	e3:SetOperation(c79029522.tgop)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c79029522.effcon)
	e4:SetOperation(c79029522.effop)
	c:RegisterEffect(e4)
end
function c79029522.rfil(c)
	return c:GetSequence()>4
end
function c79029522.ttcon2(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c79029522.rfil,tp,0,LOCATION_MZONE,nil)
	return minc<=1 and Duel.CheckTribute(c,1,1,mg,1-tp)
end
function c79029522.ttop2(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local g=Duel.SelectTribute(tp,c,1,1,mg,1-tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c79029522.val(e,c)
	return e:GetHandler():GetMaterial():GetSum(Card.GetBaseAttack)
end
function c79029522.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,0)
end
function c79029522.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RULE)
end
function c79029522.effcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return r==REASON_LINK and ec:IsRace(RACE_MACHINE)
end
function c79029522.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e2=Effect.CreateEffect(rc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(c:GetBaseAttack())
	rc:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(rc)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e3:SetTarget(c79029522.tgtg)
	e3:SetOperation(c79029522.tgop)
	rc:RegisterEffect(e3)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end



