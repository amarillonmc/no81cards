--方舟骑士-煌
c29065514.named_with_Arknight=1
function c29065514.initial_effect(c)
	aux.AddCodeList(c,29065500) 
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c29065514.mfilter,aux.TRUE,2,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c29065514.discon)
	e1:SetOperation(c29065514.disop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065514,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCountLimit(1,29065514)
	e2:SetCost(c29065514.decost)
	e2:SetCondition(c29065514.descon)
	e2:SetTarget(c29065514.destg)
	e2:SetOperation(c29065514.desop)
	c:RegisterEffect(e2)
	--tohand or spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,29065515)
	e3:SetCondition(c29065514.secon)
	e3:SetTarget(c29065514.thtg)
	e3:SetOperation(c29065514.thop)
	c:RegisterEffect(e3)
end
function c29065514.mfilter(c,xyzc)
	local b1=(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
	local b2=c:IsXyzLevel(xyzc,5)
	local b3=c:IsXyzLevel(xyzc,6)
	return b1 and (b2 or b3)
end
function c29065514.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29065514.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065514.xyzop(e,tp,chk)
	if chk==0 then return (Duel.IsCanRemoveCounter(tp,1,0,0x10ae,3,REASON_COST) or (Duel.GetFlagEffect(tp,29096814)==1 and Duel.IsCanRemoveCounter(tp,1,0,0x10ae,2,REASON_COST))) and Duel.GetFlagEffect(tp,29065514)==0 end
	if Duel.GetFlagEffect(tp,29096814)==1 then
	Duel.ResetFlagEffect(tp,29096814)
	Duel.RemoveCounter(tp,1,0,0x10ae,2,REASON_RULE)
	Duel.RegisterFlagEffect(tp,29065514,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	else
	Duel.RemoveCounter(tp,1,0,0x10ae,3,REASON_RULE)
	Duel.RegisterFlagEffect(tp,29065514,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
end
function c29065514.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return re:GetHandler():GetControler()~=tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c29065514.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c29065514.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c29065514.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function c29065514.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c29065514.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c29065514.desfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c29065514.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c29065514.desfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	Duel.Destroy(g,REASON_EFFECT)
	Duel.SetLP(tp,Duel.GetLP(tp)-2000)
end
function c29065514.ffilter(c,chk)
	return c:IsCode(29065500) and c:IsFaceup()
end
function c29065514.secon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29065514.ffilter,tp,LOCATION_MZONE,0,1,nil,true)
end
function c29065514.filter(c,e,tp,ft)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP))
end
function c29065514.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c29065514.filter(chkc,e,tp,ft) end
	if chk==0 then return Duel.IsExistingTarget(c29065514.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c29065514.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
end
function c29065514.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if aux.NecroValleyNegateCheck(tc) then return end
		if not aux.NecroValleyFilter()(tc) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end