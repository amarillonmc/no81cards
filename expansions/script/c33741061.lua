--HoloVTuber FuwaMoco
function c33741061.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4,c33741061.lcheck)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c33741061.atkcon)
	e1:SetValue(3000)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c33741061.damcon)
	e2:SetTarget(c33741061.damtg)
	e2:SetOperation(c33741061.damop)
	c:RegisterEffect(e2)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c33741061.valcheck)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c33741061.regcon)
	e3:SetOperation(c33741061.regop)
	e3:SetLabelObject(e0) 
	c:RegisterEffect(e3)
end
function c33741061.mfilter(c,g)
	return g:IsExists(c33741061.samfilter,1,c,c) and not c:IsType(TYPE_LINK)
end
function c33741061.samfilter(c,tc)
	return c:IsRace(tc:GetRace()) and c:IsLinkAttribute(tc:GetLinkAttribute()) and c:IsAttack(tc:GetAttack()) and c:IsDefense(tc:GetDefense()) and not c:IsLinkCode(tc:GetLinkCode())
end
function c33741061.lcheck(g,lc)
	return g:IsExists(c33741061.mfilter,1,nil,g)
end
function c33741061.atkcon(e)
	local g=e:GetHandler():GetLinkedGroup()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and #g>=2 and g:GetClassCount(Card.GetRace)==#g and g:GetClassCount(Card.GetAttribute)==#g
end
function c33741061.damcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetLinkedGroup()
	return ep~=tp and #g>=2 and g:GetClassCount(Card.GetRace)==#g and g:GetClassCount(Card.GetAttribute)==#g
end
function c33741061.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(3000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3000)
end
function c33741061.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c33741061.valcheck(e,c)
	local mg=c:GetMaterial()
	local ct=mg:GetClassCount(Card.GetRace)==4 and mg:GetClassCount(Card.GetAttribute)==4 and mg:GetClassCount(Card.GetAttack)==4 and mg:GetClassCount(Card.GetDefense)==4 and 1 or 0
	e:SetLabel(ct)
end
function c33741061.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabelObject():GetLabel()~=0
end
function c33741061.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c33741061.damval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c33741061.damval(e,re,dam,r,rp,rc)
	return dam*2
end
