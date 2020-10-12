function c82221050.initial_effect(c)  
	aux.EnablePendulumAttribute(c)  
	--splimit  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(c82221050.psplimit)  
	c:RegisterEffect(e1) 
	--pendulum set  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,82221050)  
	e2:SetTarget(c82221050.pentg)  
	e2:SetOperation(c82221050.penop)  
	c:RegisterEffect(e2) 
	--attack  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_UPDATE_ATTACK)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetValue(c82221050.atkval)  
	c:RegisterEffect(e3)  
end

function c82221050.penfilter(c)  
	return c:IsSetCard(0x99) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_PENDULUM) and not c:IsCode(82221050) and not c:IsForbidden()  
end  
function c82221050.pentg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsDestructable()  
		and Duel.IsExistingMatchingCard(c82221050.penfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)  
end  
function c82221050.penop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)  
		local g=Duel.SelectMatchingCard(tp,c82221050.penfilter,tp,LOCATION_DECK,0,1,1,nil)  
		local tc=g:GetFirst()  
		if tc then  
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)  
		end  
	end  
end  
function c82221050.psplimit(e,c,tp,sumtp,sumpos)  
	return not c:IsRace(RACE_DRAGON) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM  
end  
function c82221050.atkval(e,c)  
	return Duel.GetMatchingGroupCount(c82221050.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)*200  
end  
function c82221050.atkfilter(c)  
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) 
end  
