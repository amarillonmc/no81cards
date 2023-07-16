--拟态武装 零度指针
function c67200641.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200641,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,67200641)
	e1:SetCondition(c67200641.plcon)
	e1:SetTarget(c67200641.pltg)
	e1:SetOperation(c67200641.plop)
	c:RegisterEffect(e1) 
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCountLimit(1,67200640)
	e2:SetValue(c67200641.matval)
	c:RegisterEffect(e2)	  
end
--
function c67200641.plcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE
end
function c67200641.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c67200641.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67200641,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		--indes
		e2:SetDescription(aux.Stringid(67200641,2))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
		e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetRange(LOCATION_PZONE)
		e2:SetTarget(c67200641.distg)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e2)
	end
end
--

function c67200641.distg(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0x667b) and c:IsType(TYPE_MONSTER)
end
---
function c67200641.exmfilter(c)
	return c:IsLocation(LOCATION_SZONE) and c:IsCode(67200641)
end
function c67200641.matval(e,lc,mg,c,tp)
	if not (lc:IsSetCard(0x667b) and lc:IsAttribute(ATTRIBUTE_FIRE)) then return false,nil end
	return true,not mg or not mg:IsExists(c67200641.exmfilter,1,nil)
end
