--last upd 2022-6-24
Seine_wangan={}
local wg=_G["Seine_wangan"]
wg.arty=0x6316
wg.arcode=31422000
wg.eqcode=31422100
function wg.super_emerge_filter(c,e,tp)
	if c:IsType(TYPE_MONSTER) then
		return c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
	else
		return c:IsSetCard(wg.arty) and (c:IsAbleToHand() or c:IsSSetable())
	end
end
function wg.emerge_mon_filter(c,eqc)
	if not c:IsType(TYPE_MONSTER) then return false end
	local con1=c:IsType(TYPE_NORMAL) or bit.band(eqc,1<<1)~=0
	local con3=c:IsRace(RACE_WARRIOR) or bit.band(eqc,1<<3)~=0
	local con4=c:IsAttribute(ATTRIBUTE_LIGHT) or bit.band(eqc,1<<4)~=0
	local con5=c:IsLevel(4) or bit.band(eqc,1<<5)~=0
	local con6=c:IsAttack(1400) or c:IsDefense(1400) or bit.band(eqc,1<<6)~=0
	return con1 and con3 and con4 and con5 and con6
end
function wg.emerge_st_filter(c,eqc)
	if c:IsType(TYPE_SPELL) then return bit.band(eqc,1<<7)~=0 end
	if c:IsType(TYPE_TRAP) then return bit.band(eqc,1<<8)~=0 end
	return false
end
function wg.get_emerge_group(c,e,tp,isop)
	local eqg=c:GetEquipGroup()
	local eqc=0
	eqg:ForEach(
		function(c)
			local eset={c:IsHasEffect(Seine_wangan.eqcode)}
			for _,te in pairs(eset) do
				eqc=bit.bor(eqc,1<<(te:GetLabel()))
			end
		end
	)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if bit.band(eqc,1<<2)~=0 then
		g:Merge(Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_GRAVE,0))
	end
	local g=g:Filter(wg.super_emerge_filter,nil,e,tp)
	local res_g=g:Filter(wg.emerge_mon_filter,nil,eqc)
	res_g:Merge(g:Filter(wg.emerge_st_filter,nil,eqc))
	if isop then
		res_g:Sub(res_g:Filter(Card.IsHasEffect,nil,EFFECT_NECRO_VALLEY))
	end
	return res_g
end
function wg.emerge_check_op(c,e,tp)
	if c:IsType(TYPE_MONSTER) then
		if c:IsAbleToHand() and (not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			return 0
		else
			return 1
		end
	end
	if c:IsAbleToHand() and (not c:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
		return 0
	else
		return 2
	end
end
function wg.equip_enable(c)
	local code=c:GetCode()
	c:SetUniqueOnField(1,0,code)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(wg.eqtg)
	e1:SetOperation(wg.eqop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(wg.eqlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(wg.eqcode)
	e3:SetLabel(code-wg.arcode-2)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(wg.eqcon)
	c:RegisterEffect(e3)
end
function wg.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function wg.eqfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function wg.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and wg.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(wg.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,wg.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function wg.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
function wg.eqcon(e)
	local tc=e:GetHandler():GetEquipTarget()
	return tc and tc:IsOriginalCodeRule(wg.arcode+2)
end
function wg.equip_trap_enable(c,loc)
	local code=c:GetCode()
	c:SetUniqueOnField(1,0,code)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(wg.equip_trap_cost)
	e1:SetTarget(wg.equip_trap_target)
	e1:SetOperation(wg.equip_trap_activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(wg.equip_trap_copyop)
	e2:SetLabel(loc)
	c:RegisterEffect(e2)
	if loc==LOCATION_ONFIELD then
		local e3=e2:Clone()
		e3:SetCode(EVENT_RETURN_TO_GRAVE)
		e3:SetLabel(nil)
		c:RegisterEffect(e3)
	end
end
function wg.equip_trap_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetOperation(wg.equip_trap_tgop)
	e2:SetLabel(cid)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function wg.equip_trap_tgop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return end
	if e:GetOwner():IsRelateToChain(ev) then
		e:GetOwner():CancelToGrave(false)
	end
end
function wg.equip_trap_filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function wg.equip_trap_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and wg.equip_trap_filter(chkc) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(wg.equip_trap_filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,wg.equip_trap_filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function wg.equip_trap_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(wg.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	else
		c:CancelToGrave(false)
	end
end
function wg.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() or e:GetHandler():GetEquipTarget()==c
end
function wg.equip_trap_copyfilter(c,loc,tp)
	local res=c:IsSetCard(wg.arty) and c:IsType(TYPE_EQUIP) and c:IsControler(tp)
	if loc then res=res and c:IsPreviousLocation(loc) end
	return res
end
function wg.equip_trap_copyop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(wg.equip_trap_copyfilter,nil,e:GetLabel())
	local c=e:GetHandler()
	g:ForEach(
		function (tc)
			local code=tc:GetOriginalCodeRule()
			if c:GetFlagEffect(code)>0 then return end
			Duel.Hint(HINT_CARD,tp,c:GetCode())
			Duel.HintSelection(Group.FromCards(tc))
			c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,nil)
			c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,0,0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(wg.eqcode)
			e1:SetLabel(code-wg.arcode-2)
			e1:SetRange(LOCATION_SZONE)
			e1:SetCondition(wg.eqcon)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	)
end