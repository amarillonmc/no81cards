--马纳历亚的密友 安&古蕾娅
function c72411800.initial_effect(c)
	  --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c72411800.matfilter1,c72411800.matfilter2,true)  
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c72411800.condition1)
	e1:SetTarget(c72411800.target1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c72411800.condition2)
	e2:SetTarget(c72411800.target2)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2)
	e3:SetCondition(c72411800.discon)
	e3:SetCost(c72411800.discost)
	e3:SetTarget(c72411800.distg)
	e3:SetOperation(c72411800.disop)
	c:RegisterEffect(e3)
end

function c72411800.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and eg:GetFirst()~=e:GetOwner()
end

function c72411800.costfilter(c)
	return c:IsCode(72411020,72411030) and c:IsAbleToDeck()
end
function c72411800.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411800.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c72411800.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		e:SetLabel(g:GetFirst():GetCode())
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c72411800.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()==72411030 then
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	elseif e:GetLabel()==72411020 then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c72411800.disop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==72411030 then
		Duel.NegateActivation(ev)
	elseif e:GetLabel()==72411020 then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c72411800.matfilter1(c,fc)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_LINK)
end
function c72411800.matfilter2(c,fc)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_SYNCHRO)
end
function c72411800.cfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_SYNCHRO)
end
function c72411800.cfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_LINK)
end
function c72411800.condition1(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c72411800.cfilter1,tp,LOCATION_MZONE,0,1,nil) 
end
function c72411800.condition2(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c72411800.cfilter2,tp,LOCATION_MZONE,0,1,nil) 
end
function c72411800.target1(e,c)
	return c==e:GetHandler() or (c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_LINK)) 
end
function c72411800.target2(e,c)
	return c==e:GetHandler() or (c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_SYNCHRO)) 
end
