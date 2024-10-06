--机娘·「太虚」
local m=37901001
local cm=_G["c"..m]
function cm.initial_effect(c)
--e1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(cm.cf11,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(cm.cf12,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
			and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end)
	c:RegisterEffect(e1)
--e2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,m+13)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.tf2,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tf2),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
--e4
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCondition(function(e)
		return Duel.IsExistingMatchingCard(cm.cf11,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(cm.cf12,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
	end)
	e4:SetValue(function(e,re,dam,r,rp,rc)
		if dam-800<0 then return 0 end
		return dam-800 
	end)
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x388))
	e5:SetCondition(function(e)
		return Duel.IsExistingMatchingCard(cm.cf11,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(cm.cf12,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
	end)
	e5:SetValue(800)
	c:RegisterEffect(e5) 
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_DISABLE)
	e6:SetValue(1)
	c:RegisterEffect(e6) 
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e7) 
end
--e1
function cm.cf11(c)
	return c:IsCode(m+1) and c:IsFaceup()
end
function cm.cf12(c)
	return c:IsCode(m+2) and c:IsFaceup()
end
--e2
function cm.tf2(c)
	return c:IsSetCard(0x388) and c:IsAbleToHand()
end