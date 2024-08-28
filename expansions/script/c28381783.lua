--古之钥的序曲 蒸汽交响
function c28381783.initial_effect(c)
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x285),2,99,true)
	c:EnableReviveLimit()
   --spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(c28381783.hspcon)
	e0:SetOperation(c28381783.hspop)
	c:RegisterEffect(e0)
	--to grave and remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c28381783.tgcon)
	e1:SetTarget(c28381783.tgtg)
	e1:SetOperation(c28381783.tgop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c28381783.thtg)
	e2:SetOperation(c28381783.thop)
	c:RegisterEffect(e2)
	--L'Antica SetCode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(0x283)
	c:RegisterEffect(e3)
	--L'Antica Race
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetValue(RACE_FIEND)
	c:RegisterEffect(e4)
end
function c28381783.matfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsFusionSetCard(0x285) and c:IsCanBeFusionMaterial()
end
function c28381783.hspcon(e,c)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c28381783.matfilter,c:GetOwner(),LOCATION_MZONE,0,nil)
	return mg:GetCount()>=2 and Duel.GetLP(c:GetOwner())<=3000
end
function c28381783.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.SelectMatchingCard(tp,c28381783.matfilter,tp,LOCATION_MZONE,0,2,99,nil)
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c28381783.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c28381783.cfilter(c)
	return c:IsSetCard(0x285) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c28381783.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c28381783.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	if Duel.GetLP(tp)<=3000 then
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else e:SetProperty(EFFECT_FLAG_DELAY) end
end
function c28381783.tgfilter(c)
	return c:IsSetCard(0x285) and c:IsAbleToGrave()
end
function c28381783.refilter(c)
	return c:IsSetCard(0x285) and c:IsAbleToRemove()
end
function c28381783.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(300*ct)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local tct=Duel.GetMatchingGroupCount(c28381783.tgfilter,tp,LOCATION_DECK,0,nil)
	local rct=Duel.GetMatchingGroupCount(c28381783.refilter,tp,LOCATION_DECK,0,nil)
	if tct==0 and rct==0 then return end
	if tct>0 and (rct==0 or Duel.SelectOption(tp,1191,1192)==0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c28381783.tgfilter,tp,LOCATION_DECK,0,1,math.min(tct,ct),nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c28381783.refilter,tp,LOCATION_DECK,0,1,math.min(tct,ct),nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
function c28381783.dthfilter(c)
	return c:IsSetCard(0x285) and c:IsAbleToHand()
end
function c28381783.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28381783.dthfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28381783.gthfilter(c)
	return c:IsSetCard(0x285) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28381783.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c28381783.dthfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	if Duel.GetLP(tp)<=3000 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c28381783.gthfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28381783,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28381783.gthfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
