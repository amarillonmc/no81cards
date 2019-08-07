--虫惑之森
function c10150075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x108a))
	e2:SetValue(500)
	c:RegisterEffect(e2)	
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3) 
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetCondition(c10150075.setcon)
	e4:SetOperation(c10150075.setop)
	c:RegisterEffect(e4)
	--effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10150075,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c10150075.eftg)
	e5:SetOperation(c10150075.efop)
	c:RegisterEffect(e5)
end
function c10150075.sumfilter(c)
	return c:IsSetCard(0x108a) and c:IsSummonable(true,nil)
end
function c10150075.spfilter(c,e,tp)
	return c:IsSetCard(0x108a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10150075.thfilter(c)
	return ((c:GetType()==TYPE_TRAP and (c:IsSetCard(0x4c) or c:IsSetCard(0x89))) or (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x108a))) and c:IsAbleToHand()
end
function c10150075.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c10150075.sumfilter,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c10150075.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b3=Duel.IsExistingMatchingCard(c10150075.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(10150075,2)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(10150075,3)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(10150075,4)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
	elseif sel==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	else
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function c10150075.efop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	   local sumg=Duel.SelectMatchingCard(tp,c10150075.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	   if sumg:GetCount()>0 then
		  Duel.Summon(tp,sumg:GetFirst(),true,nil)
	   end
	elseif sel==2 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local sg=Duel.SelectMatchingCard(tp,c10150075.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	   if sg:GetCount()>0 then
		  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	   end
	else
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10150075.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	   if tg:GetCount()>0 then
		  Duel.HintSelection(tg)
		  Duel.SendtoHand(tg,nil,REASON_EFFECT)
	   end
	end
end
function c10150075.setcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and  rc:GetType()==TYPE_TRAP and (rc:IsSetCard(0x4c) or rc:IsSetCard(0x89)) and rc:IsCanTurnSet()
end
function c10150075.setop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and Duel.SelectYesNo(tp,aux.Stringid(10150075,0)) then
	   Duel.Hint(HINT_CARD,0,10150075)
	   rc:CancelToGrave()
	   Duel.ChangePosition(rc,POS_FACEDOWN)
	   Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
