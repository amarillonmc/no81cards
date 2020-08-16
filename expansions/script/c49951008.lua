--混沌病毒·头部
function c49951008.initial_effect(c)
  --xyz summon
	aux.AddXyzProcedure(c,nil,1,3,c49951008.ovfilter,aux.Stringid(49951008,0),99,c49951008.xyzop)
	c:EnableReviveLimit()
	  --effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,49951008)
	e2:SetCost(c49951008.cost)
	e2:SetTarget(c49951008.target)
	e2:SetOperation(c49951008.operation)
	c:RegisterEffect(e2)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49951008,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c49951008.discon)
	e2:SetCost(c49951008.discost)
	e2:SetTarget(c49951008.distg)
	e2:SetOperation(c49951008.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49951008,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,41433680)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.exccon)
	e3:SetTarget(c49951008.destg)
	e3:SetOperation(c49951008.desop)
	c:RegisterEffect(e3)
end
function c49951008.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x823) and c:IsLevel(1) and not c:IsCode(49951008)
end
function c49951008.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,49951008)==0 end
	Duel.RegisterFlagEffect(tp,49951008,RESET_PHASE+PHASE_END,0,1)
end
function c49951008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c49951008.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c49951008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c49951008.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c49951008.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c49951008.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c49951008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCodeRule()
		local atk=tc:GetBaseAttack()
		if atk<0 then atk=0 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetLabelObject(e1)
		e2:SetLabel(cid)
		e2:SetOperation(c49951008.rstop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(atk)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	end
end 
function c49951008.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c49951008.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and Duel.IsChainDisablable(ev)
end
function c49951008.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c49951008.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c49951008.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c49951008.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x823)
end
function c49951008.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c49951008.sfilter(chkc,ft) end
	if chk==0 then return ft>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c49951008.sfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c49951008.sfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49951008.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
