--鸢一折纸 圣洁天使
function c33400410.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c33400410.xyzfilter,8,2)
	c:EnableReviveLimit()
	--sps
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400410,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)   
	e1:SetCountLimit(1,33400410+10000) 
	e1:SetCondition(c33400410.condition1) 
	e1:SetCost(c33400410.spcost)
	e1:SetTarget(c33400410.target)
	e1:SetOperation(c33400410.operation)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400410,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33400410)
	e2:SetCondition(c33400410.condition2)
	e2:SetCost(c33400410.spcost)
	e2:SetTarget(c33400410.eqtg)
	e2:SetOperation(c33400410.eqop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400410,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33400410)
	e3:SetCondition(c33400410.condition2)
	e3:SetCost(c33400410.spcost)
	e3:SetTarget(c33400410.settg)
	e3:SetOperation(c33400410.setop)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c33400410.effcon)
	e4:SetOperation(c33400410.effop)
	c:RegisterEffect(e4)
end
function c33400410.xyzfilter(c)
	return c:IsSetCard(0x341) 
end
function c33400410.condition1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c33400410.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
   local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function c33400410.spfilter(c,e,tp)
	return   c:IsSetCard(0x341)  and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400410.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33400410.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c33400410.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33400410.operation(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33400410.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c33400410.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c33400410.eqfilter(c,e,tp,ec)
	return ((c:IsSetCard(0x6343) and c:IsType(TYPE_EQUIP)) or c:IsSetCard(0x5343)) and c:CheckUniqueOnField(tp)
end
function c33400410.eqfilter2(c)
	return c:IsSetCard(0xc343)  
end
function c33400410.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c33400410.eqfilter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c33400410.eqfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,0,0,0,0)
end
function c33400410.eqop(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsExistingMatchingCard(c33400410.eqfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler())
	or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.IsExistingMatchingCard(c33400410.eqfilter2,tp,LOCATION_MZONE,0,1,nil) then return false end
	local g=Duel.GetMatchingGroup(c33400410.eqfilter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:Select(tp,1,1,nil)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc2=Duel.SelectMatchingCard(tp,c33400410.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	 local tc1=tc2:GetFirst()
	 Duel.Equip(tp,tc,tc1)
	if tc:IsSetCard(0x5343) then
	   local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c33400410.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)	 
   end
end
function c33400410.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() and c:IsSetCard(0x5342)
end
function c33400410.setfilter(c)
	return c:IsSetCard(0x95)  and c:IsSSetable()
end
function c33400410.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400410.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c33400410.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33400410.setfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
		local tc1=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc1:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc1:RegisterEffect(e2)
	end
end

function c33400410.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c33400410.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(33400410,3))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c33400410.recon)
	e1:SetCost(c33400410.spcost)
	e1:SetTarget(c33400410.retg)
	e1:SetOperation(c33400410.reop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c33400410.refilter(c)
	return  c:IsAbleToRemove() 
end
function c33400410.eqfilter4(c)
	return ((c:IsSetCard(0x6343) and c:IsType(TYPE_EQUIP)) or c:IsSetCard(0x5343)) 
end
function c33400410.recon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c33400410.eqfilter4,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c33400410.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c33400410.refilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400410.refilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33400410.refilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c33400410.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if  tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end