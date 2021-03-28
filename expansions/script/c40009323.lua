--二天苍翼 青天·苍天
function c40009323.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c40009323.mfilter,c40009323.xyzcheck,2,2)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c40009323.descon)
	e4:SetTarget(c40009323.mttg)
	e4:SetOperation(c40009323.mtop)
	c:RegisterEffect(e4)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009323,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c40009323.thcon)
	e2:SetTarget(c40009323.eqtg)
	e2:SetOperation(c40009323.eqop)
	c:RegisterEffect(e2) 
	--cannot be fusion material
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_SINGLE)
	--e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	--e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e3:SetValue(1)
	--c:RegisterEffect(e3)   
end
function c40009323.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_LINK)
end
function c40009323.xyzcheck(g)
	return g:GetClassCount(Card.GetBaseAttack)==1
end
function c40009323.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40009323.eqfilter(c,tp)
	return c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0xf13) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c40009323.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c40009323.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND)
end
function c40009323.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c40009323.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c40009323.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c40009323.eqlimit(e,c)
	return e:GetOwner()==c
end
function c40009323.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf13) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c40009323.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009323.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	if Duel.IsExistingMatchingCard(c40009323.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
		 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c40009323.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c40009323.tgfilter(c,tp)
	return Duel.IsExistingMatchingCard(c40009323.gyfilter,tp,0,LOCATION_ONFIELD,1,nil,c:GetColumnGroup()) and c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c40009323.gyfilter(c,g)
	return g:IsContains(c) 
end
function c40009323.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009323.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_ONFIELD)
end
function c40009323.gyop(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.SelectMatchingCard(tp,c40009323.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	if pg:GetCount()==0 then return end
	local g=Duel.GetMatchingGroup(c40009323.gyfilter,tp,0,LOCATION_ONFIELD,nil,pg:GetFirst():GetColumnGroup())
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
	   Duel.BreakEffect()
	   local tct=3
	   if Duel.GetTurnPlayer()~=tp then tct=2
	   elseif Duel.GetCurrentPhase()==PHASE_END then tct=3 end
	   Duel.GetControl(pg,tp,PHASE_END,tct)
	end
end
function c40009323.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c40009323.mtfilter(c,e)
	return c:IsCanOverlay() and c:IsCanBeEffectTarget(e)
end
function c40009323.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetEquipGroup()
	if chkc then return g:IsContains(chkc) and c40009323.mtfilter(chkc,e) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and g:IsExists(c40009323.mtfilter,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tg=g:FilterSelect(tp,c40009323.mtfilter,1,5,nil,e)
	Duel.SetTargetCard(tg)
end
function c40009323.matfilter(c,e)
	return c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c40009323.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c40009323.matfilter,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009323,1))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c40009323.atkcon)
	e1:SetOperation(c40009323.atkop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c40009323.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return a:IsControler(tp) and at and at:IsControler(1-tp) and a:GetBaseAttack()==0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) 
end
function c40009323.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(40009323,1)) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		Duel.ChangeAttackTarget(nil)
	end
end







