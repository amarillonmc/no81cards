--AST 战间休息
function c33400429.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,33400429)
	e1:SetCondition(c33400429.condition)
	e1:SetTarget(c33400429.target)
	e1:SetOperation(c33400429.operation)
	c:RegisterEffect(e1)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,33400429)
	e3:SetCondition(c33400429.setcon)
	e3:SetTarget(c33400429.settg)
	e3:SetOperation(c33400429.setop)
	c:RegisterEffect(e3)
end
function c33400429.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c33400429.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33400429.cfilter,1,nil,tp)
end
function c33400429.thfilter(c)
	return c:IsSetCard(0x9343) or c:IsSetCard(0x6343)  and c:IsAbleToHand()
end
function c33400429.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400429.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local des=eg:GetFirst()
	local rc=des:GetReasonCard()
   if rc and (rc:IsSetCard(0x341) or(Duel.IsExistingMatchingCard(c33400429.cccfilter1,tp,LOCATION_SZONE,0,1,nil) or  Duel.IsExistingMatchingCard(c33400429.cccfilter2,tp,LOCATION_MZONE,0,1,nil) 
		   )) then
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
	else Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function c33400429.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g
   local des=eg:GetFirst()
	local rc=des:GetReasonCard()
   if (rc:IsSetCard(0x341) or(Duel.IsExistingMatchingCard(c33400429.cccfilter1,tp,LOCATION_SZONE,0,1,nil) or  Duel.IsExistingMatchingCard(c33400429.cccfilter2,tp,LOCATION_MZONE,0,1,nil) 
		   )) then
	 g=Duel.SelectMatchingCard(tp,c33400429.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,2,nil)
	else  g=Duel.SelectMatchingCard(tp,c33400429.thfilter,tp,LOCATION_GRAVE,0,1,2,nil)
	end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c33400429.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400429.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400429.cfilter2(c,tp,eg)
local pd=0
	local des=eg:GetFirst() 
	 while des do
	  local rc=des:GetReasonCard()
	  if  rc and pd==0 and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) 
		and (rc:IsSetCard(0x341) or(Duel.IsExistingMatchingCard(c33400429.cccfilter1,tp,LOCATION_SZONE,0,1,nil) or  Duel.IsExistingMatchingCard(c33400429.cccfilter2,tp,LOCATION_MZONE,0,1,nil) 
		   ))
	  then pd=1 end
		 des=eg:GetNext()
	 end
	return  pd==1
end
function c33400429.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33400429.cfilter2,1,nil,tp,eg)
end
function c33400429.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c33400429.setop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
