--真红眼混沌龙
function c98920582.initial_effect(c)
	 --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--change damage
	local e5=Effect.CreateEffect(c)  
	e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e5:SetType(EFFECT_TYPE_FIELD)  
	e5:SetCode(EFFECT_CHANGE_DAMAGE)  
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e5:SetTargetRange(0,1)  
	e5:SetValue(c98920582.damval)  
	c:RegisterEffect(e5)
end
function c98920582.damval(e,re,dam,r,rp,rc)  
	if bit.band(r,REASON_BATTLE)~=0 and Duel.GetAttacker()==e:GetHandler() and e:GetHandler():GetBattleTarget()~=nil then  
		return 2400 
	else return dam end  
end 