--弱者的温存
function c33700932.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33700932.target)
	e1:SetOperation(c33700932.activate)
	c:RegisterEffect(e1) 
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTarget(function(e,c) return c:GetBaseAttack()>=1200 end)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)  
	--adjust
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c33700932.adjustop)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetTarget(function(e,c) return c:GetBaseAttack()>=1200 end)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetTarget(function(e,c) return c:GetBaseAttack()<=1200 end)
	c:RegisterEffect(e6) 
	--indes
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(function(e,c) return c:GetBaseAttack()<=1200 and c:IsFaceup() end)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	local e22=e1:Clone()
	e22:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e22)
	--damage 
	local e41=Effect.CreateEffect(c)
	e41:SetType(EFFECT_TYPE_FIELD)
	e41:SetCode(EFFECT_CHANGE_DAMAGE)
	e41:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e41:SetRange(LOCATION_SZONE)
	e41:SetTargetRange(1,1)
	e41:SetValue(c33700932.damval)
	c:RegisterEffect(e41)
end
function c33700932.damval(e,re,val,r,rp,rc)
	return math.min(val,1200)
end
function c33700932.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g=Duel.GetMatchingGroup(c33700932.filter2,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_RULE)
		Duel.Readjust()
	end
end
function c33700932.filter(c)
	return c:IsFaceup() and c:GetBaseAttack()>=1200 and c:IsAbleToGrave()
end
function c33700932.filter2(c)
	return c:IsFaceup() and c:GetBaseAttack()>=1200 
end
function c33700932.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700932.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c33700932.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,tp,LOCATION_MZONE)
end
function c33700932.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c33700932.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end