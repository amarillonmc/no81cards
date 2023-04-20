--电脑堺拟-妮妮
function c19198205.initial_effect(c)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19198205) 
	e1:SetCost(c19198205.cost)
	e1:SetTarget(c19198205.target)
	e1:SetOperation(c19198205.activate)
	c:RegisterEffect(e1)	
	--set
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,29198205) 
	e2:SetCost(c19198205.setcost) 
	e2:SetTarget(c19198205.settg) 
	e2:SetOperation(c19198205.setop) 
	c:RegisterEffect(e2) 
end 
function c19198205.ctfil(c) 
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and c:IsSetCard(0x14e)  
end 
function c19198205.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1) 
	local c=e:GetHandler() 
	if not c:IsStatus(STATUS_SET_TURN) then return true end
	local ct=#{e:GetHandler():IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN,tp)}
	local dis=Duel.IsExistingMatchingCard(c19198205.ctfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler())  
	if chk==0 then return ct>1 or dis end 
	if ct==1 or dis and Duel.SelectYesNo(tp,aux.Stringid(19198205,2)) then
		local sg=Duel.SelectMatchingCard(tp,c19198205.ctfil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler()) 
		Duel.SendtoGrave(sg,REASON_COST)  
	end 
end
function c19198205.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,19198205,0x14e,TYPES_NORMAL_TRAP_MONSTER,1000,2400,6,RACE_PSYCHO,ATTRIBUTE_WIND) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c19198205.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,19198205,0x14e,TYPES_NORMAL_TRAP_MONSTER,1000,2400,6,RACE_PSYCHO,ATTRIBUTE_WIND) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function c19198205.xctfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x14e)  
end 
function c19198205.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19198205.xctfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c19198205.xctfil,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end 
function c19198205.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end 
end 
function c19198205.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SSet(tp,c)   
	end 
end 

