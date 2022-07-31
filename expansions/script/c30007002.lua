--电子暗黑再起动
local cm,m,t=GetID()  
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Effect 2  
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,0))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_DESTROYED)
	e11:SetRange(LOCATION_GRAVE)
	e11:SetCondition(cm.tohcon)
	e11:SetTarget(cm.tohtg)
	e11:SetOperation(cm.tohop)
	c:RegisterEffect(e11)
end
--Effect 1
function cm.filter(c,tp)
	local code=c:GetCode()
	return  c:IsRace(RACE_DRAGON+RACE_MACHINE) 
		and c:IsAttribute(ATTRIBUTE_DARK) 
		and c:IsDiscardable(REASON_EFFECT)
		and Duel.IsExistingMatchingCard(cm.tohand,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,code)
end
function cm.tohand(c,code)
	return c:IsSetCard(0x4093) and c:IsRace(RACE_MACHINE) 
		and c:IsAbleToHand() 
		and not c:IsCode(code)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local mg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,tp)
	if #mg>0 and Duel.SendtoGrave(mg,REASON_EFFECT+REASON_DISCARD)>0 then
		Duel.BreakEffect()
		local code=mg:GetFirst():GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tohand),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,code)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--Effect 2
function cm.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) 
		and c:IsPreviousSetCard(0x4093)
		and c:IsPreviousControler(tp) 
		and c:IsPreviousLocation(LOCATION_ONFIELD) 
		and c:IsPreviousPosition(POS_FACEUP)
end
function cm.tohcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.tohtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.tohop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0
		and c:IsLocation(LOCATION_HAND) 
		and Duel.IsExistingMatchingCard(cm.ec,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,cm.ec,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
		if not tc then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.eq),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		local ec=g:GetFirst()
		if not ec or not Duel.Equip(tp,ec,tc) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(tc)
		ec:RegisterEffect(e1)
		local e2=Effect.CreateEffect(ec)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1600)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2)
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.ec(c,tp)
	return c:IsSetCard(0x4093) and c:IsFaceup() and c:IsRace(RACE_MACHINE)
		and Duel.IsExistingMatchingCard(cm.eq,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
end
function cm.eq(c)
	return c:IsRace(RACE_DRAGON+RACE_MACHINE) and not c:IsForbidden()
end
