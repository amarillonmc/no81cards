--古代的机械改造巨人
function c98920507.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,83104731,c98920507.mfilter,1,1,true,true)
	aux.AddContactFusionProcedure(c,c98920507.cfilter,LOCATION_ONFIELD,LOCATION_ONFIELD,c98920507.sprop(c))
--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c98920507.splimit)
	c:RegisterEffect(e1)
--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c98920507.valcheck)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c98920507.atkop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
 --actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c98920507.aclimit)
	e4:SetCondition(c98920507.actcon)
	c:RegisterEffect(e4)
--pierce
	--pierce  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(c)  
	e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e5:SetType(EFFECT_TYPE_FIELD)  
	e5:SetCode(EFFECT_CHANGE_DAMAGE)  
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e5:SetTargetRange(1,1)  
	e5:SetValue(c98920507.damval)  
	c:RegisterEffect(e5)
end
function c98920507.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c98920507.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c98920507.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c98920507.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c98920507.mfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER)
end
function c98920507.cfilter(c,fc)
	return c:IsAbleToGraveAsCost() and (c:IsControler(fc:GetControler()) or c:IsFaceup())
end
function c98920507.sprop(c)
	return  function(g)
				Duel.SendtoGrave(g,REASON_COST)
			end
end
function c98920507.valcheck(e,c)
	local g=c:GetMaterial()
	local atk=0
	local tc=g:GetFirst()
	if tc:IsCode(83104731) or tc:CheckFusionSubstitute(c) then tc=g:GetNext() end
	if not tc:IsCode(83104731) then
		atk=math.ceil(tc:GetTextAttack()/2)
	end
	e:SetLabel(atk)
end
function c98920507.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabelObject():GetLabel()
	if atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c98920507.damval(e,re,dam,r,rp,rc)  
	if bit.band(r,REASON_BATTLE)~=0 and Duel.GetAttacker()==e:GetHandler() and e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetBattleTarget():IsPosition(POS_DEFENSE) then  
		return dam+1000
	else return dam end  
end 