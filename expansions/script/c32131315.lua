--螺旋的愚人 维尔薇
function c32131315.initial_effect(c)
	aux.AddCodeList(c,32131314)
	aux.AddMaterialCodeList(c,32131314)
	--code
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE) 
	e0:SetRange(0xff) 
	e0:SetValue(32131314) 
	c:RegisterEffect(e0)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,32131314,c32131315.mfilter,1,true,true) 
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,32131315)
	e1:SetTarget(c32131315.thtg)
	e1:SetOperation(c32131315.thop)
	c:RegisterEffect(e1) 
	c32131315.sp_effect=e1 
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1)
	e2:SetTarget(c32131315.eqtg)
	e2:SetOperation(c32131315.eqop)
	c:RegisterEffect(e2) 
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c32131315.desreptg)
	e3:SetValue(c32131315.desrepval)
	e3:SetOperation(c32131315.desrepop)
	c:RegisterEffect(e3)
end
c32131315.SetCard_HR_flame13=true 
c32131315.HR_Flame_CodeList=32131314
function c32131315.mfilter(c) 
	return c.SetCard_HR_flame13 
end 
function c32131315.thfilter(c)
	return c.SetCard_HR_flame13 and c:IsAbleToHand() and c:IsType(TYPE_TRAP)
end
function c32131315.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32131315.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32131315.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32131315.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end 
end
function c32131315.eqfilter(c,tp,mc)
	return c.SetCard_HR_flame13 and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden() 
end
function c32131315.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c32131315.eqfilter,tp,LOCATION_GRAVE,0,1,nil,tp,e:GetHandler()) end 
	local g=Duel.SelectTarget(tp,c32131315.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,tp,0)
end
function c32131315.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end 
	local tc=Duel.GetFirstTarget() 
	if tc and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c) then return end 
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(function(e,c) 
		return e:GetOwner()==c end)
		tc:RegisterEffect(e1)
		local atk=tc:GetAttack()
		if atk>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(math.ceil(atk/2))
			tc:RegisterEffect(e2)
		end
	end
end
function c32131315.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c.SetCard_HR_flame13 and c:IsType(TYPE_MONSTER)
end
function c32131315.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	local eqg=c:GetEquipGroup()
	if chk==0 then return eg:IsExists(c32131315.repfilter,1,nil,tp)
		and eqg:GetCount()>0 end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c32131315.desrepval(e,c)
	return c32131315.repfilter(c,e:GetHandlerPlayer())
end
function c32131315.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local eqg=c:GetEquipGroup() 
	local dg=eqg:Select(tp,1,1,nil) 
	Duel.Destroy(dg,REASON_EFFECT+REASON_REPLACE) 
	Duel.Hint(HINT_CARD,0,32131315)
end





